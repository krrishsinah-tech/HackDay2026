import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/scheme.dart';
import '../../providers/app_providers.dart';

class SchemeDetailScreen extends ConsumerStatefulWidget {
  final String schemeId;

  const SchemeDetailScreen({super.key, required this.schemeId});

  @override
  ConsumerState<SchemeDetailScreen> createState() => _SchemeDetailScreenState();
}

class _SchemeDetailScreenState extends ConsumerState<SchemeDetailScreen> {
  bool _isOfficialTextExpanded = false;
  bool _isSpeaking = false;
  bool _isSavedForLater = false;
  String? _activeLanguageCode;
  Scheme? _scheme;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScheme();
  }

  void _loadScheme() async {
    final repo = ref.read(schemeRepositoryProvider);
    final scheme = await repo.getSchemeById(widget.schemeId);
    final profile = ref.read(userProfileProvider);
    if (mounted) {
      setState(() {
        _scheme = scheme;
        _activeLanguageCode = profile.languageCode;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleListen() async {
    if (_scheme == null) return;
    final bhashini = ref.read(bhashiniServiceProvider);

    if (_isSpeaking) {
      await bhashini.stop();
      setState(() => _isSpeaking = false);
    } else {
      setState(() => _isSpeaking = true);
      final textToRead = "${_scheme!.name}. ${_scheme!.simplifiedText}. Benefit: ${_scheme!.benefitDescription}.";
      await bhashini.speak(
        textToRead,
        languageCode: _activeLanguageCode ?? 'en',
      );
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
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

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.saffronOrange)),
      );
    }

    if (_scheme == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Scheme Not Found")),
        body: const Center(child: Text("Requested government scheme could not be found.")),
      );
    }

    final scheme = _scheme!;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(scheme.name),
        actions: [
          IconButton(
            icon: Icon(
              _isSavedForLater ? Icons.bookmark : Icons.bookmark_border,
              color: _isSavedForLater ? AppTheme.saffronOrange : AppTheme.cream,
            ),
            tooltip: l10n.translate('save_for_later'),
            onPressed: () {
              setState(() {
                _isSavedForLater = !_isSavedForLater;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isSavedForLater
                      ? "Saved! Deadline reminder scheduled for ${scheme.deadline}."
                      : "Removed from saved schemes."),
                  backgroundColor: AppTheme.deepNavy,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: "Share",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Link copied to clipboard")),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Ministry & Status Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.saffronOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            scheme.stateOrCentral,
                            style: const TextStyle(color: AppTheme.saffronOrange, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            scheme.ministry,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text(
                      scheme.name,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: 24,
                            color: AppTheme.deepNavy,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Language Quick Switching Chip Row
                    Container(
                      height: 44,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          {'code': 'en', 'label': 'English'},
                          {'code': 'hi', 'label': 'हिन्दी'},
                          {'code': 'mr', 'label': 'मराठी'},
                          {'code': 'bn', 'label': 'বাংলা'},
                          {'code': 'ta', 'label': 'தமிழ்'},
                          {'code': 'te', 'label': 'తెలుగు'},
                          {'code': 'ur', 'label': 'اردو (RTL)'},
                        ].map((lang) {
                          final isSelected = _activeLanguageCode == lang['code'];
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(lang['label']!),
                              selected: isSelected,
                              selectedColor: AppTheme.saffronOrange,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppTheme.deepNavy,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _activeLanguageCode = lang['code']);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Big Orange Listen Button
                    ElevatedButton.icon(
                      onPressed: _toggleListen,
                      icon: Icon(
                        _isSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                        size: 30,
                      ),
                      label: Text(
                        _isSpeaking ? l10n.translate('stop_listening') : l10n.translate('listen'),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

                    const SizedBox(height: 20),

                    // STEP 7 PIPELINE DISPLAY:
                    // 1. Prominent Plain-Words Simplified Explanation (shown first and most prominently)
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: AppTheme.indiaGreen, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.auto_awesome, color: AppTheme.indiaGreen, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.translate('plain_words_label'),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.indiaGreen,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              scheme.simplifiedText,
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
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.currency_rupee, color: AppTheme.indiaGreen, size: 22),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      scheme.benefitDescription,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 2. Official Text (collapsed in dashed box)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.mutedText.withOpacity(0.5),
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: _isOfficialTextExpanded,
                        onExpansionChanged: (val) => setState(() => _isOfficialTextExpanded = val),
                        leading: const Icon(Icons.gavel_rounded, color: AppTheme.midNavy),
                        title: Text(
                          l10n.translate('official_text_label'),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.midNavy),
                        ),
                        subtitle: const Text("Tap to expand legal government notification", style: TextStyle(fontSize: 12)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                            child: Text(
                              scheme.officialText,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: AppTheme.mutedText,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // STEP 8: DECIDE (Four Actions)
                    Text(
                      "Next Actions",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),

                    // Action 1: Apply Now (Starts Help Desk & Document checklist)
                    ElevatedButton.icon(
                      onPressed: () => context.push('/apply/${scheme.id}'),
                      icon: const Icon(Icons.assignment_turned_in_rounded),
                      label: Text(l10n.translate('apply_now')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.saffronOrange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Action 2: Compare Side by Side
                    OutlinedButton.icon(
                      onPressed: () => context.push('/compare?schemeId=${scheme.id}'),
                      icon: const Icon(Icons.compare_arrows_rounded),
                      label: Text(l10n.translate('compare')),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: AppTheme.midNavy, width: 2),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Action 3: Ask the Help Desk
                    OutlinedButton.icon(
                      onPressed: () {
                        final bhashini = ref.read(bhashiniServiceProvider);
                        bhashini.speak(
                          "Connecting you to the Umeed Voice Help Desk for ${scheme.name}. A civic helper is ready.",
                          languageCode: _activeLanguageCode ?? 'en',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Connecting to Voice Help Desk helper..."),
                            backgroundColor: AppTheme.deepNavy,
                          ),
                        );
                      },
                      icon: const Icon(Icons.headset_mic_rounded, color: AppTheme.saffronOrange),
                      label: Text(
                        l10n.translate('ask_help_desk'),
                        style: const TextStyle(color: AppTheme.deepNavy),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: AppTheme.saffronOrange, width: 2),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
