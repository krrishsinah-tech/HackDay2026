import 'package:flutter_test/flutter_test.dart';
import 'package:umeed/domain/models/scheme.dart';
import 'package:umeed/domain/models/user_profile.dart';
import 'package:umeed/services/ranking_service.dart';

void main() {
  group('Eligibility Matcher & Demographic Gating Tests', () {
    final rankingService = RankingService();

    const womenScheme = Scheme(
      id: 'pmmvy',
      name: 'PMMVY Maternity Support',
      ministry: 'WCD',
      stateOrCentral: 'Central',
      benefitAmount: 5000,
      benefitDescription: '₹5,000 maternity support',
      officialText: 'Conditional cash transfer for pregnant women',
      simplifiedText: '₹5,000 for pregnant mothers',
      eligibilityRules: EligibilityRules(
        minAge: 19,
        maxAge: 45,
        genders: ['woman', 'female'],
        occupations: ['ALL'],
        maxAnnualIncome: 300000,
        areas: ['ALL'],
      ),
      documentsRequired: [],
      applyUrl: 'https://pmmvy.wcd.gov.in',
      physicalOffice: 'Anganwadi',
      deadline: 'Open',
      lastChecked: '24 October 2026',
    );

    const oldAgePensionScheme = Scheme(
      id: 'nsap_pension',
      name: 'NSAP Old Age Pension',
      ministry: 'Rural Development',
      stateOrCentral: 'Central',
      benefitAmount: 12000,
      benefitDescription: 'Monthly pension',
      officialText: 'Pension for senior citizens aged 60 and above',
      simplifiedText: 'Monthly pension for seniors above 60',
      eligibilityRules: EligibilityRules(
        minAge: 60,
        maxAge: 120,
        genders: ['ALL'],
        occupations: ['ALL'],
        maxAnnualIncome: 120000,
        areas: ['ALL'],
      ),
      documentsRequired: [],
      applyUrl: 'https://nsap.nic.in',
      physicalOffice: 'BDO Office',
      deadline: 'Open',
      lastChecked: '24 October 2026',
    );

    test('Male user is strictly excluded from women-only scheme', () {
      const maleProfile = UserProfile(
        name: 'Amit',
        age: 28,
        gender: 'man',
        annualIncome: 100000,
      );

      final score = rankingService.calculateEligibilityScore(womenScheme, maleProfile);
      expect(score, equals(0.0));
    });

    test('Eligible female user qualifies for maternity scheme', () {
      const femaleProfile = UserProfile(
        name: 'Sunita',
        age: 26,
        gender: 'woman',
        annualIncome: 100000,
      );

      final score = rankingService.calculateEligibilityScore(womenScheme, femaleProfile);
      expect(score, greaterThan(0.8));
    });

    test('Citizen under 60 is strictly excluded from old age pension', () {
      const youngProfile = UserProfile(
        name: 'Rahul',
        age: 42,
        annualIncome: 80000,
      );

      final score = rankingService.calculateEligibilityScore(oldAgePensionScheme, youngProfile);
      expect(score, equals(0.0));
    });

    test('Senior citizen with low income qualifies for old age pension', () {
      const seniorProfile = UserProfile(
        name: 'Kashinath',
        age: 68,
        annualIncome: 70000,
      );

      final score = rankingService.calculateEligibilityScore(oldAgePensionScheme, seniorProfile);
      expect(score, greaterThan(0.8));
    });

    test('Citizen with income above threshold is excluded', () {
      const highIncomeSenior = UserProfile(
        name: 'Jagdish',
        age: 68,
        annualIncome: 450000, // Ceiling is 120000
      );

      final score = rankingService.calculateEligibilityScore(oldAgePensionScheme, highIncomeSenior);
      expect(score, equals(0.0));
    });
  });
}
