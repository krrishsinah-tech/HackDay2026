import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';

class OutputLanguageScreen extends ConsumerStatefulWidget {
  const OutputLanguageScreen({super.key});

  @override
  ConsumerState<OutputLanguageScreen> createState() => _OutputLanguageScreenState();
}

class _OutputLanguageScreenState extends ConsumerState<OutputLanguageScreen> {
  String _selectedLang = 'hi';

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _selectedLang = profile.languageCode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bhashini = ref.read(bhashiniServiceProvider);
      bhashini.speak(
        "आप अपनी योजनाओं का सरल सारांश किस भाषा में चाहते हैं?",
        languageCode: _selectedLang,
        speed: 0.78,
      );
    });
  }

  void _proceedToGist() async {
    await ref.read(profileRepositoryProvider).updateAnswer('output_language', _selectedLang);
    if (!mounted) return;
    context.push('/gist');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languages = AppLocalizations.supportedLanguages;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text("Output Language / भाषा"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.deepNavy.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppTheme.saffronOrange, size: 36),
                    const SizedBox(height: 10),
                    Text(
                      l10n.translate('choose_gist_language'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                            color: AppTheme.deepNavy,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Our AI will rewrite all government rules into simple, clear words in this language.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Language Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = _selectedLang == lang.code;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() => _selectedLang = lang.code);
                        final bhashini = ref.read(bhashiniServiceProvider);
                        bhashini.speak(lang.nativeName, languageCode: lang.code, speed: 0.8);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.saffronOrange : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppTheme.saffronOrange : AppTheme.dividerColor,
                            width: isSelected ? 2.5 : 1.2,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppTheme.saffronOrange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              lang.nativeName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppTheme.deepNavy,
                              ),
                            ),
                            Text(
                              lang.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected ? Colors.white.withOpacity(0.9) : AppTheme.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // Proceed Button
              ElevatedButton.icon(
                onPressed: _proceedToGist,
                icon: const Icon(Icons.psychology_rounded, size: 24),
                label: const Text(
                  "Generate AI Scheme Gist ➔",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
