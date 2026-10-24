import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final bool isRtl;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    this.isRtl = false,
  });
}

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};
  static Map<String, String> _fallbackHindiStrings = {};
  static Map<String, String> _fallbackEnglishStrings = {};

  AppLocalizations(this.locale);

  static const List<LanguageInfo> supportedLanguages = [
    LanguageInfo(code: 'en', name: 'English', nativeName: 'English'),
    LanguageInfo(code: 'as', name: 'Assamese', nativeName: 'অসমীয়া'),
    LanguageInfo(code: 'bn', name: 'Bengali', nativeName: 'বাংলা'),
    LanguageInfo(code: 'brx', name: 'Bodo', nativeName: "बर'/बड़ो"),
    LanguageInfo(code: 'doi', name: 'Dogri', nativeName: 'डोगरी'),
    LanguageInfo(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી'),
    LanguageInfo(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    LanguageInfo(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    LanguageInfo(code: 'ks', name: 'Kashmiri', nativeName: 'कॉशुर / كٲشُر', isRtl: true),
    LanguageInfo(code: 'kok', name: 'Konkani', nativeName: 'कोंकणी'),
    LanguageInfo(code: 'mai', name: 'Maithili', nativeName: 'मैथिली'),
    LanguageInfo(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം'),
    LanguageInfo(code: 'mni', name: 'Manipuri (Meitei)', nativeName: 'মৈতৈলোন্'),
    LanguageInfo(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
    LanguageInfo(code: 'ne', name: 'Nepali', nativeName: 'नेपाली'),
    LanguageInfo(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ'),
    LanguageInfo(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ'),
    LanguageInfo(code: 'sa', name: 'Sanskrit', nativeName: 'संस्कृतम्'),
    LanguageInfo(code: 'sat', name: 'Santali', nativeName: 'ᱥᱟᱱᱛᱟᱲᱤ'),
    LanguageInfo(code: 'sd', name: 'Sindhi', nativeName: 'سنڌي / सिन्धी', isRtl: true),
    LanguageInfo(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    LanguageInfo(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    LanguageInfo(code: 'ur', name: 'Urdu', nativeName: 'اردو', isRtl: true),
  ];

  static bool isRtlLanguage(String code) {
    final lang = supportedLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => const LanguageInfo(code: 'en', name: 'English', nativeName: 'English'),
    );
    return lang.isRtl;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  Future<bool> load() async {
    // 1. Load English base fallback
    if (_fallbackEnglishStrings.isEmpty) {
      try {
        final enJson = await rootBundle.loadString('assets/l10n/en.json');
        final Map<String, dynamic> enMap = json.decode(enJson);
        _fallbackEnglishStrings = enMap.map((k, v) => MapEntry(k, v.toString()));
      } catch (e) {
        // Fallback default
      }
    }

    // 2. Load Hindi intermediate fallback
    if (_fallbackHindiStrings.isEmpty) {
      try {
        final hiJson = await rootBundle.loadString('assets/l10n/hi.json');
        final Map<String, dynamic> hiMap = json.decode(hiJson);
        _fallbackHindiStrings = hiMap.map((k, v) => MapEntry(k, v.toString()));
      } catch (e) {
        // Fallback default
      }
    }

    // 3. Load Selected Locale
    try {
      final jsonString = await rootBundle.loadString('assets/l10n/${locale.languageCode}.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((k, v) => MapEntry(k, v.toString()));
    } catch (e) {
      _localizedStrings = {};
    }

    return true;
  }

  String translate(String key, {Map<String, String>? params}) {
    // Fallback chain: Selected Language -> Hindi -> English -> Key itself
    String translation = _localizedStrings[key] ??
        _fallbackHindiStrings[key] ??
        _fallbackEnglishStrings[key] ??
        key;

    if (params != null) {
      params.forEach((paramKey, paramVal) {
        translation = translation.replaceAll('{$paramKey}', paramVal);
      });
    }

    return translation;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLanguages
        .any((lang) => lang.code == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
