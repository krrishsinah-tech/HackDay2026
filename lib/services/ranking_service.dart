import 'dart:math';
import '../domain/models/scheme.dart';
import '../domain/models/user_profile.dart';

enum MatchTier { best, better, good, other, notEligible }

class RankedScheme {
  final Scheme scheme;
  final double overallScore;
  final double eligibilityScore;
  final double benefitScore;
  final double easeScore;
  final MatchTier tier;
  final String qualificationReason;

  const RankedScheme({
    required this.scheme,
    required this.overallScore,
    required this.eligibilityScore,
    required this.benefitScore,
    required this.easeScore,
    required this.tier,
    required this.qualificationReason,
  });
}

class RankingService {
  /// Computes ranked list of schemes tailored to the user profile
  List<RankedScheme> rankSchemes(List<Scheme> allSchemes, UserProfile profile) {
    final scoredList = <RankedScheme>[];

    for (final scheme in allSchemes) {
      final eligibility = calculateEligibilityScore(scheme, profile);
      // Exclude hard mismatches
      if (eligibility <= 0.0) continue;

      final benefit = calculateBenefitScore(scheme.benefitAmount);
      final ease = scheme.easeScore;

      // 3 Weighted Factors:
      // 1. Qualification clarity (50%)
      // 2. Benefit size (30%)
      // 3. Ease of acquisition (20%)
      final overall = (eligibility * 0.50) + (benefit * 0.30) + (ease * 0.20);
      final reason = generateQualificationReason(scheme, profile);

      scoredList.add(RankedScheme(
        scheme: scheme,
        overallScore: overall,
        eligibilityScore: eligibility,
        benefitScore: benefit,
        easeScore: ease,
        tier: MatchTier.other,
        qualificationReason: reason,
      ));
    }

    // Sort descending by overall score
    scoredList.sort((a, b) => b.overallScore.compareTo(a.overallScore));

    // Assign top 3 tiers according to specification
    final ranked = <RankedScheme>[];
    for (int i = 0; i < scoredList.length; i++) {
      final item = scoredList[i];
      MatchTier tier = MatchTier.other;
      if (i == 0) {
        tier = MatchTier.best; // #1 Best Match (Orange)
      } else if (i == 1) {
        tier = MatchTier.better; // #2 Better (Green)
      } else if (i == 2) {
        tier = MatchTier.good; // #3 Good (Grey-blue)
      }

      ranked.add(RankedScheme(
        scheme: item.scheme,
        overallScore: item.overallScore,
        eligibilityScore: item.eligibilityScore,
        benefitScore: item.benefitScore,
        easeScore: item.easeScore,
        tier: tier,
        qualificationReason: item.qualificationReason,
      ));
    }

    return ranked;
  }

  /// Calculates demographic and economic fit from 0.0 to 1.0
  double calculateEligibilityScore(Scheme scheme, UserProfile profile) {
    final rules = scheme.eligibilityRules;
    double score = 0.0;
    int criteriaChecked = 0;

    // Age Check
    if (profile.age != null) {
      criteriaChecked++;
      if (profile.age! >= rules.minAge && profile.age! <= rules.maxAge) {
        score += 1.0;
      } else {
        return 0.0; // Hard fail if outside age limit
      }
    }

    // Gender Check
    if (profile.gender != null) {
      criteriaChecked++;
      final userGender = profile.gender!.toLowerCase();
      final allowed = rules.genders.map((g) => g.toLowerCase()).toList();
      if (allowed.contains('all') || allowed.contains(userGender)) {
        score += 1.0;
      } else {
        return 0.0; // Hard fail if strictly for other gender
      }
    }

    // Occupation Check
    if (profile.occupation != null) {
      criteriaChecked++;
      final userOcc = profile.occupation!.toLowerCase();
      final allowed = rules.occupations.map((o) => o.toLowerCase()).toList();
      if (allowed.contains(userOcc)) {
        score += 1.3; // Boost for targeted occupation schemes (e.g. farmer for farmers)
      } else if (allowed.contains('all')) {
        score += 1.0;
      } else {
        return 0.0; // Hard fail if occupation specific
      }
    }

    // Disability Check
    if (rules.requiresDisability) {
      criteriaChecked++;
      if (profile.hasDisability == true) {
        score += 1.5;
      } else {
        return 0.0; // Hard fail if scheme specifically requires disability
      }
    }

    // Area Check (Rural / Urban)
    if (profile.area != null) {
      criteriaChecked++;
      final userArea = profile.area!.toLowerCase();
      final allowed = rules.areas.map((a) => a.toLowerCase()).toList();
      if (allowed.contains(userArea)) {
        score += 1.1; // Slight bonus for explicit area target
      } else if (allowed.contains('all')) {
        score += 1.0;
      } else {
        return 0.0; // Hard fail if area specific (e.g. Gramin vs Urban)
      }
    }

    // Income Check
    if (profile.annualIncome != null) {
      criteriaChecked++;
      if (profile.annualIncome! <= rules.maxAnnualIncome) {
        score += 1.0;
      } else {
        return 0.0; // Hard fail if income exceeds ceiling
      }
    }

    // Primary Needs Check (Soft Bonus)
    if (profile.primaryNeeds.isNotEmpty && rules.needs.isNotEmpty) {
      final matches = profile.primaryNeeds
          .where((need) => rules.needs.any((rn) => rn.toLowerCase() == need.toLowerCase()))
          .length;
      if (matches > 0) {
        score += 0.5;
        criteriaChecked++;
      }
    }

    if (criteriaChecked == 0) return 0.7; // Default baseline if profile sparse
    return (score / criteriaChecked).clamp(0.0, 1.0);
  }

  /// Calculates benefit value score logarithmically from 0.0 to 1.0
  double calculateBenefitScore(int amount) {
    if (amount <= 0) return 0.2;
    // Logarithmic scale up to ₹5,00,000
    final logVal = log(amount) / log(500000);
    return logVal.clamp(0.1, 1.0);
  }

  /// Generates a plain-words rationale explaining why the user qualifies
  String generateQualificationReason(Scheme scheme, UserProfile profile) {
    final reasons = <String>[];

    if (profile.occupation != null &&
        scheme.eligibilityRules.occupations.any((o) => o.toLowerCase() == profile.occupation!.toLowerCase())) {
      reasons.add("you work as a ${profile.occupation}");
    }

    if (profile.area != null &&
        scheme.eligibilityRules.areas.any((a) => a.toLowerCase() == profile.area!.toLowerCase())) {
      reasons.add("you reside in a ${profile.area} locality");
    }

    if (profile.annualIncome != null && profile.annualIncome! <= scheme.eligibilityRules.maxAnnualIncome) {
      reasons.add("your annual family income is under ₹${scheme.eligibilityRules.maxAnnualIncome}");
    }

    if (profile.gender != null && profile.gender!.toLowerCase() == 'woman') {
      reasons.add("you qualify under women empowerment provisions");
    }

    if (reasons.isEmpty) {
      return "You meet the standard age and residential requirements for this scheme.";
    }

    return "You qualify because ${reasons.join(', ')}.";
  }
}
