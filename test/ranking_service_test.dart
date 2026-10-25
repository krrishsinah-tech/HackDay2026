import 'package:flutter_test/flutter_test.dart';
import 'package:umeed/domain/models/scheme.dart';
import 'package:umeed/domain/models/user_profile.dart';
import 'package:umeed/services/ranking_service.dart';

void main() {
  group('RankingService Tests', () {
    late RankingService rankingService;
    late List<Scheme> testSchemes;

    setUp(() {
      rankingService = RankingService();
      testSchemes = [
        const Scheme(
          id: 'pm_kisan',
          name: 'PM Kisan Samman Nidhi',
          ministry: 'Ministry of Agriculture',
          stateOrCentral: 'Central',
          benefitAmount: 6000,
          benefitDescription: '₹6,000 yearly',
          officialText: 'Income support for landholding farmers',
          simplifiedText: '₹6,000 direct bank transfer per year for farmers',
          eligibilityRules: EligibilityRules(
            minAge: 18,
            maxAge: 100,
            occupations: ['farmer'],
            maxAnnualIncome: 300000,
            areas: ['rural', 'urban'],
          ),
          documentsRequired: [
            DocumentRequirement(name: 'Aadhaar Card', photoHint: 'Clear ID', plainReason: 'Proof of ID'),
            DocumentRequirement(name: 'Land Patta', photoHint: 'Land record', plainReason: 'Proof of farm land'),
          ],
          applyUrl: 'https://pmkisan.gov.in',
          physicalOffice: 'Panchayat',
          deadline: 'Open',
          lastChecked: '24 October 2026',
          easeScore: 0.90,
        ),
        const Scheme(
          id: 'ayushman_bharat',
          name: 'Ayushman Bharat PM-JAY',
          ministry: 'Ministry of Health',
          stateOrCentral: 'Central',
          benefitAmount: 500000,
          benefitDescription: '₹5,00,000 hospitalization cover',
          officialText: 'Secondary and tertiary hospitalization cover',
          simplifiedText: 'Free hospital treatment up to ₹5 Lakh per family',
          eligibilityRules: EligibilityRules(
            minAge: 0,
            maxAge: 100,
            occupations: ['ALL'],
            maxAnnualIncome: 250000,
            areas: ['rural', 'urban'],
            needs: ['health'],
          ),
          documentsRequired: [
            DocumentRequirement(name: 'Aadhaar Card', photoHint: 'Clear ID', plainReason: 'Proof of ID'),
            DocumentRequirement(name: 'Ration Card', photoHint: 'Family card', plainReason: 'Proof of BPL'),
          ],
          applyUrl: 'https://beneficiary.nha.gov.in',
          physicalOffice: 'District Hospital',
          deadline: 'Open',
          lastChecked: '24 October 2026',
          easeScore: 0.88,
        ),
        const Scheme(
          id: 'pm_svanidhi',
          name: 'PM SVANidhi',
          ministry: 'Ministry of Housing',
          stateOrCentral: 'Central',
          benefitAmount: 50000,
          benefitDescription: '₹10,000 to ₹50,000 collateral-free loan',
          officialText: 'Micro-credit for street vendors',
          simplifiedText: 'Low interest working capital loan for street vendors',
          eligibilityRules: EligibilityRules(
            minAge: 18,
            maxAge: 70,
            occupations: ['laborer', 'business'],
            maxAnnualIncome: 300000,
            areas: ['urban'],
            needs: ['jobs', 'money'],
          ),
          documentsRequired: [
            DocumentRequirement(name: 'Aadhaar Card', photoHint: 'Clear ID', plainReason: 'Proof of ID'),
            DocumentRequirement(name: 'Vending Certificate', photoHint: 'ULB card', plainReason: 'Proof of street vending'),
          ],
          applyUrl: 'https://pmsvanidhi.mohua.gov.in',
          physicalOffice: 'Municipal office',
          deadline: 'Open',
          lastChecked: '24 October 2026',
          easeScore: 0.80,
        ),
      ];
    });

    test('Rural Farmer Profile ranks PM-KISAN or Ayushman Bharat highest', () {
      const ruralFarmer = UserProfile(
        name: 'Suresh Patil',
        age: 45,
        gender: 'man',
        area: 'rural',
        occupation: 'farmer',
        annualIncome: 120000,
        primaryNeeds: ['farming', 'health'],
      );

      final ranked = rankingService.rankSchemes(testSchemes, ruralFarmer);

      // Rural farmer does not qualify for urban SVANidhi
      expect(ranked.any((r) => r.scheme.id == 'pm_svanidhi'), isFalse);

      // Farmer qualifies for PM Kisan and Ayushman Bharat
      expect(ranked.length, equals(2));
      expect(ranked[0].tier, equals(MatchTier.best));
      expect(ranked[1].tier, equals(MatchTier.better));
    });

    test('Generates clear plain-words qualification reason', () {
      const profile = UserProfile(
        name: 'Gita Devi',
        age: 35,
        gender: 'woman',
        area: 'rural',
        occupation: 'farmer',
        annualIncome: 150000,
      );

      final reason = rankingService.generateQualificationReason(testSchemes[0], profile);
      expect(reason, contains('you work as a farmer'));
      expect(reason, contains('you reside in a rural locality'));
      expect(reason, contains('your annual family income is under ₹300000'));
    });

    test('Benefit score scales monotonically with benefit amount', () {
      final scoreSmall = rankingService.calculateBenefitScore(6000);
      final scoreLarge = rankingService.calculateBenefitScore(500000);
      expect(scoreLarge, greaterThan(scoreSmall));
    });
  });
}
