import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ContactSection extends StatelessWidget {
  final bool isMobile;

  const ContactSection({
    super.key,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Column(
        children: [
          const Text(
            "Contact me",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Cultivating Connections: Reach Out And Connect With Me",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 600,
            child: Column(
              children: [
                if (isMobile) ...[
                  _buildTextField("Name"),
                  const SizedBox(height: 20),
                  _buildTextField("Email"),
                ] else
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Name")),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField("Email")),
                    ],
                  ),
                const SizedBox(height: 20),
                if (isMobile) ...[
                  _buildTextField("Phone Number"),
                  const SizedBox(height: 20),
                  _buildTextField("Service Of Interest"),
                ] else
                  Row(
                    children: [
                      Expanded(child: _buildTextField("Phone Number")),
                      const SizedBox(width: 20),
                      Expanded(child: _buildTextField("Service Of Interest")),
                    ],
                  ),
                const SizedBox(height: 20),
                _buildTextField("Project Details...", maxLines: 4),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Send",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: AppColors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
