import 'dart:io';

import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:Outfitter/helpers/hive_helpers.dart';
import 'package:Outfitter/models/item.dart';
import 'package:Outfitter/services/firebase.dart';
import 'package:Outfitter/widgets/add_item_form.dart';
import 'package:camera/camera.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AddItemScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final FirebaseAnalytics analytics;

  const AddItemScreen({Key key, this.cameras, this.analytics})
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

  /// Add item when the form is complete.
  void onFormComplete(Item i) {
    //Add firebase.
    var f = FirebaseMethods();
    print("Adding...");
    f.addItem(i).then((value) => print("added!!!!"));

    // add to items box
    HiveHelpers.addItem(i);
    widget.analytics
        .logEvent(name: 'add_item_event', parameters: {'category': i.category});
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
    // if photo has been taken, switch from camera to add item form.
    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeIn,
      duration: const Duration(
        milliseconds: 300,
      ),
      child: isCamera
          ? CameraPreviewWidget(
              controller: controller, onTakePicture: onTakePicture)
          : _addItemForm(),
    );
  }

  Widget _addItemForm() {
    return DraggableBottomSheet(
      minExtent: MediaQuery.of(context).size.height * 0.2,
      maxExtent: MediaQuery.of(context).size.height * 0.8,
      backgroundWidget: _thumbnailWidget(),
      previewChild: PreviewFormWidget(context: context),
      expandedChild: _expandedForm(),
    );
  }

  Widget _expandedForm() {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(children: <Widget>[
          const Icon(
            Icons.keyboard_arrow_down,
            size: 30,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
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
          Expanded(
              child: AddItemFormWidget(
            image: imagePath,
            onFormComplete: onFormComplete,
          ))
        ]));
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return imagePath == null
        ? Container()
        : Stack(
            children: [
              GestureDetector(
                onTap: goToImageView,
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
                    onPressed: () {
                      Helper.deleteFile(imagePath);
                      setState(() {
                        isCamera = !isCamera;
                      });
                    },
                    child: Icon(Icons.undo),
                  ),
                ),
              )
            ],
          );
  }

  void goToImageView() {
    Navigator.push(
      context,
      MaterialPageRoute(
          settings: RouteSettings(name: 'image_view_page'),
          builder: (context) => ImageView(file: imagePath)),
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
    final extDir = await getExternalStorageDirectory();
    final dirPath = '${extDir.path}/items';
    await Directory(dirPath).create(recursive: true);
    final filePath = '$dirPath/${Helper.timestamp()}.jpg';
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
      padding: const EdgeInsets.symmetric(horizontal: 8),
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

  ImageView({this.file});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Hero(
              tag: file,
              child: Image.file(
                File(file),
                fit: BoxFit.contain,
              ),
            ),
          )),
    );
  }
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
              const Spacer(),
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
              const Spacer(),
//TODO: add help dialog here!
//              Expanded(
//                child: IconButton(
//                  icon: const Icon(Icons.info_outline),
//                  onPressed: () => print("HELP!"),
//                ),
//              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _cameraPreviewWidget() {
    return controller == null || !controller.value.isInitialized
        ? const Text('Initialising...')
        : AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller));
  }
}
