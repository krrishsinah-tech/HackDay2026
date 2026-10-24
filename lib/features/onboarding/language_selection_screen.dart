import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String? _currentlyPlayingCode;

  Future<void> _playLanguageSample(LanguageInfo lang) async {
    final bhashini = ref.read(bhashiniServiceProvider);
    setState(() => _currentlyPlayingCode = lang.code);

    final phrase = "${lang.nativeName} (${lang.name})";
    await bhashini.speak(phrase, languageCode: lang.code);

    if (mounted) {
      setState(() => _currentlyPlayingCode = null);
    }
  }

  void _selectLanguage(String code) async {
    await ref.read(userProfileProvider.notifier).setLanguage(code);
    ref.read(currentLocaleProvider.notifier).state = Locale(code);
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.push('/mode');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentProfile = ref.watch(userProfileProvider);
    final languages = AppLocalizations.supportedLanguages;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(l10n.translate('select_language')),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: AppTheme.saffronOrange.withOpacity(0.08),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.saffronOrange, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "22 Scheduled Languages of India + English. Tap to switch instantly.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.deepNavy,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.35,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final isSelected = lang.code == currentProfile.languageCode;
                  final isPlaying = _currentlyPlayingCode == lang.code;

                  return Semantics(
                    button: true,
                    selected: isSelected,
                    label: "${lang.nativeName}, ${lang.name}",
                    child: Material(
                      color: isSelected ? AppTheme.saffronOrange : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      elevation: isSelected ? 4 : 1,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _selectLanguage(lang.code),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.saffronOrange
                                  : (lang.isRtl ? AppTheme.indiaGreen : AppTheme.dividerColor),
                              width: isSelected ? 2.5 : 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (lang.isRtl)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.3)
                                            : AppTheme.indiaGreen.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "RTL",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isSelected ? Colors.white : AppTheme.indiaGreen,
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox.shrink(),
                                  // Hear It Button
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    icon: Icon(
                                      isPlaying ? Icons.graphic_eq : Icons.volume_up,
                                      size: 22,
                                      color: isSelected ? Colors.white : AppTheme.saffronOrange,
                                    ),
                                    tooltip: "${l10n.translate('hear_it')}: ${lang.name}",
                                    onPressed: () => _playLanguageSample(lang),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lang.nativeName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : AppTheme.deepNavy,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    lang.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.9)
                                          : AppTheme.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
