class AttendanceSummary {
  final DateTime date;
  final String checkInTime;
  final String checkOutTime;
  final String status;

  AttendanceSummary({
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.status,
  });
}
