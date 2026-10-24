enum QuestionInputType { text, number, choice, multiChoice }

class QuestionConfig {
  final int index;
  final String key;
  final QuestionInputType inputType;
  final List<String> options;
  final bool isSensitive;
  final String? whyAskedKey;

  const QuestionConfig({
    required this.index,
    required this.key,
    required this.inputType,
    this.options = const [],
    this.isSensitive = false,
    this.whyAskedKey,
  });
}

class IntakeQuestions {
  static const List<String> indianStatesAndUTs = [
    "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
    "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand",
    "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur",
    "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab",
    "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura",
    "Uttar Pradesh", "Uttarakhand", "West Bengal",
    "Andaman and Nicobar Islands", "Chandigarh", "Dadra and Nagar Haveli and Daman and Diu",
    "Delhi", "Jammu and Kashmir", "Ladakh", "Lakshadweep", "Puducherry"
  ];

  static const List<QuestionConfig> list = [
    QuestionConfig(
      index: 1,
      key: 'q_name',
      inputType: QuestionInputType.text,
    ),
    QuestionConfig(
      index: 2,
      key: 'q_age',
      inputType: QuestionInputType.number,
    ),
    QuestionConfig(
      index: 3,
      key: 'q_gender',
      inputType: QuestionInputType.choice,
      options: ['Woman', 'Man', 'Other'],
    ),
    QuestionConfig(
      index: 4,
      key: 'q_state',
      inputType: QuestionInputType.choice,
      options: indianStatesAndUTs,
    ),
    QuestionConfig(
      index: 5,
      key: 'q_area',
      inputType: QuestionInputType.choice,
      options: ['Rural (Village)', 'Urban (City/Town)'],
    ),
    QuestionConfig(
      index: 6,
      key: 'q_caste',
      inputType: QuestionInputType.choice,
      options: ['General', 'OBC', 'SC', 'ST'],
      isSensitive: true,
      whyAskedKey: 'caste_why',
    ),
    QuestionConfig(
      index: 7,
      key: 'q_income',
      inputType: QuestionInputType.choice,
      options: [
        'Below ₹1,00,000',
        '₹1,00,000 - ₹2,50,000',
        '₹2,50,000 - ₹5,00,000',
        'Above ₹5,00,000',
      ],
      isSensitive: true,
      whyAskedKey: 'income_why',
    ),
    QuestionConfig(
      index: 8,
      key: 'q_occupation',
      inputType: QuestionInputType.choice,
      options: ['Farmer', 'Student', 'Laborer', 'Homemaker', 'Business', 'Other'],
    ),
    QuestionConfig(
      index: 9,
      key: 'q_education',
      inputType: QuestionInputType.choice,
      options: [
        'No formal schooling',
        'Up to 10th standard',
        '12th standard / Intermediate',
        'Graduate or higher',
      ],
    ),
    QuestionConfig(
      index: 10,
      key: 'q_disability',
      inputType: QuestionInputType.choice,
      options: ['Yes', 'No'],
      isSensitive: true,
      whyAskedKey: 'disability_why',
    ),
    QuestionConfig(
      index: 11,
      key: 'q_family',
      inputType: QuestionInputType.number,
    ),
    QuestionConfig(
      index: 12,
      key: 'q_need',
      inputType: QuestionInputType.multiChoice,
      options: ['Farming', 'Education', 'Health', 'Housing', 'Money', 'Jobs'],
    ),
    QuestionConfig(
      index: 13,
      key: 'q_sector_focus',
      inputType: QuestionInputType.choice,
      options: [
        'Agriculture & Farming (कृषि एवं किसान)',
        'Finance, Loans & Banking (वित्त एवं ऋण)',
        'Healthcare & Medicine (स्वास्थ्य एवं चिकित्सा)',
        'Housing & Living (आवास एवं मकान)',
        'Education & Skills (शिक्षा एवं हुनर)',
        'Jobs & Small Business (रोज़गार एवं व्यापार)',
        'Pension & Social Welfare (पेंशन एवं सुरक्षा)',
      ],
    ),
  ];
}
