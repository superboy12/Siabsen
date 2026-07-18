import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  // Mock Data
  final List<Map<String, dynamic>> _employees = List.generate(
    20,
    (index) => {
      'id': index + 1,
      'nip': '19850723201012100${index + 1}',
      'name': 'Pegawai ${index + 1}',
      'email': 'pegawai${index + 1}@dinaskehutanan.go.id',
      'division': index % 2 == 0 ? 'IT' : 'HR',
      'role': index == 0 ? 'Admin' : 'Pegawai',
      'status': index % 5 == 0 ? 'Cuti' : 'Aktif',
      'avatar': 'https://i.pravatar.cc/150?img=${index + 1}',
    },
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Manajemen Pegawai',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('Tambah Pegawai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.adminPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.adminCard,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toolbar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.adminBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Cari NIP, Nama, Email...',
                                  hintStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(bottom: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_list_rounded, size: 18),
                        label: const Text('Filter'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.file_download_rounded, size: 18),
                        label: const Text('Export CSV'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.adminBackground),
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 60,
                    columns: [
                      DataColumn(label: Text('PEGAWAI', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12))),
                      DataColumn(label: Text('NIP', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12))),
                      DataColumn(label: Text('DIVISI', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12))),
                      DataColumn(label: Text('ROLE', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12))),
                      DataColumn(label: Text('STATUS', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12))),
                      DataColumn(label: Text('AKSI', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 12))),
                    ],
                    rows: _employees.map((emp) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: NetworkImage(emp['avatar']),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      emp['name'],
                                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13),
                                    ),
                                    Text(
                                      emp['email'],
                                      style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          DataCell(Text(emp['nip'], style: GoogleFonts.inter(fontSize: 13))),
                          DataCell(Text(emp['division'], style: GoogleFonts.inter(fontSize: 13))),
                          DataCell(Text(emp['role'], style: GoogleFonts.inter(fontSize: 13))),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: emp['status'] == 'Aktif' ? AppColors.adminPrimary.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                emp['status'],
                                style: GoogleFonts.inter(
                                  color: emp['status'] == 'Aktif' ? AppColors.adminPrimary : Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, color: Colors.blue, size: 18),
                                  onPressed: () {},
                                  splashRadius: 20,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_rounded, color: Colors.red, size: 18),
                                  onPressed: () {},
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                
                // Pagination Placeholder
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Menampilkan 1 hingga 20 dari 1,240 data',
                        style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: null,
                            child: const Text('Previous'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.adminPrimary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('1'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
