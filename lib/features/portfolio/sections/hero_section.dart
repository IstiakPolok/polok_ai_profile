import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/common/social_icon_button.dart';
import '../widgets/hero/hero_stat_item.dart';
import '../widgets/hero/swapping_text_hero.dart';

class HeroSection extends StatelessWidget {
  final bool isMobile;

  const HeroSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final alignRight = !isMobile;

    final statsCard = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 32,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Wrap(
        spacing: 30,
        runSpacing: 20,
        alignment: isMobile ? WrapAlignment.center : WrapAlignment.end,
        children: [
          HeroStatItem(
            label: "Experiences",
            value: "4+",
            alignRight: alignRight,
          ),
          HeroStatItem(
            label: "Project done",
            value: "20+",
            alignRight: alignRight,
          ),
          HeroStatItem(
            label: "Happy Clients",
            value: "80+",
            alignRight: alignRight,
          ),
        ],
      ),
    );

    final heroColumn = Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SwappingTextHero(
          isMobile: isMobile,
          alignRight: alignRight,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SocialIconButton(
              icon: FontAwesomeIcons.github,
              url: 'https://github.com/IstiakPolok',
            ),
            SocialIconButton(
              icon: FontAwesomeIcons.linkedinIn,
              url: 'https://www.linkedin.com/in/fatin-istiak-polok-885574137/',
            ),
            SocialIconButton(icon: FontAwesomeIcons.dribbble),
            SocialIconButton(icon: FontAwesomeIcons.behance),
          ],
        ),
        const SizedBox(height: 36),
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
              child: const Text(
                "Hire Me",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 20),
            OutlinedButton(
              onPressed: () => launchUrl(
                Uri.parse(
                  'https://drive.google.com/file/d/1BakrTaCyv0gX4NSPtxTaQKgepA-37IIL/view?usp=sharing',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
              ),
              child: const Text(
                "Download CV",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        statsCard,
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 100,
        vertical: 80,
      ),
      child: Align(
        alignment: isMobile ? Alignment.center : Alignment.centerRight,
        child: heroColumn
            .animate()
            .fadeIn(duration: 800.ms, curve: Curves.easeOut)
            .slideY(begin: 0.1),
      ),
    );
  }
}
