import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/modern_card.dart';
import '../../domain/office_location.dart';
import '../providers/attendance_provider.dart';

class AttendanceMapScreen extends ConsumerStatefulWidget {
  const AttendanceMapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AttendanceMapScreen> createState() => _AttendanceMapScreenState();
}

class _AttendanceMapScreenState extends ConsumerState<AttendanceMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  
  static const CameraPosition _officePosition = CameraPosition(
    target: LatLng(OfficeLocation.latitude, OfficeLocation.longitude),
    zoom: 17.5,
  );

  @override
  Widget build(BuildContext context) {
    final attendanceState = ref.watch(attendanceProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildGoogleMap(attendanceState),
          _buildFloatingStatusCard(attendanceState),
          _buildBottomAction(attendanceState),
        ],
      ),
    );
  }

  Widget _buildGoogleMap(AttendanceState state) {
    Set<Marker> markers = {
      const Marker(
        markerId: MarkerId('office'),
        position: LatLng(OfficeLocation.latitude, OfficeLocation.longitude),
        infoWindow: InfoWindow(title: 'Kantor Pusat'),
      ),
    };

    if (state.position != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: LatLng(state.position!.latitude, state.position!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Posisi Anda'),
        ),
      );
    }

    final isOutOfRadius = state.status == AttendanceStatus.outOfRadius || state.status == AttendanceStatus.mockDetected;
    final circleColor = isOutOfRadius ? AppColors.error : AppColors.success;

    Set<Circle> circles = {
      Circle(
        circleId: const CircleId('geofence'),
        center: const LatLng(OfficeLocation.latitude, OfficeLocation.longitude),
        radius: OfficeLocation.maxRadius,
        fillColor: circleColor.withValues(alpha: 0.15),
        strokeColor: circleColor.withValues(alpha: 0.5),
        strokeWidth: 2,
      ),
    };

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _officePosition,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: markers,
      circles: circles,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Widget _buildFloatingStatusCard(AttendanceState state) {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: ModernCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status Lokasi',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      Text(
                        _getStatusTitle(state.status),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(state.status),
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.status == AttendanceStatus.loading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Text(
                    '${state.distanceToOffice.toStringAsFixed(0)} m',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
              ],
            ),
            if (state.errorMessage.isNotEmpty && state.status != AttendanceStatus.valid) ...[
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.warning_rounded, color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: AppColors.error, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction(AttendanceState state) {
    final bool isValid = state.status == AttendanceStatus.valid;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isValid ? () {
            // Lanjut verifikasi wajah placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Membuka Kamera Verifikasi Wajah...')),
            );
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isValid ? AppColors.primary : AppColors.border,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_rounded, color: isValid ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                isValid ? 'Lanjut Verifikasi Wajah\n(Absen Masuk)' : 'Tidak Dapat Absen\n(Luar Area)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isValid ? Colors.white : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusTitle(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.valid: return 'Dalam Radius';
      case AttendanceStatus.outOfRadius: return 'Di luar radius';
      case AttendanceStatus.mockDetected: return 'Lokasi Palsu Terdeteksi';
      case AttendanceStatus.loading: return 'Mencari Lokasi...';
      case AttendanceStatus.permissionDenied: return 'Izin Ditolak';
      default: return 'Tidak Diketahui';
    }
  }

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.valid: return AppColors.success;
      case AttendanceStatus.outOfRadius: return AppColors.error;
      case AttendanceStatus.mockDetected: return AppColors.error;
      case AttendanceStatus.loading: return AppColors.warning;
      default: return AppColors.textPrimary;
    }
  }
}
