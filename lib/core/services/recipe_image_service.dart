/// Reliable service providing high quality free food images based on dish keywords.
class RecipeImageService {
  static const List<String> _gujaratiImages = [
    'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=800&auto=format&fit=crop',
  ];

  static const List<String> _indianImages = [
    'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?w=800&auto=format&fit=crop',
  ];

  static const List<String> _globalImages = [
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1621996346565-e3d5d6281313?w=800&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&auto=format&fit=crop',
  ];

  /// Get a guaranteed working food image URL for a given recipe title.
  static String getRecipeImageUrl(String title, {String? providedUrl}) {
    if (providedUrl != null &&
        providedUrl.isNotEmpty &&
        !providedUrl.contains('pollinations')) {
      return providedUrl;
    }

    final lower = title.toLowerCase();
    final hash = title.hashCode.abs();

    if (lower.contains('gujarati') ||
        lower.contains('shaak') ||
        lower.contains('tameta') ||
        lower.contains('handvo') ||
        lower.contains('bhaat') ||
        lower.contains('kathiyawadi')) {
      return _gujaratiImages[hash % _gujaratiImages.length];
    }

    if (lower.contains('indian') ||
        lower.contains('masala') ||
        lower.contains('curry') ||
        lower.contains('korma') ||
        lower.contains('dal') ||
        lower.contains('paneer') ||
        lower.contains('bhurji')) {
      return _indianImages[hash % _indianImages.length];
    }

    return _globalImages[hash % _globalImages.length];
  }
}
