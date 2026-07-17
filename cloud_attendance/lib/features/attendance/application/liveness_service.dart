import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../domain/liveness_enums.dart';

class LivenessService {
  bool _hasBlinkedDown = false;
  bool _hasNoddedDown = false;

  void reset() {
    _hasBlinkedDown = false;
    _hasNoddedDown = false;
  }

  bool validateFaceQuality(Face face) {
    // Basic quality checks
    // Face shouldn't be too tilted sideways
    if (face.headEulerAngleZ != null) {
      if (face.headEulerAngleZ!.abs() > 15) return false;
    }
    
    // Face shouldn't be looking away too much when supposed to be centered
    if (face.headEulerAngleY != null && face.headEulerAngleX != null) {
       if (face.headEulerAngleY!.abs() > 15 || face.headEulerAngleX!.abs() > 15) {
         // return false; // This might be too strict during challenges that require looking away
       }
    }

    return true; // We can add more bounding box size checks here
  }

  bool checkChallenge(LivenessChallenge challenge, Face face) {
    switch (challenge) {
      case LivenessChallenge.blink:
        return _checkBlink(face);
      case LivenessChallenge.nod:
        return _checkNod(face);
      case LivenessChallenge.lookLeft:
        return _checkLookLeft(face);
      case LivenessChallenge.lookRight:
        return _checkLookRight(face);
    }
  }

  bool _checkBlink(Face face) {
    final leftEye = face.leftEyeOpenProbability;
    final rightEye = face.rightEyeOpenProbability;

    if (leftEye == null || rightEye == null) return false;

    // Both eyes closed
    if (leftEye < 0.2 && rightEye < 0.2) {
      _hasBlinkedDown = true;
    }

    // Both eyes opened again after being closed
    if (_hasBlinkedDown && leftEye > 0.8 && rightEye > 0.8) {
      return true;
    }

    return false;
  }

  bool _checkNod(Face face) {
    final pitch = face.headEulerAngleX; // Up and down
    if (pitch == null) return false;

    // Nod down
    if (pitch < -12) {
      _hasNoddedDown = true;
    }

    // Return to center or look up
    if (_hasNoddedDown && pitch > 0) {
      return true;
    }

    return false;
  }

  bool _checkLookLeft(Face face) {
    final yaw = face.headEulerAngleY; // Left and right
    if (yaw == null) return false;

    // Looking left (might be positive or negative depending on camera mirroring, 
    // typically positive is looking to the right of the image, so user's left)
    return yaw > 25; 
  }

  bool _checkLookRight(Face face) {
    final yaw = face.headEulerAngleY;
    if (yaw == null) return false;

    // Looking right
    return yaw < -25;
  }
}
