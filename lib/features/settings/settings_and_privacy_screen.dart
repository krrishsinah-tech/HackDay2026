import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';

class SettingsAndPrivacyScreen extends ConsumerWidget {
  const SettingsAndPrivacyScreen({super.key});

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            Text(l10n.translate('delete_my_data')),
          ],
        ),
        content: Text(
          l10n.translate('delete_data_confirm'),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(userProfileProvider.notifier).clearAll();
              if (!ctx.mounted) return;
              Navigator.pop(ctx);
              context.go('/');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("All profile data and cached voice recordings have been permanently deleted."),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Delete Permanently"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Section 1: Privacy by Design
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.security_rounded, color: AppTheme.indiaGreen),
                        SizedBox(width: 8),
                        Text("Privacy & Data Protection", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.timer_outlined, color: AppTheme.midNavy),
                      title: const Text("Audio Retention Policy"),
                      subtitle: const Text("Auto-deletes after 30 days. No biometric OTPs stored."),
                      trailing: Switch(
                        value: true,
                        activeColor: AppTheme.indiaGreen,
                        onChanged: (val) {},
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.language, color: AppTheme.midNavy),
                      title: const Text("Active App Language"),
                      subtitle: Text("Current: ${profile.languageCode.toUpperCase()}"),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      onTap: () => context.push('/language'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section 2: Roadmap Hooks (Stubbed as specified in prompt section 5)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.explore_outlined, color: AppTheme.saffronOrange),
                        SizedBox(width: 8),
                        Text("Roadmap & Access Modes (Stubs)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.people_outline, color: AppTheme.midNavy),
                      title: const Text("Family Mode"),
                      subtitle: const Text("One session checks schemes for every household member"),
                      trailing: const Chip(label: Text("Roadmap", style: TextStyle(fontSize: 11))),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Family Mode hook stubbed: Coming in future release.")),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone_in_talk_outlined, color: AppTheme.midNavy),
                      title: const Text("Phone-Call Access (IVR)"),
                      subtitle: const Text("Toll-free 1800-XXX-XXXX for non-smartphone users"),
                      trailing: const Chip(label: Text("Roadmap", style: TextStyle(fontSize: 11))),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Toll-Free IVR gateway stubbed.")),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.volunteer_activism_outlined, color: AppTheme.midNavy),
                      title: const Text("Community Partner Mode"),
                      subtitle: const Text("Panchayat / CSC 'Help Someone Else' onboarding"),
                      trailing: const Chip(label: Text("Roadmap", style: TextStyle(fontSize: 11))),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Community Partner onboarding mode stubbed.")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section 3: Legal Disclaimer
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.dividerColor),
              ),
              child: Text(
                l10n.translate('disclaimer'),
                style: const TextStyle(fontSize: 13, color: AppTheme.mutedText, height: 1.45),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            // Section 4: Delete My Data Button
            ElevatedButton.icon(
              onPressed: () => _showDeleteConfirmation(context, ref, l10n),
              icon: const Icon(Icons.delete_forever_rounded),
              label: Text(l10n.translate('delete_my_data')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBA1A1A),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
