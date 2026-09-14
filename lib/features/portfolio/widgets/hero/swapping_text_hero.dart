import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class SwappingTextHero extends StatefulWidget {
  final bool isMobile;
  final bool alignRight;

  const SwappingTextHero({
    super.key,
    required this.isMobile,
    this.alignRight = false,
  });

  @override
  State<SwappingTextHero> createState() => _SwappingTextHeroState();
}

class _SwappingTextHeroState extends State<SwappingTextHero> {
  final List<String> _texts = [
    "FATIN ISTIAK POLOK",
    "CREATIVE FLUTTER DEVELOPER",
  ];

  List<int> _lineSlots = [0, 1];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() {
        _lineSlots = _lineSlots[0] == 0 ? [1, 0] : [0, 1];
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = widget.isMobile;
    final alignRight = widget.alignRight && !isMobile;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double nameFontSize = isMobile
        ? (screenWidth * 0.068).clamp(20.0, 32.0)
        : (screenWidth * 0.034).clamp(26.0, 42.0);

    final double subtitleFontSize = isMobile
        ? (screenWidth * 0.05).clamp(15.0, 22.0)
        : (screenWidth * 0.024).clamp(18.0, 30.0);

    final double slot0 = 0.0;
    final double slot1 = nameFontSize + (isMobile ? 12.0 : 18.0);
    final double containerHeight = slot1 + subtitleFontSize + 10.0;

    return SizedBox(
      height: containerHeight,
      width: double.infinity,
      child: Stack(
        alignment: isMobile
            ? Alignment.center
            : (alignRight ? Alignment.centerRight : Alignment.centerLeft),
        children: List.generate(2, (lineIndex) {
          final slotIndex = _lineSlots[lineIndex];
          final text = _texts[lineIndex];

          double topPos = slotIndex == 0 ? slot0 : slot1;

          TextStyle textStyle;
          if (slotIndex == 0) {
            textStyle = GoogleFonts.outfit(
              color: Colors.white,
              fontSize: nameFontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            );
          } else {
            textStyle = GoogleFonts.outfit(
              color: AppColors.primary,
              fontSize: subtitleFontSize,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            );
          }

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            top: topPos,
            left: isMobile ? null : (alignRight ? null : 0.0),
            right: isMobile ? null : (alignRight ? 0.0 : null),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              style: textStyle,
              child: Text(
                text,
                textAlign: isMobile
                    ? TextAlign.center
                    : (alignRight ? TextAlign.right : TextAlign.left),
              ),
            ),
          );
        }),
      ),
    );
  }
}
