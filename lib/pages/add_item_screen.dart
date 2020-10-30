import 'dart:io';

import 'package:Outfitter/helpers/helper_methods.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class AddItemScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const AddItemScreen({Key key, this.cameras}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
//    return Column(
//      children: [_cameraPreview()],
//    );
    return AnimatedCrossFade(
        firstChild: _cameraPreview(),
        secondChild: _addItemForm(),
        crossFadeState:
            isCamera ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300));
  }

  Widget _addItemForm() {
    return Card(
      child: Column(
        children: [
          _thumbnailWidget(),
          FloatingActionButton(
              child: Icon(Icons.delete_outline),
              onPressed: () {
                Helper.deleteFile(imagePath).then((value) => {
                      if (value) {onDeleteImage()}
                    });
              }),
        ],
      ),
    );
  }

  Widget _cameraPreview() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 28),
          color: Colors.yellow,
          child: Center(
            child: _cameraPreviewWidget(),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: controller != null &&
                      controller.value.isInitialized &&
                      !controller.value.isRecordingVideo
                  ? onTakePictureButtonPressed
                  : null,
              child: Icon(Icons.camera_alt),
            ))
      ],
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
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
//
//    return AnimatedCrossFade(
//        firstChild: const Text(
//          'Initialising...',
//          style: const TextStyle(
//            color: Colors.white,
//            fontSize: 24.0,
//            letterSpacing: 3,
//          ),
//        ),
//        secondChild: AspectRatio(
//            aspectRatio: controller.value.aspectRatio,
//            child: CameraPreview(controller)),
//        crossFadeState: controller == null || !controller.value.isInitialized
//            ? CrossFadeState.showFirst
//            : CrossFadeState.showSecond,
//        duration: const Duration(milliseconds: 300));
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          imagePath == null
              ? Container()
              : SizedBox(
                  child: Image.file(File(imagePath)),
                  width: 64.0,
                  height: 64.0,
                ),
        ],
      ),
    );
  }

  void showInSnackBar(String message) {
    print(message);
  }

  void onTakePictureButtonPressed() {
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
