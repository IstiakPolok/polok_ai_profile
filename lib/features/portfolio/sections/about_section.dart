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
    final image = Image.asset(
      'assets/images/image.png',
      height: isMobile ? 300 : 400,
      errorBuilder: (context, error, stackTrace) => Container(
        height: isMobile ? 300 : 400,
        width: isMobile ? 300 : 400,
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, size: 100, color: AppColors.primary),
      ),
    );

    final content = Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          ProfileData.bio,
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
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
      child: Column(
        children: [
          const Text(
            "About Me",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 10),
          const Text(
            "Passionate about scalable mobile solutions & modern design.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 50),
          if (isMobile)
            Column(children: [image, const SizedBox(height: 30), content])
          else
            Row(
              children: [
                Expanded(child: image),
                const SizedBox(width: 50),
                Expanded(child: content),
              ],
            ),
        ],
      ),
    );
  }
}
