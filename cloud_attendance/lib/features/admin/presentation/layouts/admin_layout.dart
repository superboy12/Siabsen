import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;

  const AdminLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  bool _isCollapsed = false;

  final List<_SidebarItem> _menuItems = [
    _SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard', route: '/admin'),
    _SidebarItem(icon: Icons.people_alt_rounded, label: 'Manajemen Pegawai', route: '/admin/employees'),
    _SidebarItem(icon: Icons.history_rounded, label: 'Absensi', route: '/admin/attendance'),
    _SidebarItem(icon: Icons.monitor_heart_rounded, label: 'Monitoring Real Time', route: '/admin/monitoring'),
    _SidebarItem(icon: Icons.map_rounded, label: 'Peta Kehadiran', route: '/admin/map'),
    _SidebarItem(icon: Icons.summarize_rounded, label: 'Laporan', route: '/admin/reports'),
    _SidebarItem(icon: Icons.analytics_rounded, label: 'Analitik', route: '/admin/analytics'),
    _SidebarItem(icon: Icons.workspaces_rounded, label: 'Divisi', route: '/admin/divisions'),
    _SidebarItem(icon: Icons.business_rounded, label: 'Lokasi Kantor', route: '/admin/office'),
    _SidebarItem(icon: Icons.event_busy_rounded, label: 'Hari Libur', route: '/admin/holidays'),
    _SidebarItem(icon: Icons.schedule_rounded, label: 'Jam Kerja', route: '/admin/work-hours'),
    _SidebarItem(icon: Icons.settings_rounded, label: 'Pengaturan', route: '/admin/settings'),
    _SidebarItem(icon: Icons.list_alt_rounded, label: 'Log Aktivitas', route: '/admin/logs'),
    _SidebarItem(icon: Icons.person_rounded, label: 'Profile', route: '/admin/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;
    if (isMobile && !_isCollapsed) _isCollapsed = true;

    return Scaffold(
      backgroundColor: AppColors.adminBackground,
      appBar: isMobile ? _buildMobileAppBar() : null,
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                if (!isMobile) _buildDesktopAppBar(),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      title: Text(
        'SIMABSEN CLOUD',
        style: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isCollapsed ? 80 : 260,
      decoration: BoxDecoration(
        color: AppColors.adminSidebar,
        border: const Border(
          right: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebarContent() {
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Column(
      children: [
        // Logo Area
        Container(
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 0 : 24),
          alignment: _isCollapsed ? Alignment.center : Alignment.centerLeft,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              const Icon(Icons.cloud_done_rounded, color: AppColors.adminPrimary, size: 28),
              if (!_isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'SIMABSEN',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Menus
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              final isSelected = currentRoute == item.route;
              
              return _buildMenuItem(item, isSelected);
            },
          ),
        ),
        
        // Logout Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: InkWell(
            onTap: () => context.go('/login'),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.red.withValues(alpha: 0.1),
              ),
              child: Row(
                mainAxisAlignment: _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                  if (!_isCollapsed) ...[
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_SidebarItem item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () {
          context.go(item.route);
          if (Scaffold.of(context).isDrawerOpen) {
            Navigator.pop(context);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? AppColors.adminPrimary.withValues(alpha: 0.1) : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                color: isSelected ? AppColors.adminPrimary : AppColors.textSecondary,
                size: 22,
              ),
              if (!_isCollapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.inter(
                      color: isSelected ? AppColors.adminPrimary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopAppBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _isCollapsed = !_isCollapsed;
              });
            },
            icon: const Icon(Icons.menu_rounded, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          // Search Bar
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.adminBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(bottom: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Notifications
          IconButton(
            onPressed: () {},
            icon: const Badge(
              backgroundColor: Colors.red,
              child: Icon(Icons.notifications_none_rounded, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 16),
          // Profile
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.adminPrimary,
                child: Text('SA', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Super Admin',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'Administrator',
                    style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;
  final String route;

  _SidebarItem({required this.icon, required this.label, required this.route});
}
