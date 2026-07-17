import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPainter extends CustomPainter {
  final Face? face;
  final Size imageSize;
  final InputImageRotation rotation;

  FaceDetectorPainter({
    required this.face,
    required this.imageSize,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (face == null) return;

    final Paint paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.green;

    final double scaleX = size.width / imageSize.height; // Because portrait mode
    final double scaleY = size.height / imageSize.width;

    double translateX(double x) {
      if (Platform.isAndroid) {
        return size.width - (x * scaleX); // Mirrored for front camera
      } else {
         // iOS might not need mirroring depending on how it's captured
         return size.width - (x * (size.width / imageSize.width));
      }
    }

    double translateY(double y) {
      if (Platform.isAndroid) {
         return y * scaleY;
      } else {
         return y * (size.height / imageSize.height);
      }
    }
    
    // Simplistic bounding box for portrait mode
    if (Platform.isAndroid) {
       final left = translateX(face!.boundingBox.right);
       final right = translateX(face!.boundingBox.left);
       final top = translateY(face!.boundingBox.top);
       final bottom = translateY(face!.boundingBox.bottom);
       canvas.drawRect(
         Rect.fromLTRB(left, top, right, bottom),
         paint1,
       );
    } else {
       final left = size.width - (face!.boundingBox.right * (size.width / imageSize.width));
       final right = size.width - (face!.boundingBox.left * (size.width / imageSize.width));
       final top = face!.boundingBox.top * (size.height / imageSize.height);
       final bottom = face!.boundingBox.bottom * (size.height / imageSize.height);
       canvas.drawRect(
         Rect.fromLTRB(left, top, right, bottom),
         paint1,
       );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.face != face || 
           oldDelegate.imageSize != imageSize || 
           oldDelegate.rotation != rotation;
  }
}
