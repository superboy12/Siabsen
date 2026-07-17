import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/liveness_enums.dart';
import 'controllers/attendance_camera_controller.dart';
import 'widgets/face_detector_painter.dart';

class AttendanceCameraScreen extends ConsumerWidget {
  const AttendanceCameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(attendanceCameraControllerProvider);
    final controller = ref.read(attendanceCameraControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Camera Preview
            if (state.isInitialized && state.cameraController != null)
              _buildCameraPreview(state.cameraController!),
            
            // 2. Face Bounding Box Overlay
            if (state.currentFace != null && state.cameraController != null)
              _buildBoundingBox(state.currentFace!, state.cameraController!),

            // 3. UI Overlay
            _buildUIOverlay(context, state, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview(CameraController cameraController) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CameraPreview(cameraController),
    );
  }

  Widget _buildBoundingBox(Face face, CameraController cameraController) {
    // The image sizes from camera controller are usually landscape, even if we are in portrait.
    // For Android, width is larger. For iOS, it might be different.
    final imageSize = Size(
      cameraController.value.previewSize!.height,
      cameraController.value.previewSize!.width,
    );
    final rotation = InputImageRotationValue.fromRawValue(
            cameraController.description.sensorOrientation) ??
        InputImageRotation.rotation0deg;

    return CustomPaint(
      painter: FaceDetectorPainter(
        face: face,
        imageSize: imageSize,
        rotation: rotation,
      ),
    );
  }

  Widget _buildUIOverlay(
      BuildContext context, state, AttendanceCameraController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Top section (Back button and Title)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Expanded(
                child: Text(
                  'Liveness Check',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance for back button
            ],
          ),
        ),

        // Middle section (Face Guide Oval or just empty space)
        Expanded(
          child: Center(
            child: state.step == LivenessStep.success
                ? const Icon(Icons.check_circle, color: Colors.green, size: 100)
                : Container(
                    width: 250,
                    height: 350,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: state.step == LivenessStep.doingChallenge
                            ? Colors.orange
                            : Colors.white54,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(150), // Oval
                    ),
                  ),
          ),
        ),

        // Bottom section (Instructions & Preview)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.step == LivenessStep.preview && state.capturedImagePath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(state.capturedImagePath!),
                    height: 150,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => controller.retakePhoto(),
                      child: const Text('Ulangi', style: TextStyle(color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                         // TODO: Submit to server
                         Navigator.of(context).pop(state.capturedImagePath);
                      },
                      child: const Text('Gunakan Foto'),
                    )
                  ],
                )
              ] else ...[
                Text(
                  state.instructionMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                if (state.step == LivenessStep.doingChallenge || state.step == LivenessStep.success)
                  LinearProgressIndicator(
                    value: state.challengeProgress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
