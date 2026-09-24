// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

Timer? _resumeTimer;

/// Native Web Speech API implementation for Flutter Web.
Future<bool> playWebAudioImpl(
  String text,
  String langCode, {
  required VoidCallback onDone,
}) async {
  try {
    await stopWebAudioImpl();

    final synth = html.window.speechSynthesis;
    if (synth == null) {
      onDone();
      return false;
    }

    synth.cancel();

    html.SpeechSynthesisVoice? findBestVoice(
      List<html.SpeechSynthesisVoice> voices,
      String targetLang,
    ) {
      if (voices.isEmpty) return null;

      final lowerTarget = targetLang.toLowerCase();
      if (lowerTarget == 'gu' || lowerTarget.contains('gujarat')) {
        for (var v in voices) {
          final l = (v.lang ?? '').toLowerCase();
          if (l.contains('gu') || l.contains('guj')) return v;
        }
        for (var v in voices) {
          final l = (v.lang ?? '').toLowerCase();
          if (l.contains('hi') || l.contains('hin')) return v;
        }
      } else if (lowerTarget == 'hi' || lowerTarget.contains('hind')) {
        for (var v in voices) {
          final l = (v.lang ?? '').toLowerCase();
          if (l.contains('hi') || l.contains('hin')) return v;
        }
      }

      for (var v in voices) {
        final l = (v.lang ?? '').toLowerCase();
        if (l.contains('en-in') || l.contains('en_in')) return v;
      }
      return null;
    }

    void speakWithVoices(List<html.SpeechSynthesisVoice> voices) {
      final selectedVoice = findBestVoice(voices, langCode);

      final utterance = html.SpeechSynthesisUtterance(text);
      if (selectedVoice != null && selectedVoice.lang != null) {
        utterance.voice = selectedVoice;
        utterance.lang = selectedVoice.lang!;
      } else {
        utterance.lang = langCode == 'gu'
            ? 'gu-IN'
            : (langCode == 'hi' ? 'hi-IN' : 'en-US');
      }

      utterance.rate = 0.9;
      utterance.pitch = 1.0;
      utterance.volume = 1.0;

      utterance.onEnd.listen((_) {
        _stopResumeTimer();
        onDone();
      });

      utterance.onError.listen((e) {
        if (kDebugMode) print('SpeechSynthesisUtterance error: $e');
        _stopResumeTimer();
        onDone();
      });

      synth.speak(utterance);

      // Periodic resume timer for Chrome SpeechSynthesis 15s pause bug
      _resumeTimer?.cancel();
      _resumeTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (synth.speaking == true && synth.paused != true) {
          synth.pause();
          synth.resume();
        }
      });
    }

    final List<html.SpeechSynthesisVoice> voices = synth
        .getVoices()
        .cast<html.SpeechSynthesisVoice>();

    if (voices.isNotEmpty) {
      speakWithVoices(voices);
    } else {
      html.EventListener? listener;
      listener = (event) {
        final List<html.SpeechSynthesisVoice> voiceList = synth
            .getVoices()
            .cast<html.SpeechSynthesisVoice>();
        if (voiceList.isNotEmpty) {
          html.window.removeEventListener('voiceschanged', listener);
          speakWithVoices(voiceList);
        }
      };
      html.window.addEventListener('voiceschanged', listener);

      Future.delayed(const Duration(milliseconds: 250), () {
        final List<html.SpeechSynthesisVoice> voiceList = synth
            .getVoices()
            .cast<html.SpeechSynthesisVoice>();
        speakWithVoices(voiceList);
      });
    }

    return true;
  } catch (e) {
    if (kDebugMode) print('Web SpeechSynthesis exception: $e');
    onDone();
    return false;
  }
}

/// Stops active web Web Speech API synthesis.
Future<void> stopWebAudioImpl() async {
  _stopResumeTimer();
  try {
    final synth = html.window.speechSynthesis;
    if (synth != null) {
      synth.cancel();
    }
  } catch (_) {}
}

void _stopResumeTimer() {
  _resumeTimer?.cancel();
  _resumeTimer = null;
}
