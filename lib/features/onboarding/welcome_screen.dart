import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playWelcomeAudio();
    });
  }

  Future<void> _playWelcomeAudio() async {
    final bhashini = ref.read(bhashiniServiceProvider);
    final profile = ref.read(userProfileProvider);
    final welcomeText = "नमस्ते! उम्मीद में आपका स्वागत है। आपकी उम्मीद, हमारी ज़िम्मेदारी। शुरू करने के लिए आगे बढ़ें का बटन दबाएं।";

    setState(() => _isSpeaking = true);
    await bhashini.speak(welcomeText, languageCode: profile.languageCode, speed: 0.78);
    if (mounted) {
      setState(() => _isSpeaking = false);
    }
  }

  Future<void> _stopAudio() async {
    final bhashini = ref.read(bhashiniServiceProvider);
    await bhashini.stop();
    if (mounted) {
      setState(() => _isSpeaking = false);
    }
  }

  @override
  void dispose() {
    ref.read(bhashiniServiceProvider).stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Audio Assistance Pill
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: _isSpeaking ? _stopAudio : _playWelcomeAudio,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.saffronOrange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.saffronOrange.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isSpeaking ? Icons.volume_up : Icons.volume_down_outlined,
                          color: AppTheme.saffronOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isSpeaking ? "आवाज़ रोकें" : "आवाज़ सुनें",
                          style: const TextStyle(
                            color: AppTheme.deepNavy,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Central Brand & Welcome Banner
              Column(
                children: [
                  // Aesthetic Logo Emblem
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9E3B), AppTheme.saffronOrange, Color(0xFFC85A00)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.saffronOrange.withOpacity(0.45),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Soft Diya Base Curve
                        Positioned(
                          bottom: 14,
                          child: Container(
                            width: 52,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE082).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        // Devanagari 'उ'
                        const Text(
                          "उ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                            ],
                          ),
                        ),
                        // Golden Spark Star of Hope
                        const Positioned(
                          top: 14,
                          right: 18,
                          child: Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFF9C4)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Brand Title
                  Text(
                    "उम्मीद · Umeed",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppTheme.deepNavy,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Clean Slogan without Black Box
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          "आपकी उम्मीद, हमारी ज़िम्मेदारी",
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppTheme.deepNavy,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "\"Aapki Umeed, Hamari Zimmedaari\"",
                          style: TextStyle(
                            color: AppTheme.saffronOrange,
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Your Hope, Our Responsibility · 100% निःशुल्क",
                          style: TextStyle(
                            color: AppTheme.mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "बोलिए अपनी समस्या, हम ढूंढेंगे आपकी सरकारी योजना।",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.saffronOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // Trust Highlights Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppTheme.dividerColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppTheme.indiaGreen, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "22 भारतीय भाषाओं में आसान सहायता",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.record_voice_over_rounded, color: AppTheme.saffronOrange, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "बोलकर या लिखकर – दोनों तरह से आसान",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.support_agent_rounded, color: AppTheme.midNavy, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "जन-सहायक द्वारा निःशुल्क मार्गदर्शन",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Step 1 -> Step 2 Action Button (Leads to Language Selection)
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _stopAudio();
                      context.push('/language');
                    },
                    icon: const Icon(Icons.translate_rounded, size: 24),
                    label: const Text(
                      "भाषा चुनें / Select Language",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.saffronOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "सुरक्षित एवं गोपनीय · डेटा 30 दिनों में स्वतः हट जाता है",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
