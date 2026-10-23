import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/core.dart';

/// Elevated & Modern Grocery Receipt Scanner Screen
class ReceiptScannerScreen extends StatefulWidget {
  const ReceiptScannerScreen({super.key});
  @override
  State<ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<ReceiptScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  Uint8List? _imageBytes;
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (!kIsWeb) {
        final photoStatus = await Permission.photos.status;
        final permission = source == ImageSource.camera
            ? Permission.camera
            : (photoStatus != PermissionStatus.granted ? Permission.storage : Permission.photos);
        final status = await permission.request();
        if ((status.isDenied || status.isPermanentlyDenied) && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(source == ImageSource.camera ? 'Camera permission required.' : 'Gallery permission required.'),
            backgroundColor: AppColors.warningOrange,
          ));
        }
      }
      final XFile? file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() { _selectedFile = file; _imageBytes = bytes; });
      }
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to select image.'), backgroundColor: AppColors.dangerRed));
    }
  }

  Future<void> _uploadAndProcess() async {
    if (_imageBytes == null || _selectedFile == null) return;
    setState(() => _isProcessing = true);
    final items = await PantryApiService.scanReceiptImage(_imageBytes!, _selectedFile!.name);
    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (items != null && items.isNotEmpty) {
      for (final item in items) {
        await AppNotificationService.instance.notifyItemAdded(
          itemName: item.name,
          quantity: item.quantity,
          unit: item.unit,
        );
      }
      await AppNotificationService.instance.checkPantryAlerts(items);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Added ${items.length} items from receipt to Pantry!'),
        backgroundColor: AppColors.secondaryGreen,
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not parse receipt. Try another clear bill photo.'),
        backgroundColor: AppColors.warningOrange,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeColor = isDark ? AppColors.darkAccent : AppColors.primaryGreen;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: primaryTextColor), onPressed: () => Navigator.pop(context)),
        title: Text('Scan Grocery Bill', style: AppTextStyles.headingMedium(color: primaryTextColor)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: activeColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_rounded, size: 14, color: activeColor),
                          const SizedBox(width: 6),
                          Text('AI Smart Receipt Parser', style: TextStyle(color: activeColor, fontSize: 11.5, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('Capture or Upload Bill', style: TextStyle(color: primaryTextColor, fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Extract all grocery items and prices automatically into your Pantry.', style: TextStyle(color: secondaryTextColor, fontSize: 13)),
                  const SizedBox(height: 18),
                  Container(
                    height: 290,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: activeColor.withValues(alpha: 0.35), width: 1.5),
                      boxShadow: [BoxShadow(color: activeColor.withValues(alpha: isDark ? 0.15 : 0.08), blurRadius: 20, offset: const Offset(0, 6))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: _imageBytes != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.memory(_imageBytes!, fit: BoxFit.contain),
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Material(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () => setState(() { _selectedFile = null; _imageBytes = null; }),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.refresh_rounded, color: Colors.white, size: 16),
                                            SizedBox(width: 4),
                                            Text('Retake', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(22),
                                  decoration: BoxDecoration(color: activeColor.withValues(alpha: 0.12), shape: BoxShape.circle, border: Border.all(color: activeColor.withValues(alpha: 0.3))),
                                  child: Icon(Icons.receipt_long_rounded, size: 48, color: activeColor),
                                ),
                                const SizedBox(height: 16),
                                Text('No receipt attached', style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 6),
                                Text('Tap Camera or Upload below to select your bill', style: TextStyle(color: secondaryTextColor, fontSize: 12.5)),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _featureChip('🏷️ Auto Items', isDark),
                                    const SizedBox(width: 8),
                                    _featureChip('💰 Price Extract', isDark),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(child: _buildSourceBtn('Camera', Icons.camera_alt_rounded, () => _pickImage(ImageSource.camera), isDark, primaryTextColor)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildSourceBtn('Upload Bill', Icons.photo_library_rounded, () => _pickImage(ImageSource.gallery), isDark, primaryTextColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_imageBytes != null)
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: activeColor.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))]),
                      child: ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _uploadAndProcess,
                        icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                        label: const Text('Scan & Add to Pantry', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
                        style: ElevatedButton.styleFrom(backgroundColor: activeColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 0.65),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(color: isDark ? const Color(0xFF1E293B) : Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: activeColor),
                      const SizedBox(height: 18),
                      Text('Parsing Receipt Items...', style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text('Adding products to your Pantry', style: TextStyle(color: secondaryTextColor, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSourceBtn(String label, IconData icon, VoidCallback onTap, bool isDark, Color textColor) =>
      ElevatedButton.icon(
        onPressed: onTap, icon: Icon(icon, size: 20), label: Text(label),
        style: ElevatedButton.styleFrom(backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9), foregroundColor: textColor, elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      );

  Widget _featureChip(String label, bool isDark) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
    child: Text(label, style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
  );
}
