import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HeaderSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback? onOpenDrawer;

  const HeaderSection({
    super.key,
    required this.isMobile,
    this.onOpenDrawer,
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
          const Text(
            "POLOK",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
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
                _buildNavLink("Home"),
                _buildNavLink("About me"),
                _buildNavLink("Experience"),
                _buildNavLink("Education"),
                _buildNavLink("Skills"),
                _buildNavLink("Projects"),
                _buildNavLink("Contact me"),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}

class PortfolioMobileDrawer extends StatelessWidget {
  const PortfolioMobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.vsCodeEditor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Center(
              child: Text(
                "POLOK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildDrawerItem("Home"),
          _buildDrawerItem("About me"),
          _buildDrawerItem("Experience"),
          _buildDrawerItem("Education"),
          _buildDrawerItem("Skills"),
          _buildDrawerItem("Projects"),
          _buildDrawerItem("Contact me"),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {},
    );
  }
}
