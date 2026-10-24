import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';

class SplashAndConsentScreen extends ConsumerStatefulWidget {
  const SplashAndConsentScreen({super.key});

  @override
  ConsumerState<SplashAndConsentScreen> createState() => _SplashAndConsentScreenState();
}

class _SplashAndConsentScreenState extends ConsumerState<SplashAndConsentScreen> {
  bool _isSpeakingConsent = false;

  @override
  void initState() {
    super.initState();
    // Auto-read consent in the background after UI renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playConsentAudio();
    });
  }

  Future<void> _playConsentAudio() async {
    final l10n = AppLocalizations.of(context);
    final bhashini = ref.read(bhashiniServiceProvider);
    final profile = ref.read(userProfileProvider);
    final text = "${l10n.translate('consent_title')}. ${l10n.translate('consent_body')}";

    setState(() => _isSpeakingConsent = true);
    await bhashini.speak(text, languageCode: profile.languageCode);
    if (mounted) {
      setState(() => _isSpeakingConsent = false);
    }
  }

  Future<void> _stopConsentAudio() async {
    final bhashini = ref.read(bhashiniServiceProvider);
    await bhashini.stop();
    if (mounted) {
      setState(() => _isSpeakingConsent = false);
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
      appBar: AppBar(
        title: Text(l10n.translate('app_name')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppTheme.cream),
            tooltip: l10n.translate('select_language'),
            onPressed: () => context.push('/language'),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.cream),
            tooltip: l10n.translate('settings'),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Brand Logo and Tagline
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.saffronOrange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.saffronOrange.withOpacity(0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.diversity_1_rounded,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Column(
                  children: [
                    Text(
                      "${l10n.translate('app_name')} · उम्मीद",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppTheme.deepNavy,
                            fontSize: 30,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.translate('app_tagline'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.saffronOrange,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Consent Card
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: AppTheme.dividerColor, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_outlined, color: AppTheme.indiaGreen, size: 28),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.translate('consent_title'),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _isSpeakingConsent ? Icons.volume_up : Icons.volume_down_outlined,
                                color: AppTheme.saffronOrange,
                                size: 28,
                              ),
                              tooltip: _isSpeakingConsent
                                  ? l10n.translate('stop_listening')
                                  : l10n.translate('listen'),
                              onPressed: () {
                                if (_isSpeakingConsent) {
                                  _stopConsentAudio();
                                } else {
                                  _playConsentAudio();
                                }
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.translate('consent_body'),
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        height: 1.6,
                                        color: AppTheme.bodyText,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.cream,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.Border.all(color: AppTheme.dividerColor),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.auto_delete_outlined, color: AppTheme.midNavy),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          "Recordings auto-delete after 30 days. No Aadhaar OTP or banking passwords are ever stored.",
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              // "I Agree & Continue" Button
              ElevatedButton.icon(
                onPressed: () {
                  _stopConsentAudio();
                  context.push('/mode');
                },
                icon: const Icon(Icons.check_circle_outline, size: 24),
                label: Text(l10n.translate('consent_agree')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(AppTheme.minTouchTargetSize),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
