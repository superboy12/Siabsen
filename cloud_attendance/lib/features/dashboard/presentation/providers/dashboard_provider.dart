import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/attendance_summary.dart';

final dashboardProvider = StateNotifierProvider<DashboardNotifier, AsyncValue<List<AttendanceSummary>>>((ref) {
  return DashboardNotifier();
});

class DashboardNotifier extends StateNotifier<AsyncValue<List<AttendanceSummary>>> {
  DashboardNotifier() : super(const AsyncValue.loading()) {
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    state = const AsyncValue.loading();
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final today = DateTime.now();
    
    final history = [
      AttendanceSummary(
        date: today,
        checkInTime: '07:45',
        checkOutTime: '--:--',
        status: 'Hadir',
      ),
      AttendanceSummary(
        date: today.subtract(const Duration(days: 1)),
        checkInTime: '07:50',
        checkOutTime: '17:05',
        status: 'Hadir',
      ),
      AttendanceSummary(
        date: today.subtract(const Duration(days: 2)),
        checkInTime: '08:15', // Late
        checkOutTime: '17:10',
        status: 'Terlambat',
      ),
    ];
    
    state = AsyncValue.data(history);
  }
}
