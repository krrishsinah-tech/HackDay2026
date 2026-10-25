import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/scheme.dart';

class SchemeRepository {
  List<Scheme> _cachedSchemes = [];
  bool _isLoaded = false;

  Future<List<Scheme>> getSchemes() async {
    if (_isLoaded && _cachedSchemes.isNotEmpty) {
      return _cachedSchemes;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/mock_schemes.json');
      final List<dynamic> list = json.decode(jsonString);
      _cachedSchemes = list.map((item) => Scheme.fromJson(item as Map<String, dynamic>)).toList();
      _isLoaded = true;
    } catch (e) {
      // Fallback empty if loading error
      _cachedSchemes = [];
    }

    return _cachedSchemes;
  }

  Future<Scheme?> getSchemeById(String id) async {
    final schemes = await getSchemes();
    try {
      return schemes.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  String getLastCheckedDate() {
    return "24 October 2026";
  }
}
