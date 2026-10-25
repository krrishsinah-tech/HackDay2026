class DocumentRequirement {
  final String name;
  final String photoHint;
  final String plainReason;

  const DocumentRequirement({
    required this.name,
    required this.photoHint,
    required this.plainReason,
  });

  factory DocumentRequirement.fromJson(Map<String, dynamic> json) {
    return DocumentRequirement(
      name: json['name'] ?? '',
      photoHint: json['photo_hint'] ?? '',
      plainReason: json['plain_reason'] ?? '',
    );
  }
}

class EligibilityRules {
  final int minAge;
  final int maxAge;
  final List<String> occupations;
  final int maxAnnualIncome;
  final List<String> areas; // ['rural', 'urban', 'ALL']
  final List<String> states;
  final List<String> genders;
  final List<String> needs;
  final bool requiresDisability;

  const EligibilityRules({
    this.minAge = 0,
    this.maxAge = 120,
    this.occupations = const ['ALL'],
    this.maxAnnualIncome = 99999999,
    this.areas = const ['ALL'],
    this.states = const ['ALL'],
    this.genders = const ['ALL'],
    this.needs = const [],
    this.requiresDisability = false,
  });

  factory EligibilityRules.fromJson(Map<String, dynamic> json) {
    return EligibilityRules(
      minAge: json['min_age'] ?? 0,
      maxAge: json['max_age'] ?? 120,
      occupations: (json['occupations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['ALL'],
      maxAnnualIncome: json['max_annual_income'] ?? 99999999,
      areas: (json['areas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['ALL'],
      states: (json['states'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['ALL'],
      genders: (json['genders'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const ['ALL'],
      needs: (json['needs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      requiresDisability: json['requires_disability'] as bool? ?? false,
    );
  }
}

class Scheme {
  final String id;
  final bool mock;
  final String name;
  final String ministry;
  final String stateOrCentral;
  final int benefitAmount;
  final String benefitDescription;
  final String officialText;
  final String simplifiedText;
  final EligibilityRules eligibilityRules;
  final List<DocumentRequirement> documentsRequired;
  final String applyUrl;
  final String physicalOffice;
  final String deadline;
  final String lastChecked;
  final double easeScore;

  const Scheme({
    required this.id,
    this.mock = true,
    required this.name,
    required this.ministry,
    required this.stateOrCentral,
    required this.benefitAmount,
    required this.benefitDescription,
    required this.officialText,
    required this.simplifiedText,
    required this.eligibilityRules,
    required this.documentsRequired,
    required this.applyUrl,
    required this.physicalOffice,
    required this.deadline,
    required this.lastChecked,
    this.easeScore = 0.8,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['id'] ?? '',
      mock: json['mock'] ?? true,
      name: json['name'] ?? '',
      ministry: json['ministry'] ?? '',
      stateOrCentral: json['state_or_central'] ?? 'Central',
      benefitAmount: json['benefit_amount'] ?? 0,
      benefitDescription: json['benefit_description'] ?? '',
      officialText: json['official_text'] ?? '',
      simplifiedText: json['simplified_text'] ?? '',
      eligibilityRules: EligibilityRules.fromJson(json['eligibility_rules'] ?? {}),
      documentsRequired: (json['documents_required'] as List<dynamic>?)
              ?.map((e) => DocumentRequirement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      applyUrl: json['apply_url'] ?? '',
      physicalOffice: json['physical_office'] ?? '',
      deadline: json['deadline'] ?? '',
      lastChecked: json['last_checked'] ?? '24 October 2026',
      easeScore: (json['ease_score'] as num?)?.toDouble() ?? 0.8,
    );
  }
}
