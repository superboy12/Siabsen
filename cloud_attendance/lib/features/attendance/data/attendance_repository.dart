import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/attendance_record.dart';

final attendanceRepositoryProvider = Provider((ref) => AttendanceRepository());

class AttendanceRepository {
  Future<List<AttendanceRecord>> getHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      AttendanceRecord(
        id: '1',
        date: DateTime.now(),
        checkInTime: DateTime.now().subtract(const Duration(hours: 4)),
        status: 'Present',
        location: 'Office HQ',
      ),
      AttendanceRecord(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 1)),
        checkInTime: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        checkOutTime: DateTime.now().subtract(const Duration(days: 1, hours: 0)),
        status: 'Present',
        location: 'Office HQ',
      ),
      AttendanceRecord(
        id: '3',
        date: DateTime.now().subtract(const Duration(days: 2)),
        checkInTime: DateTime.now().subtract(const Duration(days: 2, hours: 8, minutes: 15)),
        checkOutTime: DateTime.now().subtract(const Duration(days: 2, hours: 0)),
        status: 'Late',
        location: 'Office HQ',
      ),
    ];
  }

  Future<void> checkIn() async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock save check-in
  }

  Future<void> checkOut() async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock save check-out
  }
}
