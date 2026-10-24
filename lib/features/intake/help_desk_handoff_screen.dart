import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/help_desk_submission.dart';
import '../../providers/app_providers.dart';

class HelpDeskHandoffScreen extends ConsumerWidget {
  final HelpDeskSubmission? submission;

  const HelpDeskHandoffScreen({super.key, this.submission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isBusyDay = submission?.scheduledSlot != null;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(l10n.translate('app_name')),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon Header
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isBusyDay
                        ? AppTheme.saffronOrange.withOpacity(0.15)
                        : AppTheme.indiaGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isBusyDay ? Icons.calendar_month_rounded : Icons.support_agent_rounded,
                    size: 54,
                    color: isBusyDay ? AppTheme.saffronOrange : AppTheme.indiaGreen,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                isBusyDay
                    ? l10n.translate('busy_day_title')
                    : l10n.translate('handoff_title'),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              Text(
                isBusyDay
                    ? l10n.translate('busy_day_desc')
                    : l10n.translate('handoff_desc'),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.bodyText,
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Status Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: const BorderSide(color: AppTheme.dividerColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      if (isBusyDay) ...[
                        Row(
                          children: [
                            const Icon(Icons.event_available, color: AppTheme.saffronOrange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.translate('confirmed_slot'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.notifications_active_outlined, color: AppTheme.midNavy),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.translate('reminder_scheduled'),
                                style: const TextStyle(fontSize: 14, color: AppTheme.mutedText),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, color: AppTheme.indiaGreen),
                            const SizedBox(width: 10),
                            Text(
                              "Queue Position: #${submission?.queuePosition ?? 1}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Estimated review time: 10 to 15 minutes. We will notify you once ready.",
                          style: TextStyle(color: AppTheme.mutedText),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Demo Helper Console Link
              OutlinedButton.icon(
                onPressed: () => context.push('/helpdesk'),
                icon: const Icon(Icons.laptop_chromebook),
                label: const Text("Open Helper Web Console (Demo)"),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 12),

              // Direct access to Dashboard for demo & instant testing
              ElevatedButton.icon(
                onPressed: () => context.push('/dashboard'),
                icon: const Icon(Icons.dashboard_rounded),
                label: const Text("View Personalized Dashboard"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.deepNavy,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
