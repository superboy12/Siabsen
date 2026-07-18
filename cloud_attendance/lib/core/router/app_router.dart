import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/attendance/presentation/screens/attendance_map_screen.dart';
import '../../features/attendance/presentation/check_in_screen.dart';
import '../../features/attendance/presentation/check_out_screen.dart';
import '../../features/attendance/presentation/camera_screen.dart';
import '../../features/attendance/presentation/history_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/dashboard/presentation/screens/main_screen.dart';

// Admin Imports
import '../../features/admin/presentation/layouts/admin_layout.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/employee_management_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => const AttendanceMapScreen(),
    ),
    GoRoute(
      path: '/check-in',
      builder: (context, state) => const CheckInScreen(),
    ),
    GoRoute(
      path: '/check-out',
      builder: (context, state) => const CheckOutScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const AttendanceCameraScreen(),
    ),
    
    // Admin Routes
    ShellRoute(
      builder: (context, state, child) {
        return AdminLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/employees',
          builder: (context, state) => const EmployeeManagementScreen(),
        ),
        // Placeholders for other admin routes
        GoRoute(
          path: '/admin/attendance',
          builder: (context, state) => const Center(child: Text('Halaman Absensi')),
        ),
        GoRoute(
          path: '/admin/monitoring',
          builder: (context, state) => const Center(child: Text('Halaman Monitoring')),
        ),
        GoRoute(
          path: '/admin/map',
          builder: (context, state) => const Center(child: Text('Halaman Peta Kehadiran')),
        ),
        GoRoute(
          path: '/admin/reports',
          builder: (context, state) => const Center(child: Text('Halaman Laporan')),
        ),
        GoRoute(
          path: '/admin/analytics',
          builder: (context, state) => const Center(child: Text('Halaman Analitik')),
        ),
        GoRoute(
          path: '/admin/divisions',
          builder: (context, state) => const Center(child: Text('Halaman Divisi')),
        ),
        GoRoute(
          path: '/admin/office',
          builder: (context, state) => const Center(child: Text('Halaman Lokasi Kantor')),
        ),
        GoRoute(
          path: '/admin/holidays',
          builder: (context, state) => const Center(child: Text('Halaman Hari Libur')),
        ),
        GoRoute(
          path: '/admin/work-hours',
          builder: (context, state) => const Center(child: Text('Halaman Jam Kerja')),
        ),
        GoRoute(
          path: '/admin/settings',
          builder: (context, state) => const Center(child: Text('Halaman Pengaturan')),
        ),
        GoRoute(
          path: '/admin/logs',
          builder: (context, state) => const Center(child: Text('Halaman Log Aktivitas')),
        ),
        GoRoute(
          path: '/admin/profile',
          builder: (context, state) => const Center(child: Text('Halaman Profile')),
        ),
      ],
    ),
  ],
);
