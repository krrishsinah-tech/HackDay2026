import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/help_desk_submission.dart';
import '../../providers/app_providers.dart';

class HelpDeskConsoleScreen extends ConsumerStatefulWidget {
  const HelpDeskConsoleScreen({super.key});

  @override
  ConsumerState<HelpDeskConsoleScreen> createState() => _HelpDeskConsoleScreenState();
}

class _HelpDeskConsoleScreenState extends ConsumerState<HelpDeskConsoleScreen> {
  HelpDeskSubmission? _selectedSubmission;
  bool _isPlayingAudio = false;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _ageCtrl = TextEditingController();
  final TextEditingController _occCtrl = TextEditingController();
  final TextEditingController _incomeCtrl = TextEditingController();

  void _selectSubmission(HelpDeskSubmission sub) {
    setState(() {
      _selectedSubmission = sub;
      _nameCtrl.text = sub.profile.name ?? '';
      _ageCtrl.text = sub.profile.age?.toString() ?? '';
      _occCtrl.text = sub.profile.occupation ?? '';
      _incomeCtrl.text = sub.profile.annualIncome?.toString() ?? '';
    });
  }

  Future<void> _playMockRecording(String audioUri) async {
    final bhashini = ref.read(bhashiniServiceProvider);
    setState(() => _isPlayingAudio = true);

    await bhashini.speak("Playing voice recording for verification: ${_nameCtrl.text}", languageCode: 'en');

    if (mounted) {
      setState(() => _isPlayingAudio = false);
    }
  }

  void _completeReview() async {
    if (_selectedSubmission == null) return;

    final updatedProfile = _selectedSubmission!.profile.copyWith(
      name: _nameCtrl.text.isNotEmpty ? _nameCtrl.text : _selectedSubmission!.profile.name,
      age: int.tryParse(_ageCtrl.text) ?? _selectedSubmission!.profile.age,
      occupation: _occCtrl.text.isNotEmpty ? _occCtrl.text : _selectedSubmission!.profile.occupation,
      annualIncome: int.tryParse(_incomeCtrl.text) ?? _selectedSubmission!.profile.annualIncome,
    );

    final updatedSub = _selectedSubmission!.copyWith(
      profile: updatedProfile,
      status: SubmissionStatus.completed,
      helperNotes: "Verified by civic helper desk on ${DateTime.now()}",
    );

    final helpDeskRepo = ref.read(helpDeskRepositoryProvider);
    await helpDeskRepo.updateSubmission(updatedSub);
    await ref.read(profileRepositoryProvider).saveProfile(updatedProfile);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile verified! Push Notification sent: 'Your profile is ready.'"),
        backgroundColor: AppTheme.indiaGreen,
      ),
    );

    setState(() {
      _selectedSubmission = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final helpDeskRepo = ref.watch(helpDeskRepositoryProvider);
    final submissions = helpDeskRepo.getAllSubmissions();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings_rounded, color: AppTheme.saffronOrange),
            SizedBox(width: 10),
            Text("Umeed Help Desk · Civic Helper Web Console"),
          ],
        ),
        backgroundColor: AppTheme.deepNavy,
      ),
      body: Row(
        children: [
          // Left Sidebar: Queue of submissions
          Container(
            width: 380,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: AppTheme.dividerColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Incoming Queue (${submissions.length})",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.saffronOrange.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text("Live Queue", style: TextStyle(color: AppTheme.saffronOrange, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    itemCount: submissions.length,
                    separatorBuilder: (ctx, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final sub = submissions[index];
                      final isSelected = _selectedSubmission?.id == sub.id;
                      final isCompleted = sub.status == SubmissionStatus.completed;

                      return ListTile(
                        selected: isSelected,
                        selectedTileColor: AppTheme.saffronOrange.withOpacity(0.1),
                        title: Text(
                          sub.profile.name ?? "Anonymous Voice User",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Ticket: ${sub.id} · Queue #${sub.queuePosition}",
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.indiaGreen.withOpacity(0.15)
                                : AppTheme.saffronOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isCompleted ? "Completed" : "Pending",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isCompleted ? AppTheme.indiaGreen : AppTheme.saffronOrange,
                            ),
                          ),
                        ),
                        onTap: () => _selectSubmission(sub),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Right Workspace: Play audio, inspect transcript, fill profile
          Expanded(
            child: _selectedSubmission == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app_outlined, size: 48, color: AppTheme.mutedText),
                        SizedBox(height: 12),
                        Text(
                          "Select a voice submission from the left queue to review",
                          style: TextStyle(fontSize: 16, color: AppTheme.mutedText),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reviewing Ticket: ${_selectedSubmission!.id}",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Submitted: ${_selectedSubmission!.submittedAt.toLocal()}",
                                  style: const TextStyle(color: AppTheme.mutedText),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: _completeReview,
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text("Approve & Dispatch Dashboard"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.indiaGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Voice Transcripts and Audio Player Panel
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.mic, color: AppTheme.saffronOrange),
                                    SizedBox(width: 8),
                                    Text(
                                      "Recorded Voice Answers & Transcripts",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ..._selectedSubmission!.transcripts.entries.map((entry) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.cream,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            _isPlayingAudio ? Icons.graphic_eq : Icons.play_circle_fill,
                                            color: AppTheme.saffronOrange,
                                            size: 32,
                                          ),
                                          tooltip: "Play Audio Take",
                                          onPressed: () => _playMockRecording(entry.value),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.midNavy)),
                                              const SizedBox(height: 2),
                                              Text(entry.value, style: const TextStyle(fontSize: 15)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Profile Correction Form
                        Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Verified Profile Attributes (Helper Form)",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _nameCtrl,
                                        decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextField(
                                        controller: _ageCtrl,
                                        decoration: const InputDecoration(labelText: "Age", border: OutlineInputBorder()),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _occCtrl,
                                        decoration: const InputDecoration(labelText: "Occupation (e.g. farmer, laborer)", border: OutlineInputBorder()),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: TextField(
                                        controller: _incomeCtrl,
                                        decoration: const InputDecoration(labelText: "Annual Income (₹)", border: OutlineInputBorder()),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
