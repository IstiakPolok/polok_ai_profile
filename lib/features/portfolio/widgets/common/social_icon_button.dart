import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';

class SocialIconButton extends StatelessWidget {
  final dynamic icon;
  final String? url;

  const SocialIconButton({
    super.key,
    required this.icon,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (url != null) launchUrl(Uri.parse(url!));
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cardBg,
          border: Border.all(color: Colors.white24),
        ),
        child: icon is IconData
            ? Icon(icon, color: Colors.white, size: 18)
            : FaIcon(icon as FaIconData, color: Colors.white, size: 18),
      ),
    );
  }
}
