import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/scheme.dart';
import '../domain/models/user_profile.dart';
import '../services/bhashini_service.dart';
import '../services/ranking_service.dart';
import '../data/repositories/scheme_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/help_desk_repository.dart';

// Singletons
final bhashiniServiceProvider = Provider<MockBhashiniService>((ref) => MockBhashiniService());
final rankingServiceProvider = Provider<RankingService>((ref) => RankingService());
final schemeRepositoryProvider = Provider<SchemeRepository>((ref) => SchemeRepository());
final helpDeskRepositoryProvider = Provider<HelpDeskRepository>((ref) => HelpDeskRepository());

// Profile Repository & State
final profileRepositoryProvider = Provider<ProfileRepository>((ref) => ProfileRepository());

class UserProfileNotifier extends StateNotifier<UserProfile> {
  final ProfileRepository _repo;

  UserProfileNotifier(this._repo) : super(_repo.currentProfile);

  Future<void> setMode(AppMode mode) async {
    await _repo.updateMode(mode);
    state = _repo.currentProfile;
  }

  Future<void> setLanguage(String code) async {
    await _repo.updateLanguage(code);
    state = _repo.currentProfile;
  }

  Future<void> updateAnswer(String key, dynamic val) async {
    await _repo.updateAnswer(key, val);
    state = _repo.currentProfile;
  }

  Future<void> clearAll() async {
    await _repo.deleteAllData();
    state = _repo.currentProfile;
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return UserProfileNotifier(repo);
});

// Current Locale Provider
final currentLocaleProvider = StateProvider<Locale>((ref) {
  final profile = ref.watch(userProfileProvider);
  return Locale(profile.languageCode);
});

// All Schemes Provider
final allSchemesProvider = FutureProvider<List<Scheme>>((ref) async {
  final repo = ref.watch(schemeRepositoryProvider);
  return await repo.getSchemes();
});

// Ranked Schemes Provider
final rankedSchemesProvider = Provider<List<RankedScheme>>((ref) {
  final allSchemesAsync = ref.watch(allSchemesProvider);
  final profile = ref.watch(userProfileProvider);
  final rankingService = ref.watch(rankingServiceProvider);

  return allSchemesAsync.maybeWhen(
    data: (schemes) => rankingService.rankSchemes(schemes, profile),
    orElse: () => [],
  );
});
