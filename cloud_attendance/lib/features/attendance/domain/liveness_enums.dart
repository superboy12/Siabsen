enum LivenessStep {
  initializing,
  detectingFace,
  doingChallenge,
  success,
  capturing,
  preview,
}

enum LivenessChallenge {
  blink,
  nod,
  lookLeft,
  lookRight,
}

extension LivenessChallengeExtension on LivenessChallenge {
  String get instructionMessage {
    switch (this) {
      case LivenessChallenge.blink:
        return 'Silakan berkedip';
      case LivenessChallenge.nod:
        return 'Silakan mengangguk';
      case LivenessChallenge.lookLeft:
        return 'Silakan lihat ke kiri';
      case LivenessChallenge.lookRight:
        return 'Silakan lihat ke kanan';
    }
  }
}
