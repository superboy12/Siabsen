import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/location_service.dart';
import '../../domain/office_location.dart';

enum AttendanceStatus {
  loading,
  permissionDenied,
  serviceDisabled,
  valid, // Inside radius & no mock
  outOfRadius, // Outside radius
  mockDetected, // Fake GPS
  error,
}

class AttendanceState {
  final AttendanceStatus status;
  final Position? position;
  final double distanceToOffice;
  final String errorMessage;

  AttendanceState({
    required this.status,
    this.position,
    this.distanceToOffice = 0.0,
    this.errorMessage = '',
  });

  AttendanceState copyWith({
    AttendanceStatus? status,
    Position? position,
    double? distanceToOffice,
    String? errorMessage,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      position: position ?? this.position,
      distanceToOffice: distanceToOffice ?? this.distanceToOffice,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final locationServiceProvider = Provider((ref) => LocationService());

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  return AttendanceNotifier(locationService);
});

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final LocationService _locationService;
  StreamSubscription<Position>? _positionSubscription;

  AttendanceNotifier(this._locationService) : super(AttendanceState(status: AttendanceStatus.loading)) {
    _init();
  }

  Future<void> _init() async {
    final hasPermission = await _locationService.handlePermission();
    if (!hasPermission) {
      state = state.copyWith(status: AttendanceStatus.permissionDenied, errorMessage: 'Akses lokasi ditolak.');
      return;
    }

    _positionSubscription = _locationService.getLocationStream().listen(
      (Position position) {
        _processPosition(position);
      },
      onError: (error) {
        state = state.copyWith(status: AttendanceStatus.error, errorMessage: error.toString());
      },
    );
  }

  void _processPosition(Position position) {
    // 1. Check Mock Location
    if (position.isMocked) {
      state = state.copyWith(
        status: AttendanceStatus.mockDetected,
        position: position,
        errorMessage: 'Fake GPS terdeteksi. Harap matikan mock location.',
      );
      return;
    }

    // 2. Check Distance
    final distance = _locationService.calculateDistance(
      position.latitude,
      position.longitude,
      OfficeLocation.latitude,
      OfficeLocation.longitude,
    );

    if (distance > OfficeLocation.maxRadius) {
      state = state.copyWith(
        status: AttendanceStatus.outOfRadius,
        position: position,
        distanceToOffice: distance,
        errorMessage: 'Anda berada di luar area absensi (${distance.toStringAsFixed(0)}m).',
      );
    } else {
      state = state.copyWith(
        status: AttendanceStatus.valid,
        position: position,
        distanceToOffice: distance,
        errorMessage: 'Lokasi valid (${distance.toStringAsFixed(0)}m).',
      );
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
