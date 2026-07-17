import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService {
  static final FaceDetectionService _instance = FaceDetectionService._internal();

  factory FaceDetectionService() {
    return _instance;
  }

  FaceDetectionService._internal();

  late final FaceDetector _faceDetector;

  void initialize() {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // For eye open probabilities
        enableTracking: true, // For tracking specific face ID
        enableContours: false,
        enableLandmarks: false,
        performanceMode: FaceDetectorMode.fast, // We need speed for real-time
      ),
    );
  }

  Future<List<Face>> processCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) async {
    final inputImage = _inputImageFromCameraImage(image, camera);
    if (inputImage == null) return [];

    try {
      return await _faceDetector.processImage(inputImage);
    } catch (e) {
      debugPrint('Error detecting faces: $e');
      return [];
    }
  }

  InputImage? _inputImageFromCameraImage(
    CameraImage image,
    CameraDescription camera,
  ) {
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) 
        ?? InputImageRotation.rotation0deg;

    // For Android, usually NV21, iOS BGRA8888
    final plane = image.planes.first;
    
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Future<void> dispose() async {
    await _faceDetector.close();
  }
}
