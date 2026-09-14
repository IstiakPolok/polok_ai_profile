import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ParallaxBackground extends StatelessWidget {
  final ScrollController scrollController;

  const ParallaxBackground({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, child) {
        double offset = 0.0;
        if (scrollController.hasClients) {
          offset = scrollController.offset;
        }

        return Stack(
          children: [
            Positioned(
              top: -offset * 0.2,
              left: 0,
              right: 0,
              height: 4000,
              child: CustomPaint(painter: ParallaxGridPainter()),
            ),
            Positioned(
              top: -offset * 0.5 + 400,
              left: 100,
              child: _buildGlowingOrb(AppColors.primaryGlow, 300),
            ),
            Positioned(
              top: -offset * 0.6 + 1200,
              right: 50,
              child: _buildGlowingOrb(const Color(0x11FFFFFF), 400),
            ),
            Positioned(
              top: -offset * 0.4 + 2200,
              left: 200,
              child: _buildGlowingOrb(AppColors.primaryGlow, 250),
            ),
            Positioned(
              top: -offset * 0.7 + 3000,
              right: 200,
              child: _buildGlowingOrb(const Color(0x11FFFFFF), 350),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlowingOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, Colors.transparent]),
      ),
    );
  }
}

class ParallaxGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.03)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 60) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
