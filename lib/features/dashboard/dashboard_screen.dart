import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/user_profile.dart';
import '../../providers/app_providers.dart';
import '../../services/ranking_service.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _selectedCategoryFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(userProfileProvider);
    final rankedSchemes = ref.watch(rankedSchemesProvider);
    final schemeRepo = ref.watch(schemeRepositoryProvider);
    final isVoiceMode = profile.mode == AppMode.voice;

    // Filter logic
    final filteredSchemes = rankedSchemes.where((ranked) {
      if (_selectedCategoryFilter == 'All') return true;
      final query = _selectedCategoryFilter.toLowerCase();
      final scheme = ranked.scheme;
      return scheme.ministry.toLowerCase().contains(query) ||
          scheme.eligibilityRules.needs.any((n) => n.toLowerCase() == query) ||
          scheme.eligibilityRules.occupations.any((o) => o.toLowerCase() == query);
    }).toList();

    final topThree = filteredSchemes.take(3).toList();
    final otherSchemes = filteredSchemes.skip(3).toList();

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(l10n.translate('dashboard_title')),
        automaticallyImplyLeading: false,
        actions: [
          // Persistent Mode Switch Button
          IconButton(
            icon: Icon(
              isVoiceMode ? Icons.mic : Icons.chat_bubble_outline,
              color: isVoiceMode ? AppTheme.saffronOrange : AppTheme.cream,
            ),
            tooltip: isVoiceMode ? l10n.translate('switch_to_text') : l10n.translate('switch_to_voice'),
            onPressed: () {
              final newMode = isVoiceMode ? AppMode.text : AppMode.voice;
              ref.read(userProfileProvider.notifier).setMode(newMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.translate('select_language'),
            onPressed: () => context.push('/language'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.translate('settings'),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // User Greeting & Mode Notice Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: AppTheme.deepNavy,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isVoiceMode ? AppTheme.saffronOrange : AppTheme.indiaGreen,
                    child: Icon(
                      isVoiceMode ? Icons.mic : Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name != null && profile.name!.isNotEmpty
                              ? "Namaste, ${profile.name}"
                              : "Namaste, Citizen",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isVoiceMode
                              ? "Voice Mode Active · Helper Verified"
                              : "Instant Scheme Match Active",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.push('/intake'),
                    icon: const Icon(Icons.edit, size: 14, color: AppTheme.cream),
                    label: const Text("Edit", style: TextStyle(color: AppTheme.cream, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.cream),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      minimumSize: const Size(64, 34),
                    ),
                  ),
                ],
              ),
            ),

            // Category Filter Chips
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  'All',
                  'Farming',
                  'Health',
                  'Housing',
                  'Education',
                  'Jobs',
                  'Money',
                ].map((category) {
                  final isSelected = _selectedCategoryFilter == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: AppTheme.saffronOrange,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.deepNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategoryFilter = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Ranked List
            Expanded(
              child: rankedSchemes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(color: AppTheme.saffronOrange),
                          const SizedBox(height: 16),
                          Text("Matching your profile against 16+ government schemes...",
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // Section 1: TOP THREE RANKED CARDS
                        ...topThree.map((ranked) => _buildRankedCard(context, ranked, l10n)).toList(),

                        // Section 2: OTHER RELEVANT SCHEMES
                        if (otherSchemes.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              l10n.translate('other_schemes'),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...otherSchemes.map((ranked) => _buildOtherCard(context, ranked, l10n)).toList(),
                        ],

                        const SizedBox(height: 30),

                        // Section 3: Data Freshness Footer
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.dividerColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.sync_rounded, size: 16, color: AppTheme.indiaGreen),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.translate('data_last_checked'),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankedCard(BuildContext context, RankedScheme ranked, AppLocalizations l10n) {
    final scheme = ranked.scheme;
    Color badgeColor;
    String badgeText;
    String badgeSubtitle;

    switch (ranked.tier) {
      case MatchTier.best:
        badgeColor = AppTheme.saffronOrange;
        badgeText = l10n.translate('rank_1_badge');
        badgeSubtitle = "Highest benefit · Clearly qualifies";
        break;
      case MatchTier.better:
        badgeColor = AppTheme.indiaGreen;
        badgeText = l10n.translate('rank_2_badge');
        badgeSubtitle = "Strong fit · 1 document to arrange";
        break;
      case MatchTier.good:
        badgeColor = AppTheme.rankGood;
        badgeText = l10n.translate('rank_3_badge');
        badgeSubtitle = "Possible fit · Helper check recommended";
        break;
      default:
        badgeColor = AppTheme.midNavy;
        badgeText = "Relevant Match";
        badgeSubtitle = "";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: badgeColor, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/scheme/${scheme.id}'),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    scheme.stateOrCentral,
                    style: const TextStyle(
                      color: AppTheme.mutedText,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Scheme Name
              Text(
                scheme.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.deepNavy,
                      fontSize: 20,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                scheme.ministry,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: 12),

              // Benefit Amount Highlight Box
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
                        scheme.benefitDescription,
                        style: const TextStyle(
                          color: AppTheme.bodyText,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Why You Qualify (Plain Words Rationale)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, color: AppTheme.indiaGreen, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${l10n.translate('why_qualify')}${ranked.qualificationReason}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.bodyText,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // View Details Action
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Understand & Apply",
                      style: TextStyle(
                        color: badgeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: badgeColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherCard(BuildContext context, RankedScheme ranked, AppLocalizations l10n) {
    final scheme = ranked.scheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.dividerColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          scheme.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Benefit: ${scheme.benefitDescription}", maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(ranked.qualificationReason, style: const TextStyle(color: AppTheme.indiaGreen, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTheme.mutedText),
        onTap: () => context.push('/scheme/${scheme.id}'),
      ),
    );
  }
}
