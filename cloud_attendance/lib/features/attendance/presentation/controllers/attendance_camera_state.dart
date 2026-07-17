import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../domain/liveness_enums.dart';

class AttendanceCameraState {
  final bool isInitialized;
  final CameraController? cameraController;
  final LivenessStep step;
  final LivenessChallenge? activeChallenge;
  final Face? currentFace;
  final String instructionMessage;
  final double challengeProgress;
  final String? capturedImagePath;

  AttendanceCameraState({
    this.isInitialized = false,
    this.cameraController,
    this.step = LivenessStep.initializing,
    this.activeChallenge,
    this.currentFace,
    this.instructionMessage = 'Inisialisasi Kamera...',
    this.challengeProgress = 0.0,
    this.capturedImagePath,
  });

  AttendanceCameraState copyWith({
    bool? isInitialized,
    CameraController? cameraController,
    LivenessStep? step,
    LivenessChallenge? activeChallenge,
    Face? currentFace,
    String? instructionMessage,
    double? challengeProgress,
    String? capturedImagePath,
  }) {
    return AttendanceCameraState(
      isInitialized: isInitialized ?? this.isInitialized,
      cameraController: cameraController ?? this.cameraController,
      step: step ?? this.step,
      activeChallenge: activeChallenge ?? this.activeChallenge,
      currentFace: currentFace ?? this.currentFace,
      instructionMessage: instructionMessage ?? this.instructionMessage,
      challengeProgress: challengeProgress ?? this.challengeProgress,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
    );
  }
}
