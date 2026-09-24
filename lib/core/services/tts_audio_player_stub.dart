import 'package:flutter/foundation.dart';

/// Stub implementation for non-web platforms.
Future<bool> playWebAudioImpl(
  String text,
  String langCode, {
  required VoidCallback onDone,
}) async {
  return false;
}

/// Stub implementation to stop web audio on non-web platforms.
Future<void> stopWebAudioImpl() async {}
