import 'user_profile.dart';

enum SubmissionStatus { pending, reviewing, completed }

class HelpDeskSubmission {
  final String id;
  final UserProfile profile;
  final Map<String, String> audioRecordings; // questionKey -> recording uri
  final Map<String, String> transcripts; // questionKey -> text transcript
  final int queuePosition;
  final SubmissionStatus status;
  final String? scheduledSlot;
  final String? assignedHelperName;
  final DateTime submittedAt;
  final String? helperNotes;

  const HelpDeskSubmission({
    required this.id,
    required this.profile,
    required this.audioRecordings,
    required this.transcripts,
    required this.queuePosition,
    this.status = SubmissionStatus.pending,
    this.scheduledSlot,
    this.assignedHelperName,
    required this.submittedAt,
    this.helperNotes,
  });

  HelpDeskSubmission copyWith({
    String? id,
    UserProfile? profile,
    Map<String, String>? audioRecordings,
    Map<String, String>? transcripts,
    int? queuePosition,
    SubmissionStatus? status,
    String? scheduledSlot,
    String? assignedHelperName,
    DateTime? submittedAt,
    String? helperNotes,
  }) {
    return HelpDeskSubmission(
      id: id ?? this.id,
      profile: profile ?? this.profile,
      audioRecordings: audioRecordings ?? this.audioRecordings,
      transcripts: transcripts ?? this.transcripts,
      queuePosition: queuePosition ?? this.queuePosition,
      status: status ?? this.status,
      scheduledSlot: scheduledSlot ?? this.scheduledSlot,
      assignedHelperName: assignedHelperName ?? this.assignedHelperName,
      submittedAt: submittedAt ?? this.submittedAt,
      helperNotes: helperNotes ?? this.helperNotes,
    );
  }
}
