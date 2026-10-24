import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/models/help_desk_submission.dart';
import '../../domain/models/user_profile.dart';

class HelpDeskRepository {
  final List<HelpDeskSubmission> _submissions = [];
  final _uuid = const Uuid();
  static const int busyThreshold = 3;

  final _completionStreamController = StreamController<HelpDeskSubmission>.broadcast();
  Stream<HelpDeskSubmission> get onSubmissionCompleted => _completionStreamController.stream;

  HelpDeskRepository() {
    // Seed initial mock submissions for the Help Desk Console demo
    _submissions.add(HelpDeskSubmission(
      id: "ticket-001",
      profile: const UserProfile(
        name: "Rameshwar Patil",
        age: 48,
        gender: "man",
        state: "Maharashtra",
        area: "rural",
        occupation: "farmer",
        annualIncome: 120000,
        primaryNeeds: ["farming", "money"],
      ),
      audioRecordings: {
        "q_name": "mock://audio/rameshwar_name.wav",
        "q_occupation": "mock://audio/rameshwar_occ.wav",
      },
      transcripts: {
        "q_name": "Rameshwar Patil, from Satara district.",
        "q_occupation": "I do farming on 2 acres of land.",
      },
      queuePosition: 1,
      status: SubmissionStatus.reviewing,
      assignedHelperName: "Ananya Sharma (Helper #4)",
      submittedAt: DateTime.now().subtract(const Duration(minutes: 25)),
    ));

    _submissions.add(HelpDeskSubmission(
      id: "ticket-002",
      profile: const UserProfile(
        name: "Sunita Devi",
        age: 32,
        gender: "woman",
        state: "Bihar",
        area: "rural",
        occupation: "homemaker",
        annualIncome: 90000,
        primaryNeeds: ["health", "housing"],
      ),
      audioRecordings: {
        "q_name": "mock://audio/sunita_name.wav",
        "q_need": "mock://audio/sunita_need.wav",
      },
      transcripts: {
        "q_name": "Mera naam Sunita Devi hai.",
        "q_need": "Ghar banane aur bacchon ke ilaj ke liye madad chahiye.",
      },
      queuePosition: 2,
      status: SubmissionStatus.pending,
      submittedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ));
  }

  Future<HelpDeskSubmission> submitVoiceIntake({
    required UserProfile profile,
    required Map<String, String> recordings,
    required Map<String, String> transcripts,
  }) async {
    final pendingCount = _submissions.where((s) => s.status != SubmissionStatus.completed).length;
    final isBusy = pendingCount >= busyThreshold;

    final submission = HelpDeskSubmission(
      id: "ticket-${_uuid.v4().substring(0, 6)}",
      profile: profile,
      audioRecordings: recordings,
      transcripts: transcripts,
      queuePosition: pendingCount + 1,
      status: SubmissionStatus.pending,
      scheduledSlot: isBusy ? "Tomorrow, 10:30 AM" : null,
      assignedHelperName: isBusy ? null : "Civic Helper Desk",
      submittedAt: DateTime.now(),
    );

    _submissions.add(submission);
    return submission;
  }

  List<HelpDeskSubmission> getAllSubmissions() {
    return List.unmodifiable(_submissions);
  }

  HelpDeskSubmission? getSubmissionById(String id) {
    try {
      return _submissions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateSubmission(HelpDeskSubmission updated) async {
    final index = _submissions.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      _submissions[index] = updated;
      if (updated.status == SubmissionStatus.completed) {
        _completionStreamController.add(updated);
      }
    }
  }

  void dispose() {
    _completionStreamController.close();
  }
}
