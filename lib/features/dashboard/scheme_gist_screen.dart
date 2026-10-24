import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/scheme.dart';
import '../../providers/app_providers.dart';
import '../../services/ai_gist_service.dart';

class SchemeGistScreen extends ConsumerStatefulWidget {
  const SchemeGistScreen({super.key});

  @override
  ConsumerState<SchemeGistScreen> createState() => _SchemeGistScreenState();
}

class _SchemeGistScreenState extends ConsumerState<SchemeGistScreen> {
  final AiGistService _aiGistService = AiGistService();
  AiSchemeGist? _gist;
  Scheme? _topScheme;
  bool _isLoading = true;
  bool _isSpeakingGist = false;

  final TextEditingController _queryController = TextEditingController();
  String? _helpDeskAnswer;
  bool _isQuerying = false;

  @override
  void initState() {
    super.initState();
    _generateGist();
  }

  void _generateGist() async {
    final schemes = await ref.read(schemeRepositoryProvider).getSchemes();
    final profile = ref.read(userProfileProvider);
    final outputLang = profile.outputLanguage ?? profile.languageCode;

    // Pick top scheme matching user sector or first scheme
    Scheme selected = schemes.first;
    if (profile.sectorFocus != null) {
      final query = profile.sectorFocus!.toLowerCase();
      selected = schemes.firstWhere(
        (s) => s.eligibilityRules.needs.any((n) => query.contains(n.toLowerCase())) ||
            s.name.toLowerCase().contains(query),
        orElse: () => schemes.first,
      );
    }

    final gist = await _aiGistService.generatePlainLanguageGist(
      scheme: selected,
      profile: profile,
      outputLanguage: outputLang,
    );

    if (mounted) {
      setState(() {
        _topScheme = selected;
        _gist = gist;
        _isLoading = false;
      });
      _playGistAudio();
    }
  }

  Future<void> _playGistAudio() async {
    if (_gist == null) return;
    final bhashini = ref.read(bhashiniServiceProvider);
    final textToSpeak = "${_gist!.simpleTitle}. ${_gist!.bulletGist.join('. ')}. ${_gist!.benefitSummary}.";

    setState(() => _isSpeakingGist = true);
    await bhashini.speak(textToSpeak, languageCode: _gist!.languageCode, speed: 0.78);

    if (mounted) {
      setState(() => _isSpeakingGist = false);
    }
  }

  Future<void> _stopGistAudio() async {
    final bhashini = ref.read(bhashiniServiceProvider);
    await bhashini.stop();
    if (mounted) {
      setState(() => _isSpeakingGist = false);
    }
  }

  void _submitHelpDeskQuery() async {
    if (_queryController.text.trim().isEmpty || _topScheme == null) return;

    setState(() => _isQuerying = true);
    final profile = ref.read(userProfileProvider);
    final outputLang = profile.outputLanguage ?? profile.languageCode;

    final answer = await _aiGistService.queryHelpDesk(
      schemeId: _topScheme!.id,
      query: _queryController.text,
      languageCode: outputLang,
    );

    if (mounted) {
      setState(() {
        _helpDeskAnswer = answer;
        _isQuerying = false;
      });
      // Speak helper response
      final bhashini = ref.read(bhashiniServiceProvider);
      bhashini.speak(answer, languageCode: outputLang, speed: 0.78);
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    ref.read(bhashiniServiceProvider).stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.cream,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppTheme.saffronOrange),
              const SizedBox(height: 16),
              Text(
                "Converting schemes into simple plain words with AI...",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    final gist = _gist!;
    final scheme = _topScheme!;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(l10n.translate('ai_gist_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            tooltip: "View Full Dashboard",
            onPressed: () => context.push('/dashboard'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scheme Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.deepNavy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.saffronOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Top Matched Scheme",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        Text(
                          "Lang: ${gist.languageCode.toUpperCase()}",
                          style: const TextStyle(color: AppTheme.cream, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      scheme.name,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scheme.ministry,
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // PROMINENT "HEAR IT OUT" BUTTON (USER REQUIREMENT)
              ElevatedButton.icon(
                onPressed: _isSpeakingGist ? _stopGistAudio : _playGistAudio,
                icon: Icon(
                  _isSpeakingGist ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                  size: 28,
                ),
                label: Text(
                  _isSpeakingGist ? "आवाज़ रोकें (Stop Listening)" : l10n.translate('hear_it_out'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 4,
                ),
              ),

              const SizedBox(height: 18),

              // AI Plain-Language Gist Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
                          Expanded(
                            child: Text(
                              gist.simpleTitle,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.indiaGreen),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Bullet points in simple words
                      ...gist.bulletGist.map((point) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("👉 ", style: TextStyle(fontSize: 16)),
                              Expanded(
                                child: Text(
                                  point,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: AppTheme.bodyText,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const Divider(height: 24),

                      // Benefit Highlight Box
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cream,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.dividerColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.currency_rupee, color: AppTheme.indiaGreen, size: 22),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                gist.benefitSummary,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // INTERACTIVE HELP DESK QUERY CARD (USER REQUIREMENT)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppTheme.saffronOrange, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.support_agent_rounded, color: AppTheme.saffronOrange, size: 26),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.translate('query_help_desk'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.deepNavy),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _queryController,
                        decoration: InputDecoration(
                          hintText: l10n.translate('type_query_hint'),
                          filled: true,
                          fillColor: AppTheme.cream,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppTheme.dividerColor),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.mic, color: AppTheme.saffronOrange),
                            tooltip: "Speak Query",
                            onPressed: () {
                              _queryController.text = "क्या बिना ज़मीन के पट्टे के भी लाभ मिलेगा?";
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: _isQuerying ? null : _submitHelpDeskQuery,
                        icon: _isQuerying
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.send_rounded, size: 18),
                        label: const Text("Ask Help Desk (हेल्प डेस्क से पूछें)"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.midNavy,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),

                      // Helper Response Box
                      if (_helpDeskAnswer != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppTheme.indiaGreen.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppTheme.indiaGreen.withOpacity(0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.verified, color: AppTheme.indiaGreen, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    l10n.translate('help_desk_response'),
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.indiaGreen),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _helpDeskAnswer!,
                                style: const TextStyle(fontSize: 14, color: AppTheme.bodyText, height: 1.45),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons: Proceed to Dashboard or Apply Now
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/dashboard'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: AppTheme.deepNavy, width: 2),
                      ),
                      child: const Text("All Ranked Schemes", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.push('/apply/${scheme.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.saffronOrange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                      ),
                      child: const Text("Apply Now ➔", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
