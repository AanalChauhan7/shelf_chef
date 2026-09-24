import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'tts_audio_player.dart';

/// Robust Text-To-Speech service supporting English, Hindi, and Gujarati voices across Web and Mobile.
class TtsService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;

  static Future<void> _init() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(0.46);
      await _flutterTts.setPitch(1.0);

      if (!kIsWeb) {
        try {
          await _flutterTts.awaitSpeakCompletion(true);
        } catch (_) {}
      }
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) print('TTS init note: $e');
    }
  }

  /// Sets voice language with safe fallbacks for Hindi & Gujarati on native mobile.
  static Future<void> _setLanguageSafely(String language) async {
    final lower = language.toLowerCase();
    final isGu =
        lower.contains('gujarat') || lower.contains('ગુજરાતી') || lower == 'gu';
    final isHi =
        lower.contains('hind') || lower.contains('हिंदी') || lower == 'hi';

    if (isGu) {
      final tags = ['gu-IN', 'gu_IN', 'gu', 'hi-IN', 'hi_IN', 'hi', 'en-IN'];
      for (final tag in tags) {
        try {
          final res = await _flutterTts.setLanguage(tag);
          if (res == 1 || res == 'ok' || res == true) return;
        } catch (_) {}
      }
    } else if (isHi) {
      final tags = ['hi-IN', 'hi_IN', 'hi', 'en-IN', 'en-US'];
      for (final tag in tags) {
        try {
          final res = await _flutterTts.setLanguage(tag);
          if (res == 1 || res == 'ok' || res == true) return;
        } catch (_) {}
      }
    }

    try {
      await _flutterTts.setLanguage('en-US');
    } catch (_) {}
  }

  /// Auto-detects script language from text content.
  static String detectScriptLanguage(String text) {
    if (RegExp(r'[\u0A80-\u0AFF]').hasMatch(text)) {
      return 'Gujarati';
    }
    if (RegExp(r'[\u0900-\u097F]').hasMatch(text)) {
      return 'Hindi';
    }
    return 'English';
  }

  /// Speaks out text in specified language (English, Hindi, or Gujarati).
  static Future<bool> speak(
    String text, {
    String language = 'English',
    required VoidCallback onStart,
    required VoidCallback onDone,
  }) async {
    try {
      await stop();

      final detectedLang = detectScriptLanguage(text);
      final effectiveLang = (detectedLang != 'English')
          ? detectedLang
          : language;

      final lower = effectiveLang.toLowerCase();
      final isGu =
          lower.contains('gujarat') ||
          lower.contains('ગુજરાતી') ||
          lower == 'gu';
      final isHi =
          lower.contains('hind') || lower.contains('हिंदी') || lower == 'hi';
      final langCode = isGu ? 'gu' : (isHi ? 'hi' : 'en');

      onStart();

      // On Web, use Web HTML5 Audio streaming for 100% audible human speech in Gujarati/Hindi/English
      if (kIsWeb) {
        final played = await TtsAudioPlayer.playWebAudio(
          text,
          langCode,
          onDone: onDone,
        );
        if (played) return true;
      }

      await _init();
      await _setLanguageSafely(effectiveLang);

      _flutterTts.setStartHandler(() {
        onStart();
      });
      _flutterTts.setCompletionHandler(() {
        onDone();
      });
      _flutterTts.setErrorHandler((msg) {
        if (kDebugMode) print('TTS error: $msg');
        onDone();
      });

      final result = await _flutterTts.speak(text);
      if (result == 0) {
        onDone();
        return false;
      }
      return true;
    } catch (e) {
      if (kDebugMode) print('TTS speak error: $e');
      onDone();
      return false;
    }
  }

  /// Stop active TTS speech across all engines.
  static Future<void> stop() async {
    try {
      await TtsAudioPlayer.stopWebAudio();
      await _flutterTts.stop();
    } catch (_) {}
  }
}
