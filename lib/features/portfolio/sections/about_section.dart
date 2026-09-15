import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/data/profile_data.dart';

class AboutSection extends StatelessWidget {
  final bool isMobile;

  const AboutSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final alignRight = !isMobile;

    final content = Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ProfileData.bio,
          textAlign: alignRight ? TextAlign.right : TextAlign.center,
          style: const TextStyle(
            color: Colors.white70,
            height: 1.8,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () => launchUrl(
            Uri.parse(
              'https://drive.google.com/file/d/1BakrTaCyv0gX4NSPtxTaQKgepA-37IIL/view?usp=sharing',
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
          child: const Text(
            "Download CV",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 60,
      ),
      child: Align(
        alignment: alignRight ? Alignment.centerRight : Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: alignRight
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "About Me",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fadeIn().slideX(begin: 0.2),
              const SizedBox(height: 10),
              Text(
                "Passionate about scalable mobile solutions & modern design.",
                textAlign: alignRight ? TextAlign.right : TextAlign.center,
                style: const TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 40),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
