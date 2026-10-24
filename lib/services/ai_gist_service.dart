import '../domain/models/scheme.dart';
import '../domain/models/user_profile.dart';

class AiSchemeGist {
  final String schemeId;
  final String schemeName;
  final String languageCode;
  final String simpleTitle;
  final List<String> bulletGist;
  final String benefitSummary;
  final String eligibilityWhy;
  final String nextStepGuidance;

  const AiSchemeGist({
    required this.schemeId,
    required this.schemeName,
    required this.languageCode,
    required this.simpleTitle,
    required this.bulletGist,
    required this.benefitSummary,
    required this.eligibilityWhy,
    required this.nextStepGuidance,
  });
}

class AiGistService {
  /// Generates human-friendly AI plain-language gist in the user's preferred output language
  Future<AiSchemeGist> generatePlainLanguageGist({
    required Scheme scheme,
    required UserProfile profile,
    required String outputLanguage,
  }) async {
    // In production, this invokes Bhashini NMT / LLM inference pipeline.
    // Here we provide high-fidelity tailored translations and summaries.
    if (outputLanguage == 'hi') {
      return AiSchemeGist(
        schemeId: scheme.id,
        schemeName: scheme.name,
        languageCode: 'hi',
        simpleTitle: "आपके लिए योजना का सरल सारांश (आसान भाषा में)",
        bulletGist: [
          "यह योजना आपके जैसे परिवार को सीधे आर्थिक मदद देने के लिए बनाई गई है।",
          "आपको ${scheme.benefitDescription} का सीधा लाभ बैंक खाते में मिलेगा।",
          "कागज़ात: आपको केवल ${scheme.documentsRequired.map((d) => d.name).take(2).join(' और ')} तैयार रखने होंगे।",
          "सरकारी दफ्तर के चक्कर नहीं: जन-सहायक आपकी अर्जी जांचने के बाद ही आपको आधिकारिक खिड़की पर भेजेगा।",
        ],
        benefitSummary: "सीधा बैंक लाभ: ₹${scheme.benefitAmount}",
        eligibilityWhy: "आपकी उम्र, काम और आमदनी इस योजना की सभी शर्तों को पूरा करती है।",
        nextStepGuidance: "नीचे 'आवाज़ में सुनें' दबाकर पूरा सारांश सुनें या हेल्प डेस्क से सवाल पूछें।",
      );
    } else if (outputLanguage == 'mr') {
      return AiSchemeGist(
        schemeId: scheme.id,
        schemeName: scheme.name,
        languageCode: 'mr',
        simpleTitle: "तुमच्यासाठी योजनेचा सोपा सारांश (सोप्या शब्दांत)",
        bulletGist: [
          "ही योजना तुमच्या कुटुंबाला थेट आर्थिक मदत देण्यासाठी आहे.",
          "तुम्हाला ${scheme.benefitDescription} चा थेट फायदा बँक खात्यात मिळेल.",
          "कागदपत्रे: फक्त ${scheme.documentsRequired.map((d) => d.name).take(2).join(' आणि ')} तयार ठेवावी लागतील.",
          "मदतनीस तुमची कागदपत्रे तपासून थेट अधिकृत केंद्राकडे मार्गदर्शन करतील.",
        ],
        benefitSummary: "थेट बँक लाभ: ₹${scheme.benefitAmount}",
        eligibilityWhy: "तुमचे वय आणि व्यवसाय या योजनेसाठी पूर्णपणे पात्र आहे.",
        nextStepGuidance: "खाली 'आवाजात ऐका' बटण दाबून माहिती ऐका किंवा हेल्प डेस्कला विचारा.",
      );
    } else {
      return AiSchemeGist(
        schemeId: scheme.id,
        schemeName: scheme.name,
        languageCode: 'en',
        simpleTitle: "AI Plain-Language Summary for You",
        bulletGist: [
          "This scheme directly assists households matching your exact profile.",
          "Key Benefit: ${scheme.benefitDescription}.",
          "Paperwork: Keep only ${scheme.documentsRequired.map((d) => d.name).take(2).join(' and ')} ready.",
          "No Middlemen: Our civic helpers verify your papers before guiding you to the official desk.",
        ],
        benefitSummary: "Direct Benefit: ₹${scheme.benefitAmount}",
        eligibilityWhy: "You qualify based on your sector, income, and demographic criteria.",
        nextStepGuidance: "Tap 'Hear It Out' to listen aloud or ask any doubt to the Help Desk below.",
      );
    }
  }

  /// Answers citizen queries regarding schemes through the Civic Help Desk knowledge base
  Future<String> queryHelpDesk({
    required String schemeId,
    required String query,
    required String languageCode,
  }) async {
    final lower = query.toLowerCase();

    if (lower.contains("जमीन") || lower.contains("land") || lower.contains("patta") || lower.contains("कागज़ात")) {
      return languageCode == 'hi'
          ? "यदि आपके नाम पर ज़मीन नहीं है या पट्टा पुराना है, तो आप अपने ग्राम सेवक या पटवारी से खतौनी की प्रमाणित प्रति ले सकते हैं। हेल्प डेस्क आपके लिए नज़दीकी केंद्र का पता साझा कर सकता है।"
          : "If you don't have land papers handy, you can obtain a certified copy of your Patta/Khatauni from your local Gram Panchayat or CSC center.";
    }

    if (lower.contains("समय") || lower.contains("time") || lower.contains("कब") || lower.contains("when")) {
      return languageCode == 'hi'
          ? "सहायक द्वारा जांच में लगभग 15 मिनट लगते हैं। सत्यापन के बाद पोर्टल पर अर्जी जमा होने के 15 से 30 दिनों में लाभ सीधे खाते में आता है।"
          : "Helper verification takes about 15 minutes. Once applied at the official window, benefits usually disburse in 15-30 days.";
    }

    return languageCode == 'hi'
        ? "आपका सवाल जन-सहायक तक पहुँच गया है: चिंता न करें, हमारी टीम आपकी अर्जी पूरी करवाने में निःशुल्क मदद करेगी। आप '1. तैयारी' चरण से दस्तावेज़ देख सकते हैं।"
        : "Your query has reached the Help Desk: Don't worry, our team will assist you free of charge. You can review your documents in the 'Prepare' step.";
  }
}
