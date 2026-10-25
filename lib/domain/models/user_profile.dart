enum AppMode { voice, text }

class UserProfile {
  final AppMode mode;
  final String languageCode;
  final String? name;
  final int? age;
  final String? gender; // 'woman', 'man', 'other'
  final String? state;
  final String? area; // 'rural', 'urban'
  final String? casteCategory; // 'General', 'OBC', 'SC', 'ST'
  final int? annualIncome;
  final String? occupation; // 'farmer', 'student', 'laborer', 'homemaker', 'business', 'other'
  final String? education;
  final int? familySize;
  final List<String> primaryNeeds; // 'farming', 'education', 'health', 'housing', 'money', 'jobs'
  final String? sectorFocus; // 'Agriculture', 'Finance', 'Healthcare', 'Housing', 'Education', 'Jobs', 'Pension'
  final String? outputLanguage; // Preferred language for AI plain-language summary

  const UserProfile({
    this.mode = AppMode.voice,
    this.languageCode = 'en',
    this.name,
    this.age,
    this.gender,
    this.state,
    this.area,
    this.casteCategory,
    this.annualIncome,
    this.occupation,
    this.education,
    this.hasDisability,
    this.familySize,
    this.primaryNeeds = const [],
    this.sectorFocus,
    this.outputLanguage,
  });

  UserProfile copyWith({
    AppMode? mode,
    String? languageCode,
    String? name,
    int? age,
    String? gender,
    String? state,
    String? area,
    String? casteCategory,
    int? annualIncome,
    String? occupation,
    String? education,
    bool? hasDisability,
    int? familySize,
    List<String>? primaryNeeds,
    String? sectorFocus,
    String? outputLanguage,
  }) {
    return UserProfile(
      mode: mode ?? this.mode,
      languageCode: languageCode ?? this.languageCode,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      area: area ?? this.area,
      casteCategory: casteCategory ?? this.casteCategory,
      annualIncome: annualIncome ?? this.annualIncome,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      hasDisability: hasDisability ?? this.hasDisability,
      familySize: familySize ?? this.familySize,
      primaryNeeds: primaryNeeds ?? this.primaryNeeds,
      sectorFocus: sectorFocus ?? this.sectorFocus,
      outputLanguage: outputLanguage ?? this.outputLanguage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mode': mode.name,
      'languageCode': languageCode,
      'name': name,
      'age': age,
      'gender': gender,
      'state': state,
      'area': area,
      'casteCategory': casteCategory,
      'annualIncome': annualIncome,
      'occupation': occupation,
      'education': education,
      'hasDisability': hasDisability,
      'familySize': familySize,
      'primaryNeeds': primaryNeeds,
      'sectorFocus': sectorFocus,
      'outputLanguage': outputLanguage,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      mode: json['mode'] == 'text' ? AppMode.text : AppMode.voice,
      languageCode: json['languageCode'] ?? 'en',
      name: json['name'],
      age: json['age'] != null ? (json['age'] as num).toInt() : null,
      gender: json['gender'],
      state: json['state'],
      area: json['area'],
      casteCategory: json['casteCategory'],
      annualIncome: json['annualIncome'] != null ? (json['annualIncome'] as num).toInt() : null,
      occupation: json['occupation'],
      education: json['education'],
      hasDisability: json['hasDisability'] as bool?,
      familySize: json['familySize'] != null ? (json['familySize'] as num).toInt() : null,
      primaryNeeds: (json['primaryNeeds'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      sectorFocus: json['sectorFocus'],
      outputLanguage: json['outputLanguage'],
    );
  }

  int get answeredCount {
    int count = 0;
    if (name != null && name!.isNotEmpty) count++;
    if (age != null) count++;
    if (gender != null) count++;
    if (state != null) count++;
    if (area != null) count++;
    if (casteCategory != null) count++;
    if (annualIncome != null) count++;
    if (occupation != null) count++;
    if (education != null) count++;
    if (hasDisability != null) count++;
    if (familySize != null) count++;
    if (primaryNeeds.isNotEmpty) count++;
    return count;
  }
}
