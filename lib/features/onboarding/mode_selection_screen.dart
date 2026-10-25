import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/user_profile.dart';
import '../../providers/app_providers.dart';

class ModeSelectionScreen extends ConsumerStatefulWidget {
  const ModeSelectionScreen({super.key});

  @override
  ConsumerState<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends ConsumerState<ModeSelectionScreen> {
  bool _isPlayingPrompt = false;

  @override
  void initState() {
    super.initState();
    // Play spoken audio prompt when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playAudioPrompt();
    });
  }

  Future<void> _playAudioPrompt() async {
    final l10n = AppLocalizations.of(context);
    final bhashini = ref.read(bhashiniServiceProvider);
    final profile = ref.read(userProfileProvider);
    final prompt = l10n.translate('mode_audio_prompt');

    setState(() => _isPlayingPrompt = true);
    await bhashini.speak(prompt, languageCode: profile.languageCode, speed: 0.78);
    if (mounted) {
      setState(() => _isPlayingPrompt = false);
    }
  }

  Future<void> _stopAudioPrompt() async {
    final bhashini = ref.read(bhashiniServiceProvider);
    await bhashini.stop();
    if (mounted) {
      setState(() => _isPlayingPrompt = false);
    }
  }

  @override
  void dispose() {
    ref.read(bhashiniServiceProvider).stop();
    super.dispose();
  }

  void _chooseMode(AppMode mode) async {
    await _stopAudioPrompt();
    await ref.read(userProfileProvider.notifier).setMode(mode);
    if (!mounted) return;
    context.push('/intake');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(l10n.translate('app_name')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.translate('select_language'),
            onPressed: () => context.push('/language'),
          ),
          IconButton(
            icon: Icon(
              _isPlayingPrompt ? Icons.volume_up : Icons.volume_down_outlined,
              color: AppTheme.saffronOrange,
            ),
            tooltip: l10n.translate('listen'),
            onPressed: () {
              if (_isPlayingPrompt) {
                _stopAudioPrompt();
              } else {
                _playAudioPrompt();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // Screen Header
              Text(
                l10n.translate('mode_selection_title'),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Audio prompt helper notice
              InkWell(
                onTap: _playAudioPrompt,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.saffronOrange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.saffronOrange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isPlayingPrompt ? Icons.graphic_eq : Icons.volume_up,
                        color: AppTheme.saffronOrange,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.translate('mode_audio_prompt'),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.deepNavy,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // CARD 1: Voice Mode (Orange, Recommended for low literacy)
              Expanded(
                child: Semantics(
                  button: true,
                  label: "Voice Mode. Recommended for low literacy. Speak, we will ask and you answer.",
                  child: Material(
                    color: AppTheme.saffronOrange,
                    borderRadius: BorderRadius.circular(24),
                    elevation: currentProfile.mode == AppMode.voice ? 6 : 2,
                    child: InkWell(
                      key: const Key('mode_voice_card'),
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _chooseMode(AppMode.voice),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: currentProfile.mode == AppMode.voice
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    l10n.translate('mode_voice_badge'),
                                    style: const TextStyle(
                                      color: AppTheme.saffronOrange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.25),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.mic_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.translate('mode_voice_title'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.translate('mode_voice_subtitle'),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Start with Voice",
                                      style: TextStyle(
                                        color: AppTheme.saffronOrange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, color: AppTheme.saffronOrange, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // CARD 2: Text Mode (Navy, Green border, For those who can read and type)
              Expanded(
                child: Semantics(
                  button: true,
                  label: "Text Mode. For those who can read and type. Type your details in a familiar form.",
                  child: Material(
                    color: AppTheme.deepNavy,
                    borderRadius: BorderRadius.circular(24),
                    elevation: currentProfile.mode == AppMode.text ? 6 : 2,
                    child: InkWell(
                      key: const Key('mode_text_card'),
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => _chooseMode(AppMode.text),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppTheme.indiaGreen,
                            width: 3.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.indiaGreen,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    l10n.translate('mode_text_badge'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.translate('mode_text_title'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l10n.translate('mode_text_subtitle'),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.indiaGreen,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Start with Text",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
