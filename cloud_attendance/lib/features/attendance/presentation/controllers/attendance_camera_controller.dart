import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/camera_service.dart';
import '../../../../core/services/face_detection_service.dart';
import '../../application/liveness_service.dart';
import '../../domain/liveness_enums.dart';
import 'attendance_camera_state.dart';

final attendanceCameraControllerProvider =
    NotifierProvider.autoDispose<AttendanceCameraController, AttendanceCameraState>(() {
  return AttendanceCameraController();
});

class AttendanceCameraController extends AutoDisposeNotifier<AttendanceCameraState> {
  @override
  AttendanceCameraState build() {
    ref.onDispose(() {
      _cameraService.dispose();
      _faceDetectionService.dispose();
    });
    Future.microtask(() => _initCamera());
    return AttendanceCameraState();
  }

  final CameraService _cameraService = CameraService();
  final FaceDetectionService _faceDetectionService = FaceDetectionService();
  final LivenessService _livenessService = LivenessService();

  bool _isProcessingFrame = false;

  Future<void> _initCamera() async {
    state = state.copyWith(
      step: LivenessStep.initializing,
      instructionMessage: 'Membuka kamera...',
    );

    try {
      await _cameraService.initialize();
      _faceDetectionService.initialize();

      state = state.copyWith(
        isInitialized: true,
        cameraController: _cameraService.cameraController,
        step: LivenessStep.detectingFace,
        instructionMessage: 'Posisikan wajah Anda di tengah kotak',
      );

      _startImageStream();
    } catch (e) {
      state = state.copyWith(
        instructionMessage: 'Gagal membuka kamera: $e',
      );
    }
  }

  void _startImageStream() {
    _cameraService.startImageStream((image) async {
      if (_isProcessingFrame) return;
      if (state.step == LivenessStep.success || state.step == LivenessStep.capturing || state.step == LivenessStep.preview) {
        return;
      }

      _isProcessingFrame = true;

      try {
        final faces = await _faceDetectionService.processCameraImage(
          image,
          _cameraService.cameraDescription!,
        );

        if (faces.isEmpty) {
          if (state.step == LivenessStep.detectingFace) {
             state = state.copyWith(
               currentFace: null,
               instructionMessage: 'Wajah tidak terdeteksi',
             );
          }
        } else if (faces.length > 1) {
           state = state.copyWith(
               currentFace: null,
               instructionMessage: 'Hanya satu wajah yang diperbolehkan',
           );
        } else {
          final face = faces.first;
          
          if (state.step == LivenessStep.detectingFace) {
            if (_livenessService.validateFaceQuality(face)) {
              // Quality is good, start challenge
              _startRandomChallenge();
            } else {
              state = state.copyWith(
                currentFace: face,
                instructionMessage: 'Pastikan wajah berada di tengah dan terlihat jelas',
              );
            }
          } else if (state.step == LivenessStep.doingChallenge) {
             final passed = _livenessService.checkChallenge(state.activeChallenge!, face);
             
             if (passed) {
               _onChallengeSuccess();
             } else {
               // Update state with face info while doing challenge
               state = state.copyWith(currentFace: face);
             }
          }
        }
      } finally {
        _isProcessingFrame = false;
      }
    });
  }

  void _startRandomChallenge() {
    final challenges = LivenessChallenge.values;
    final random = Random();
    final selectedChallenge = challenges[random.nextInt(challenges.length)];
    
    _livenessService.reset();
    
    state = state.copyWith(
      step: LivenessStep.doingChallenge,
      activeChallenge: selectedChallenge,
      instructionMessage: selectedChallenge.instructionMessage,
      challengeProgress: 0.0,
    );
  }

  Future<void> _onChallengeSuccess() async {
    state = state.copyWith(
      step: LivenessStep.success,
      instructionMessage: 'Verifikasi berhasil!',
      challengeProgress: 1.0,
      currentFace: null,
    );

    // Give a short delay for user to see success message before capturing
    await Future.delayed(const Duration(milliseconds: 800));
    
    state = state.copyWith(
      step: LivenessStep.capturing,
      instructionMessage: 'Mengambil foto...',
    );

    final file = await _cameraService.takePicture();
    
    if (file != null) {
      state = state.copyWith(
        step: LivenessStep.preview,
        capturedImagePath: file.path,
        instructionMessage: 'Foto berhasil diambil',
      );
    } else {
      state = state.copyWith(
        step: LivenessStep.detectingFace,
        instructionMessage: 'Gagal mengambil foto, silakan coba lagi',
      );
      _startImageStream(); // restart stream
    }
  }
  
  void retakePhoto() {
    state = state.copyWith(
      step: LivenessStep.detectingFace,
      capturedImagePath: null,
      instructionMessage: 'Posisikan wajah Anda di tengah kotak',
    );
    _startImageStream();
  }

}
