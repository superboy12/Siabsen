import 'package:flutter/material.dart';
import '../../../shared/widgets/gov_app_bar.dart';
import '../../../shared/widgets/gov_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GovAppBar(title: 'Profil Pegawai'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Photo & Basic Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Detailed Info Card
            GovCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Kepegawaian',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(context, 'Nama Lengkap', 'Ahmad Pegawai, S.Kom.'),
                  const Divider(),
                  _buildInfoRow(context, 'NIP', '19800101 200501 1 001'),
                  const Divider(),
                  _buildInfoRow(context, 'Email', 'ahmad.pegawai@instansi.go.id'),
                  const Divider(),
                  _buildInfoRow(context, 'Nomor HP', '081234567890'),
                  const Divider(),
                  _buildInfoRow(context, 'Jabatan', 'Pranata Komputer Ahli Muda'),
                  const Divider(),
                  _buildInfoRow(context, 'Unit Kerja', 'Pusat Data dan Informasi'),
                  const Divider(),
                  _buildInfoRow(context, 'Status Pegawai', 'Pegawai Negeri Sipil (PNS)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
