import 'dart:io';

import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/models/person.dart';
import 'package:Outfitter/widgets/add_item_form.dart';
import 'package:camera/camera.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AddItemScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Person person;

  const AddItemScreen({Key key, @required this.person, this.cameras})
      : super(key: key);

  @override
  _AddItemScreenState createState() {
    return _AddItemScreenState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _AddItemScreenState extends State<AddItemScreen>
    with WidgetsBindingObserver {
  CameraController controller;
  String imagePath;
  bool isCamera = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCamera();
  }

  void initCamera() {
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.max,
    );
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        initCamera();
      }
    }
  }

  /// Add item to Person object when the form is complete.
  void onFormComplete(Item i) {
    widget.person.addItem(i);
    setState(() {
      isCamera = true;
      imagePath = null;
    });
    // Show some feedback using a SnackBar.
    Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Item has been added!')));
  }

  @override
  Widget build(BuildContext context) {
    return isCamera
        ? CameraPreviewWidget(
            controller: controller, onTakePicture: onTakePicture)
        : _addItemForm();
  }

  Widget _addItemForm() {
    List<IconData> icons = [
      Icons.ac_unit,
      Icons.account_balance,
      Icons.adb,
      Icons.add_photo_alternate,
      Icons.format_line_spacing
    ];

    return DraggableBottomSheet(
      minExtent: MediaQuery.of(context).size.height * 0.2,
      maxExtent: MediaQuery.of(context).size.height * 0.8,
      backgroundWidget: _thumbnailWidget(),
      previewChild: PreviewFormWidget(context: context),
      expandedChild: _expandedForm(icons),
    );
  }

  Widget _expandedForm(List<IconData> icons) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.keyboard_arrow_down,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Enter Item Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Divider(
            thickness: 2,
            color: Theme.of(context).accentColor,
            indent: 16,
            endIndent: 16,
          ),
//          const SizedBox(
//            height: 16,
//          ),
//          FloatingActionButton(
//              child: Icon(Icons.delete_outline),
//              onPressed: () {
//                Helper.deleteFile(imagePath).then((value) => {
//                      if (value) {onDeleteImage()}
//                    });
//              }),
          Expanded(
            child: AddItemFormWidget(
              image: imagePath,
              onFormComplete: onFormComplete,
            ),
          )
//          Expanded(
//            child: GridView.builder(
//                itemCount: icons.length,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount: 1,
//                  crossAxisSpacing: 10,
//                  mainAxisSpacing: 10,
//                ),
//                itemBuilder: (context, index) => AnimatedContainer(
//                      decoration: BoxDecoration(
//                          color: Colors.white,
//                          borderRadius: BorderRadius.circular(20)),
//                      duration: const Duration(milliseconds: 300),
//                      child: Icon(
//                        icons[index],
//                        color: Colors.pink,
//                        size: 40,
//                      ),
//                    )),
//          )
        ],
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return imagePath == null
        ? Container()
        : Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageView(file: imagePath)),
                  );
                },
                child: Hero(
                  tag: imagePath,
                  child: Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    tooltip: "Redo photo",
                    child: Icon(Icons.undo),
                    onPressed: () {
                      Helper.deleteFile(imagePath);
                      setState(() {
                        isCamera = !isCamera;
                      });
                    },
                  ),
                ),
              )
            ],
          );
  }

  void showInSnackBar(String message) {
    print(message);
  }

  void onTakePicture() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
          isCamera = false;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getExternalStorageDirectory();
    final String dirPath = '${extDir.path}/items';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${Helper.timestamp()}.jpg';
    // A capture is already pending, do nothing.
    if (controller.value.isTakingPicture) return null;
    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      logError(e.code, e.description);
      return null;
    }
    return filePath;
  }

  void onDeleteImage() {
    setState(() {
      imagePath = null;
    });
  }
}

class PreviewFormWidget extends StatelessWidget {
  const PreviewFormWidget({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.keyboard_arrow_up,
            size: 30,
            color: Colors.white,
          ),
          Expanded(
            child: Center(
              child: const Text(
                'Drag up to enter item details',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  final String file;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.file(
            File(file),
            fit: BoxFit.contain,
          )),
    );
  }

  ImageView({this.file});
}

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  final Function onTakePicture;

  CameraPreviewWidget({this.controller, this.onTakePicture});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _cameraPreviewWidget(),
        Expanded(
          child: Row(
            children: [
              Spacer(),
              Expanded(
                child: FloatingActionButton(
                  tooltip: "Take picture of item",
                  onPressed: controller != null &&
                          controller.value.isInitialized &&
                          !controller.value.isRecordingVideo
                      ? onTakePicture
                      : null,
                  child: const Icon(Icons.camera_alt),
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => print("HELP!"),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Initialising...',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          letterSpacing: 3,
        ),
      );
    } else {
      return AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller));
    }
  }
}
