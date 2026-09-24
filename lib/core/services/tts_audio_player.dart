import 'package:flutter/foundation.dart';
import 'tts_audio_player_stub.dart'
    if (dart.library.html) 'tts_audio_player_web.dart';

/// Cross-platform web audio player for high-fidelity Gujarati, Hindi, and English TTS.
class TtsAudioPlayer {
  static Future<bool> playWebAudio(
    String text,
    String langCode, {
    required VoidCallback onDone,
  }) async {
    if (kIsWeb) {
      return await playWebAudioImpl(text, langCode, onDone: onDone);
    }
    return false;
  }

  static Future<void> stopWebAudio() async {
    if (kIsWeb) {
      await stopWebAudioImpl();
    }
  }
}
