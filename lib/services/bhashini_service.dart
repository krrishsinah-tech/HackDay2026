import 'dart:async';
import 'dart:math';

abstract class SpeechToTextService {
  Future<void> startListening({required String languageCode, required Function(String text, List<double> waveform) onResult});
  Future<String> stopListening();
  bool get isListening;
}

abstract class TextToSpeechService {
  Future<void> speak(String text, {required String languageCode, double speed = 1.0});
  Future<void> stop();
  bool get isSpeaking;
}

abstract class TranslationService {
  Future<String> translate(String text, {required String sourceLanguage, required String targetLanguage});
}

abstract class SimplificationService {
  Future<String> simplify(String officialText, {required String languageCode});
}

/// Mock Bhashini AI Service implementing Government of India AI protocol interfaces
class MockBhashiniService implements SpeechToTextService, TextToSpeechService, TranslationService, SimplificationService {
  bool _isListening = false;
  bool _isSpeaking = false;
  Timer? _waveformTimer;
  final Random _random = Random();
  String _currentTranscribedText = '';

  // Cache for simplified & translated text per scheme & language
  final Map<String, String> _translationCache = {};
  final Map<String, String> _simplificationCache = {};

  @override
  bool get isListening => _isListening;

  @override
  bool get isSpeaking => _isSpeaking;

  @override
  Future<void> startListening({
    required String languageCode,
    required Function(String text, List<double> waveform) onResult,
  }) async {
    _isListening = true;
    _currentTranscribedText = '';

    // Generate simulated dynamic audio waveform (16 bars) and progressive transcription
    _waveformTimer?.cancel();
    int tick = 0;
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }
      tick++;
      // Generate randomized live waveform between 0.15 and 0.95
      final waveform = List.generate(16, (index) => 0.15 + _random.nextDouble() * 0.8);
      onResult(_currentTranscribedText, waveform);
    });
  }

  void updateLiveTranscription(String text) {
    _currentTranscribedText = text;
  }

  @override
  Future<String> stopListening() async {
    _isListening = false;
    _waveformTimer?.cancel();
    return _currentTranscribedText;
  }

  @override
  Future<void> speak(String text, {required String languageCode, double speed = 1.0}) async {
    await stop();
    _isSpeaking = true;
    // Simulate speech playback duration based on word count & speed
    final wordCount = text.split(' ').length;
    final durationSeconds = ((wordCount * 0.35) / speed).clamp(1.5, 12.0);
    await Future.delayed(Duration(milliseconds: (durationSeconds * 1000).toInt()));
    _isSpeaking = false;
  }

  @override
  Future<void> stop() async {
    _isSpeaking = false;
  }

  @override
  Future<String> translate(String text, {required String sourceLanguage, required String targetLanguage}) async {
    if (sourceLanguage == targetLanguage) return text;
    final cacheKey = '$sourceLanguage->$targetLanguage:$text';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 100));
    final translated = "[$targetLanguage] $text";
    _translationCache[cacheKey] = translated;
    return translated;
  }

  @override
  Future<String> simplify(String officialText, {required String languageCode}) async {
    final cacheKey = '$languageCode:$officialText';
    if (_simplificationCache.containsKey(cacheKey)) {
      return _simplificationCache[cacheKey]!;
    }
    await Future.delayed(const Duration(milliseconds: 100));
    final simplified = "Plain words: $officialText";
    _simplificationCache[cacheKey] = simplified;
    return simplified;
  }
}
