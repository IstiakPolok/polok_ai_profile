import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HeaderSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback? onOpenDrawer;
  final ValueChanged<int>? onNavigate;

  const HeaderSection({
    super.key,
    required this.isMobile,
    this.onOpenDrawer,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => onNavigate?.call(0),
              child: const Text(
                "POLOK",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: onOpenDrawer,
            )
          else
            Row(
              children: [
                _buildNavLink("Home", 0),
                _buildNavLink("About me", 1),
                _buildNavLink("Experience", 2),
                _buildNavLink("Education", 3),
                _buildNavLink("Skills", 4),
                _buildNavLink("Projects", 5),
                _buildNavLink("Contact me", 6),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onNavigate?.call(index),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class PortfolioMobileDrawer extends StatelessWidget {
  final ValueChanged<int>? onNavigate;

  const PortfolioMobileDrawer({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.vsCodeEditor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Center(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    onNavigate?.call(0);
                  },
                  child: const Text(
                    "POLOK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _buildDrawerItem(context, "Home", 0),
          _buildDrawerItem(context, "About me", 1),
          _buildDrawerItem(context, "Experience", 2),
          _buildDrawerItem(context, "Education", 3),
          _buildDrawerItem(context, "Skills", 4),
          _buildDrawerItem(context, "Projects", 5),
          _buildDrawerItem(context, "Contact me", 6),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, int index) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.of(context).pop();
        onNavigate?.call(index);
      },
    );
  }
}
