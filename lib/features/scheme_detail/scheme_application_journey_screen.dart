import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/scheme.dart';
import '../../providers/app_providers.dart';

class SchemeApplicationJourneyScreen extends ConsumerStatefulWidget {
  final String schemeId;

  const SchemeApplicationJourneyScreen({super.key, required this.schemeId});

  @override
  ConsumerState<SchemeApplicationJourneyScreen> createState() => _SchemeApplicationJourneyScreenState();
}

class _SchemeApplicationJourneyScreenState extends ConsumerState<SchemeApplicationJourneyScreen> {
  Scheme? _scheme;
  bool _isLoading = true;
  bool _isHelpDeskUnlocked = false; // Documents locked initially
  int _currentStep = 0; // 0: Prepare, 1: Verify, 2: Apply, 3: Track

  // Track checked documents
  final Set<String> _checkedDocs = {};

  @override
  void initState() {
    super.initState();
    _loadScheme();
  }

  void _loadScheme() async {
    final repo = ref.read(schemeRepositoryProvider);
    final scheme = await repo.getSchemeById(widget.schemeId);
    if (mounted) {
      setState(() {
        _scheme = scheme;
        _isLoading = false;
      });
    }
  }

  void _unlockDocumentsViaHelper() {
    final bhashini = ref.read(bhashiniServiceProvider);
    final profile = ref.read(userProfileProvider);
    bhashini.speak(
      "Connecting to a human helper. Your document checklist is now unlocked.",
      languageCode: profile.languageCode,
    );

    setState(() {
      _isHelpDeskUnlocked = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Connected with Help Desk helper. Document checklist unlocked!"),
        backgroundColor: AppTheme.indiaGreen,
      ),
    );
  }

  void _skipHelpDeskToDocuments() {
    setState(() {
      _isHelpDeskUnlocked = true;
    });
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
      return const Scaffold(body: Center(child: Text("Scheme not found")));
    }

    final scheme = _scheme!;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text("Apply · ${scheme.name}"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // STEP 9 GATE: Help Desk First Gate
              if (!_isHelpDeskUnlocked)
                _buildHelpDeskLockGate(context, l10n, scheme)
              else
                _buildFourStageJourney(context, l10n, scheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpDeskLockGate(BuildContext context, AppLocalizations l10n, Scheme scheme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(color: AppTheme.saffronOrange, width: 2.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.saffronOrange.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_clock_rounded,
                size: 38,
                color: AppTheme.saffronOrange,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Help Desk Consultation First",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.translate('docs_locked_notice'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.bodyText,
                    height: 1.45,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Button 1: Connect with human helper (Orange)
            ElevatedButton.icon(
              onPressed: _unlockDocumentsViaHelper,
              icon: const Icon(Icons.support_agent_rounded, size: 24),
              label: Text(l10n.translate('talk_to_helper')),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.saffronOrange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 14),

            // Button 2: Explicitly Skip Help Desk
            TextButton(
              onPressed: _skipHelpDeskToDocuments,
              child: Text(
                l10n.translate('skip_help_desk'),
                style: const TextStyle(
                  color: AppTheme.midNavy,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFourStageJourney(BuildContext context, AppLocalizations l10n, Scheme scheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Unlocked Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.indiaGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.indiaGreen.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lock_open_rounded, color: AppTheme.indiaGreen, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Documents Unlocked · 4-Stage Application Journey",
                  style: TextStyle(color: AppTheme.indiaGreen, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 4-Stage Stepper: Prepare, Verify, Apply, Track
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.saffronOrange,
                ),
          ),
          child: Stepper(
            physics: const NeverScrollableScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            onStepContinue: () {
              if (_currentStep < 3) {
                setState(() => _currentStep++);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
            steps: [
              // STAGE 1: PREPARE
              Step(
                title: Text(l10n.translate('stepper_prepare'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: const Text("Personal checklist of required documents"),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...scheme.documentsRequired.map((doc) {
                      final isChecked = _checkedDocs.contains(doc.name);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: AppTheme.dividerColor),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                activeColor: AppTheme.indiaGreen,
                                value: isChecked,
                                title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                subtitle: Text(doc.plainReason, style: const TextStyle(fontSize: 13, color: AppTheme.bodyText)),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      _checkedDocs.add(doc.name);
                                    } else {
                                      _checkedDocs.remove(doc.name);
                                    }
                                  });
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.cream,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.camera_alt_outlined, size: 16, color: AppTheme.midNavy),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        "Photo Hint: ${doc.photoHint}",
                                        style: const TextStyle(fontSize: 12, color: AppTheme.mutedText),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              // STAGE 2: VERIFY
              Step(
                title: Text(l10n.translate('stepper_verify'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: const Text("Civic helper pre-application review"),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                content: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.verified_user_rounded, color: AppTheme.indiaGreen),
                          SizedBox(width: 8),
                          Text("Pre-Verification Checklist", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text("• Name on Aadhaar matches bank passbook exactly\n• Active mobile number linked to Aadhaar\n• Documents valid within current financial year"),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Pre-check confirmed by civic desk! Ready to apply.")),
                          );
                        },
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text("Confirm Verification"),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.deepNavy, foregroundColor: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              // STAGE 3: APPLY (Guided handoff to official portal or office)
              Step(
                title: Text(l10n.translate('stepper_apply'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: const Text("Official portal / physical office handoff"),
                isActive: _currentStep >= 2,
                state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                content: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // No Proxy notice (CRITICAL SPECIFICATION)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppTheme.saffronOrange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          l10n.translate('no_proxy_notice'),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.deepNavy),
                        ),
                      ),
                      Text("Official Portal Link:", style: Theme.of(context).textTheme.bodySmall),
                      SelectableText(
                        scheme.applyUrl,
                        style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                      const SizedBox(height: 12),
                      Text(l10n.translate('physical_office_address'), style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        "${scheme.physicalOffice}\nTiming: Monday - Friday, 10:00 AM - 5:00 PM",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              // STAGE 4: TRACK
              Step(
                title: Text(l10n.translate('stepper_track'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: const Text("Voice status updates & deadline alerts"),
                isActive: _currentStep >= 3,
                state: StepState.indexed,
                content: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.mic, color: AppTheme.saffronOrange),
                          SizedBox(width: 8),
                          Text("Voice Status Check", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("Say 'Check my status' anytime to hear latest progress and upcoming deadlines."),
                      const SizedBox(height: 10),
                      Text("Next Deadline: ${scheme.deadline}", style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.saffronOrange)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
