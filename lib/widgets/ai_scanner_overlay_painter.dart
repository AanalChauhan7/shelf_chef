import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Recreates the futuristic AI scanning reticle overlay from Image 2.
class AiScannerOverlayPainter extends CustomPainter {
  final double scanProgress;

  AiScannerOverlayPainter({required this.scanProgress});

  @override
  void paint(Canvas canvas, Size size) {
    const margin = 16.0;

    // 1. Outer Gold Geometric Wireframe Border
    final goldPaint = Paint()
      ..color = const Color(0xFFF59E0B).withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final cyanPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final outerRect = Rect.fromLTWH(
      margin,
      margin,
      size.width - margin * 2,
      size.height - margin * 2,
    );
    canvas.drawRect(outerRect, goldPaint);

    // Draw inner cyan rectangle
    const innerMargin = margin + 12;
    final innerRect = Rect.fromLTWH(
      innerMargin,
      innerMargin,
      size.width - innerMargin * 2,
      size.height - innerMargin * 2,
    );
    canvas.drawRect(innerRect, cyanPaint);

    // 2. Corner Target Brackets
    const bracketSize = 24.0;
    final bracketPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.square;

    // Top-Left Bracket
    canvas.drawLine(
      Offset(margin, margin),
      Offset(margin + bracketSize, margin),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(margin, margin),
      Offset(margin, margin + bracketSize),
      bracketPaint,
    );

    // Top-Right Bracket
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin - bracketSize, margin),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin, margin + bracketSize),
      bracketPaint,
    );

    // Bottom-Left Bracket
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin + bracketSize, size.height - margin),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin, size.height - margin - bracketSize),
      bracketPaint,
    );

    // Bottom-Right Bracket
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin - bracketSize, size.height - margin),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin, size.height - margin - bracketSize),
      bracketPaint,
    );

    // 3. Center Circular Target Reticle
    final center = Offset(size.width / 2, size.height / 2);
    const outerRadius = 36.0;

    final reticlePaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawCircle(center, outerRadius, reticlePaint);
    canvas.drawCircle(center, outerRadius * 0.45, reticlePaint);

    // Center Crosshairs
    const lineLen = 10.0;
    canvas.drawLine(
      Offset(center.dx - outerRadius - 6, center.dy),
      Offset(center.dx - outerRadius + lineLen, center.dy),
      reticlePaint,
    );
    canvas.drawLine(
      Offset(center.dx + outerRadius + 6, center.dy),
      Offset(center.dx + outerRadius - lineLen, center.dy),
      reticlePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - outerRadius - 6),
      Offset(center.dx, center.dy - outerRadius + lineLen),
      reticlePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + outerRadius + 6),
      Offset(center.dx, center.dy + outerRadius - lineLen),
      reticlePaint,
    );

    // 4. Animated Laser Beam Sweeping Line
    final scanY = innerMargin + (innerRect.height * scanProgress);

    final laserShader = LinearGradient(
      colors: [
        const Color(0xFF38BDF8).withValues(alpha: 0.0),
        const Color(0xFF38BDF8).withValues(alpha: 0.85),
        const Color(0xFF38BDF8).withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromLTWH(innerMargin, scanY - 1, innerRect.width, 2));

    final laserPaint = Paint()
      ..shader = laserShader
      ..strokeWidth = 2.5;

    canvas.drawLine(
      Offset(innerMargin, scanY),
      Offset(size.width - innerMargin, scanY),
      laserPaint,
    );

    // Subtle Laser Glow trail
    final glowShader = LinearGradient(
      colors: [
        const Color(0xFF38BDF8).withValues(alpha: 0.25),
        Colors.transparent,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Rect.fromLTWH(innerMargin, scanY - 30, innerRect.width, 30));

    final glowPaint = Paint()..shader = glowShader;
    canvas.drawRect(
      Rect.fromLTWH(
        innerMargin,
        math.max(innerMargin, scanY - 30),
        innerRect.width,
        math.min(30.0, scanY - innerMargin),
      ),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant AiScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanProgress != scanProgress;
  }
}
