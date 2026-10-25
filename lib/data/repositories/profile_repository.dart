import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_profile.dart';

class ProfileRepository {
  static const _profileKey = 'umeed_user_profile';
  UserProfile _currentProfile = const UserProfile();

  UserProfile get currentProfile => _currentProfile;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_profileKey);
      if (jsonStr != null) {
        _currentProfile = UserProfile.fromJson(json.decode(jsonStr));
      }
    } catch (_) {}
  }

  Future<void> saveProfile(UserProfile profile) async {
    _currentProfile = profile;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileKey, json.encode(profile.toJson()));
    } catch (_) {}
  }

  Future<void> updateMode(AppMode newMode) async {
    _currentProfile = _currentProfile.copyWith(mode: newMode);
    await saveProfile(_currentProfile);
  }

  Future<void> updateLanguage(String languageCode) async {
    _currentProfile = _currentProfile.copyWith(languageCode: languageCode);
    await saveProfile(_currentProfile);
  }

  Future<void> updateAnswer(String key, dynamic value) async {
    UserProfile updated = _currentProfile;
    switch (key) {
      case 'q_name':
        updated = updated.copyWith(name: value as String?);
        break;
      case 'q_age':
        updated = updated.copyWith(age: value as int?);
        break;
      case 'q_gender':
        updated = updated.copyWith(gender: value as String?);
        break;
      case 'q_state':
        updated = updated.copyWith(state: value as String?);
        break;
      case 'q_area':
        updated = updated.copyWith(area: value as String?);
        break;
      case 'q_caste':
        updated = updated.copyWith(casteCategory: value as String?);
        break;
      case 'q_income':
        updated = updated.copyWith(annualIncome: value as int?);
        break;
      case 'q_occupation':
        updated = updated.copyWith(occupation: value as String?);
        break;
      case 'q_education':
        updated = updated.copyWith(education: value as String?);
        break;
      case 'q_disability':
        updated = updated.copyWith(hasDisability: value as bool?);
        break;
      case 'q_family':
        updated = updated.copyWith(familySize: value as int?);
        break;
      case 'q_need':
        updated = updated.copyWith(primaryNeeds: value as List<String>);
        break;
      case 'q_sector_focus':
        updated = updated.copyWith(sectorFocus: value as String?);
        break;
      case 'output_language':
        updated = updated.copyWith(outputLanguage: value as String?);
        break;
    }
    await saveProfile(updated);
  }

  Future<void> deleteAllData() async {
    _currentProfile = const UserProfile();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileKey);
    } catch (_) {}
  }
}
