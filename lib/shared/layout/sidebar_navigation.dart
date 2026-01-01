import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class SidebarNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const SidebarNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Google/Strava style:
    // Left sidebar typically has a logo at the top
    // Navigation items
    // Maybe some footer items (Settings, Profile)

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : AppColors.purple1,
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.grey[800]! : AppColors.purple3,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.purple9, size: 32),
                const SizedBox(width: 12),
                Text(
                  'WysX',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _SidebarItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                  isSelected: selectedIndex == 0,
                  onTap: () => onDestinationSelected(0),
                ),
                const SizedBox(height: 4),
                _SidebarItem(
                  icon: Icons.map_outlined,
                  selectedIcon: Icons.map,
                  label: 'Map',
                  isSelected: selectedIndex == 1,
                  onTap: () => onDestinationSelected(1),
                ),
                const SizedBox(height: 4),
                _SidebarItem(
                  icon: Icons.group_outlined,
                  selectedIcon: Icons.group,
                  label: 'Social',
                  isSelected: selectedIndex == 2,
                  onTap: () => onDestinationSelected(2),
                ),
              ],
            ),
          ),

          // Optional Footer items could go here
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0',
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final color = isSelected
        ? AppColors.purple9
        : (isDark ? Colors.grey[400] : Colors.grey[700]);

    final backgroundColor = isSelected
        ? AppColors.purple9.withOpacity(0.1)
        : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(isSelected ? selectedIcon : icon, color: color, size: 24),
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
