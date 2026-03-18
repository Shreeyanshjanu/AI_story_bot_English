import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  Future<void> init() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // Try to set a natural English voice if available
    final voices = await _tts.getVoices;
    if (voices != null) {
      final englishVoice = (voices as List).firstWhere(
        (v) =>
            v['locale']?.toString().startsWith('en') == true,
        orElse: () => null,
      );
      if (englishVoice != null) {
        await _tts.setVoice({
          'name': englishVoice['name'],
          'locale': englishVoice['locale'],
        });
      }
    }
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void setCompletionHandler(VoidCallback onComplete) {
    _tts.setCompletionHandler(onComplete);
  }

  void setProgressHandler(Function(String, int, int, String) onProgress) {
    _tts.setProgressHandler(onProgress);
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}