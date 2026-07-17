import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/gov_app_bar.dart';
import '../../../shared/widgets/primary_button.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String? _capturedImagePath;

  void _startCamera() async {
    final result = await context.push<String>('/camera');
    if (result != null && mounted) {
      setState(() {
        _capturedImagePath = result;
      });
    }
  }

  void _submitAttendance() async {
    // Simulasi submit ke backend
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context); // close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Absen Pulang Berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GovAppBar(title: 'Check Out Kehadiran'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.face,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Verifikasi Wajah (Liveness)',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Pastikan wajah Anda terlihat jelas, berada di tempat terang, dan ikuti instruksi gerakan (berkedip, menoleh, dsb) untuk membuktikan liveness.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_capturedImagePath == null) ...[
              PrimaryButton(
                text: 'Mulai Absensi Wajah',
                onPressed: _startCamera,
                icon: Icons.camera_alt,
              ),
            ] else ...[
              const Text(
                'Hasil Foto:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(_capturedImagePath!),
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _startCamera,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Ulangi Foto'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Kirim Absen',
                      onPressed: _submitAttendance,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
