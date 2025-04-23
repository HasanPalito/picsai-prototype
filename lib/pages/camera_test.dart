import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraStreamExample extends StatefulWidget {
  @override
  _CameraStreamExampleState createState() => _CameraStreamExampleState();
}

class _CameraStreamExampleState extends State<CameraStreamExample> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Fetch the available cameras
    cameras = await availableCameras();

    // Initialize the first available camera
    if (cameras != null && cameras!.isNotEmpty) {
      _cameraController = CameraController(
        cameras![0],
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      // Update the state after initializing the camera
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0.0),
          child: _cameraController != null && _cameraController!.value.isInitialized
              ? CameraPreview(_cameraController!)
              : Container(
            color: Colors.black,
            child: Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
