import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../widgets/ai_scanner_overlay_painter.dart';
import '../models/pantry_item.dart';
import '../widgets/extracted_receipt_items_sheet.dart';
import '../widgets/scanner_controls_row.dart';

/// Full-screen camera & receipt scanner with AI OCR item extraction.
class ReceiptScannerScreen extends StatefulWidget {
  final Function(List<PantryItem>)? onItemsAdded;

  const ReceiptScannerScreen({super.key, this.onItemsAdded});

  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _simulateReceiptScan() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isProcessing = false);

    final mockExtractedItems = [
      PantryItem(
        id: '1',
        name: 'Fresh Tomatoes',
        category: 'Vegetables',
        quantity: '1',
        unit: 'kg',
        estimatedPrice: 40.0,
        expiryDate: DateTime.now().add(const Duration(days: 6)),
        storageLocation: 'Fridge',
      ),
      PantryItem(
        id: '2',
        name: 'Amul Taaza Milk',
        category: 'Dairy',
        quantity: '2',
        unit: 'L',
        estimatedPrice: 120.0,
        expiryDate: DateTime.now().add(const Duration(days: 3)),
        storageLocation: 'Fridge',
      ),
      PantryItem(
        id: '3',
        name: 'Chana Besan (Gram Flour)',
        category: 'Grains & Pulses',
        quantity: '500',
        unit: 'g',
        estimatedPrice: 65.0,
        expiryDate: DateTime.now().add(const Duration(days: 45)),
        storageLocation: 'Pantry',
      ),
      PantryItem(
        id: '4',
        name: 'Pure Desi Ghee',
        category: 'Dairy',
        quantity: '500',
        unit: 'ml',
        estimatedPrice: 320.0,
        expiryDate: DateTime.now().add(const Duration(days: 90)),
        storageLocation: 'Pantry',
      ),
    ];

    ExtractedReceiptItemsSheet.show(
      context,
      storeName: 'Reliance Fresh Supermarket',
      totalAmount: 545.0,
      initialItems: mockExtractedItems,
      onConfirmAdd: (items) {
        widget.onItemsAdded?.call(items);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${items.length} receipt items to Pantry!'),
            backgroundColor: AppColors.secondaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, items);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan Grocery Receipt',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/pantry_shelf_scanner.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF0F172A),
                        child: const Center(
                          child: Icon(
                            Icons.receipt_long_rounded,
                            size: 80,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                    ),
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
                    if (_isProcessing)
                      Container(
                        color: Colors.black.withValues(alpha: 0.7),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.secondaryGreen,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Extracting Bill Items with Gemini AI...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 30,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.center_focus_strong_rounded,
                        color: AppColors.secondaryGreen,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Align grocery receipt within frame',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ScannerControlsRow(
                  onGalleryTap: _simulateReceiptScan,
                  onCaptureTap: _simulateReceiptScan,
                  onManualTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
