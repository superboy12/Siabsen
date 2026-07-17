import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../shared/widgets/gov_app_bar.dart';
import '../../../shared/widgets/gov_card.dart';
import '../../../shared/widgets/menu_grid.dart';
import '../../../shared/widgets/info_card.dart';
import '../../../core/theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: const GovAppBar(
        title: 'Beranda',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Summary Card
            GovCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ahmad Pegawai, S.Kom.',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NIP. 19800101 200501 1 001',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pranata Komputer Ahli Muda',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Text(
                          'Pusat Data dan Informasi',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Announcement Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                border: Border.all(color: AppColors.warning.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.campaign, color: AppColors.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pemberitahuan: Waktu absensi pagi ditutup pada pukul 08:00 WIB.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Attendance Status Section
            Text(
              'Status Kehadiran',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    title: 'Jam Masuk',
                    value: '07:25 WIB',
                    icon: Icons.login,
                    iconColor: AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InfoCard(
                    title: 'Jam Pulang',
                    value: '--:-- WIB',
                    icon: Icons.logout,
                    iconColor: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InfoCard(
              title: 'Tanggal',
              value: dateFormat.format(now),
              icon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            const InfoCard(
              title: 'Lokasi Kantor',
              value: 'Kantor Pusat - Gedung A',
              icon: Icons.business,
            ),
            const SizedBox(height: 32),

            // Menu Section
            Text(
              'Menu Utama',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            MenuGrid(
              crossAxisCount: 3,
              items: [
                MenuItem(
                  title: 'Check In',
                  icon: Icons.how_to_reg,
                  onTap: () => context.push('/check-in'),
                ),
                MenuItem(
                  title: 'Check Out',
                  icon: Icons.directions_run,
                  onTap: () => context.push('/check-out'),
                ),
                MenuItem(
                  title: 'Riwayat',
                  icon: Icons.history,
                  onTap: () => context.push('/history'),
                ),
                MenuItem(
                  title: 'Profil',
                  icon: Icons.person_outline,
                  onTap: () => context.push('/profile'),
                ),
                MenuItem(
                  title: 'Pengaturan',
                  icon: Icons.settings_outlined,
                  onTap: () => context.push('/settings'),
                ),
                MenuItem(
                  title: 'Bantuan',
                  icon: Icons.help_outline,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pusat Bantuan belum tersedia')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
