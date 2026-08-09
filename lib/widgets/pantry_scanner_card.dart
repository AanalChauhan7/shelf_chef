import 'package:flutter/material.dart';
import '../core/core.dart';
import 'ai_scanner_overlay_painter.dart';
import 'detected_item_badge.dart';

/// Recreates the AI Pantry Scanner Card UI from Image 2.
/// Features a dark ambient camera HUD with gold wireframe borders, cyan target reticles,
/// sweeping laser scan animation, floating detected item tags, and action buttons.
class PantryScannerCard extends StatefulWidget {
  final String imagePath;
  final VoidCallback? onScanPressed;
  final VoidCallback? onAutoAddPressed;

  const PantryScannerCard({
    super.key,
    this.imagePath = 'assets/images/onboarding_pantry.jpg',
    this.onScanPressed,
    this.onAutoAddPressed,
  });

  @override
  State<PantryScannerCard> createState() => _PantryScannerCardState();
}

class _PantryScannerCardState extends State<PantryScannerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 380,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background Pantry Image
            Positioned.fill(
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2D1F17), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.kitchen_rounded,
                        size: 80,
                        color: Colors.white24,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Semi-transparent HUD tint
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // Animated Laser Sweeping & Reticle Overlay Painter
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: AiScannerOverlayPainter(
                    scanProgress: _scanController.value,
                  ),
                );
              },
            ),

            // Floating Detected Bounding Box Tags from Image 2
            const Positioned(
              left: 45,
              top: 75,
              child: DetectedItemBadge(
                label: 'Organic Milk • 🥛',
                confidence: '99%',
              ),
            ),
            const Positioned(
              right: 40,
              top: 130,
              child: DetectedItemBadge(
                label: 'Strawberries • 🍓',
                confidence: '95%',
              ),
            ),

            // Bottom Floating Controls Overlay
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusChip('✨ AI Live OCR Active', Colors.black54),
                      _statusChip('4 Items Detected', const Color(0xFF10B981)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onScanPressed,
                          icon: const Icon(
                            Icons.center_focus_strong_rounded,
                            size: 18,
                          ),
                          label: const Text('Rescan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onAutoAddPressed,
                          icon: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 18,
                          ),
                          label: const Text('Auto Add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
