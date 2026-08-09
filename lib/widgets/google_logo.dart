import 'package:flutter/material.dart';

/// Official Pixel-Perfect 4-Color Google "G" Logo Icon.
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: const _OfficialGoogleGLogoPainter()),
    );
  }
}

class _OfficialGoogleGLogoPainter extends CustomPainter {
  const _OfficialGoogleGLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final outerRadius = w / 2;
    final thickness = w * 0.22;
    final innerRadius = outerRadius - thickness;

    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);

    // 1. RED Arc (Top) - #EA4335
    final redPath = Path();
    redPath.arcTo(outerRect, -2.4, 1.8, false); // ~-137° to -34°
    redPath.arcTo(innerRect, -0.6, -1.8, false);
    redPath.close();

    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(redPath, redPaint);

    // 2. YELLOW Arc (Left) - #FBBC05
    final yellowPath = Path();
    yellowPath.arcTo(outerRect, -3.8, 1.4, false); // ~-217° to -137°
    yellowPath.arcTo(innerRect, -2.4, -1.4, false);
    yellowPath.close();

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(yellowPath, yellowPaint);

    // 3. GREEN Arc (Bottom) - #34A853
    final greenPath = Path();
    greenPath.arcTo(outerRect, 0.2, 2.25, false); // ~11° to 140°
    greenPath.arcTo(innerRect, 2.45, -2.25, false);
    greenPath.close();

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(greenPath, greenPaint);

    // 4. BLUE Arc & Bar (Right) - #4285F4
    final bluePath = Path();
    bluePath.arcTo(outerRect, -0.6, 0.8, false);
    bluePath.arcTo(innerRect, 0.2, -0.8, false);
    bluePath.close();

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    canvas.drawPath(bluePath, bluePaint);

    // Blue Center Bar
    final barRect = Rect.fromLTWH(
      center.dx - 1,
      center.dy - thickness / 2,
      outerRadius + 1,
      thickness,
    );
    canvas.drawRect(barRect, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
