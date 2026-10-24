import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/user_profile.dart';
import '../../providers/app_providers.dart';
import 'question_config.dart';
import 'waveform_widget.dart';

class IntakeScreen extends ConsumerStatefulWidget {
  const IntakeScreen({super.key});

  @override
  ConsumerState<IntakeScreen> createState() => _IntakeScreenState();
}

class _IntakeScreenState extends ConsumerState<IntakeScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  bool _isSpeakingQuestion = false;
  bool _isRecording = false;
  double _speechSpeed = 0.78; // Slower, calm, humanized voice pacing
  List<double> _liveWaveform = [];
  String _currentTranscript = '';
  final Map<String, String> _voiceRecordings = {};
  final Map<String, String> _voiceTranscripts = {};
  final TextEditingController _textController = TextEditingController();
  List<String> _selectedMultiChoice = [];
  bool _showSummary = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentAnswer();
      _playCurrentQuestion();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textController.dispose();
    ref.read(bhashiniServiceProvider).stop();
    super.dispose();
  }

  QuestionConfig get _currentQuestion => IntakeQuestions.list[_currentQuestionIndex];

  void _loadCurrentAnswer() {
    final profile = ref.read(userProfileProvider);
    _textController.clear();
    _selectedMultiChoice = [];

    switch (_currentQuestion.key) {
      case 'q_name':
        if (profile.name != null) _textController.text = profile.name!;
        break;
      case 'q_age':
        if (profile.age != null) _textController.text = profile.age.toString();
        break;
      case 'q_income':
        if (profile.annualIncome != null) _textController.text = profile.annualIncome.toString();
        break;
      case 'q_family':
        if (profile.familySize != null) _textController.text = profile.familySize.toString();
        break;
      case 'q_need':
        _selectedMultiChoice = List<String>.from(profile.primaryNeeds);
        break;
    }

    if (_voiceTranscripts.containsKey(_currentQuestion.key)) {
      _currentTranscript = _voiceTranscripts[_currentQuestion.key]!;
    } else {
      _currentTranscript = '';
    }
  }

  Future<void> _playCurrentQuestion({double? overrideSpeed}) async {
    final l10n = AppLocalizations.of(context);
    final bhashini = ref.read(bhashiniServiceProvider);
    final profile = ref.read(userProfileProvider);
    final questionText = l10n.translate(_currentQuestion.key);

    setState(() => _isSpeakingQuestion = true);
    await bhashini.speak(
      questionText,
      languageCode: profile.languageCode,
      speed: overrideSpeed ?? _speechSpeed,
    );
    if (mounted) {
      setState(() => _isSpeakingQuestion = false);
    }
  }

  void _toggleSpeed() {
    setState(() {
      _speechSpeed = (_speechSpeed == 1.0) ? 0.75 : 1.0;
    });
    _playCurrentQuestion(overrideSpeed: _speechSpeed);
  }

  Future<void> _startRecording() async {
    final bhashini = ref.read(bhashiniServiceProvider);
    final profile = ref.read(userProfileProvider);
    await bhashini.stop();

    setState(() {
      _isRecording = true;
      _liveWaveform = [];
      _currentTranscript = "Listening to your voice...";
    });

    await bhashini.startListening(
      languageCode: profile.languageCode,
      onResult: (text, waveform) {
        if (mounted && _isRecording) {
          setState(() {
            _liveWaveform = waveform;
            _currentTranscript = text.isEmpty ? "Listening to your voice..." : text;
          });
        }
      },
    );
  }

  Future<void> _stopRecording() async {
    final bhashini = ref.read(bhashiniServiceProvider);
    await bhashini.stopListening();

    // Generate mock transcription based on question if user stopped
    String captured = _currentTranscript;
    if (captured.isEmpty || captured.startsWith("Listening")) {
      captured = _generateSimulatedVoiceAnswer(_currentQuestion.key);
    }

    setState(() {
      _isRecording = false;
      _currentTranscript = captured;
      _voiceTranscripts[_currentQuestion.key] = captured;
      _voiceRecordings[_currentQuestion.key] = "mock://recordings/${_currentQuestion.key}_take1.wav";
    });

    _persistAnswerFromVoice(captured);
  }

  void _reRecord() {
    setState(() {
      _currentTranscript = '';
      _voiceTranscripts.remove(_currentQuestion.key);
      _voiceRecordings.remove(_currentQuestion.key);
    });
    _startRecording();
  }

  String _generateSimulatedVoiceAnswer(String key) {
    switch (key) {
      case 'q_name':
        return "Ramesh Kumar";
      case 'q_age':
        return "38 years old";
      case 'q_gender':
        return "Man";
      case 'q_state':
        return "Maharashtra";
      case 'q_area':
        return "Rural (Village)";
      case 'q_caste':
        return "OBC";
      case 'q_income':
        return "Around ₹1,50,000 per year";
      case 'q_occupation':
        return "Farmer";
      case 'q_education':
        return "Up to 10th standard";
      case 'q_disability':
        return "No";
      case 'q_family':
        return "5 members";
      case 'q_need':
        return "Farming, Money";
      default:
        return "Yes, confirmed.";
    }
  }

  void _persistAnswerFromVoice(String voiceText) {
    final notifier = ref.read(userProfileProvider.notifier);
    switch (_currentQuestion.key) {
      case 'q_name':
        notifier.updateAnswer('q_name', voiceText);
        break;
      case 'q_age':
        final age = int.tryParse(RegExp(r'\d+').firstMatch(voiceText)?.group(0) ?? '') ?? 38;
        notifier.updateAnswer('q_age', age);
        break;
      case 'q_gender':
        notifier.updateAnswer('q_gender', voiceText.toLowerCase().contains('woman') ? 'woman' : 'man');
        break;
      case 'q_state':
        notifier.updateAnswer('q_state', 'Maharashtra');
        break;
      case 'q_area':
        notifier.updateAnswer('q_area', 'rural');
        break;
      case 'q_caste':
        notifier.updateAnswer('q_caste', 'OBC');
        break;
      case 'q_income':
        notifier.updateAnswer('q_income', 150000);
        break;
      case 'q_occupation':
        notifier.updateAnswer('q_occupation', 'farmer');
        break;
      case 'q_education':
        notifier.updateAnswer('q_education', '10th pass');
        break;
      case 'q_disability':
        notifier.updateAnswer('q_disability', false);
        break;
      case 'q_family':
        notifier.updateAnswer('q_family', 5);
        break;
      case 'q_need':
        notifier.updateAnswer('q_need', ['farming', 'money']);
        break;
    }
  }

  void _nextQuestion() {
    ref.read(bhashiniServiceProvider).stop();
    if (_currentQuestionIndex < IntakeQuestions.list.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _loadCurrentAnswer();
      _playCurrentQuestion();
    } else {
      setState(() {
        _showSummary = true;
      });
    }
  }

  void _prevQuestion() {
    ref.read(bhashiniServiceProvider).stop();
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
      _loadCurrentAnswer();
      _playCurrentQuestion();
    }
  }

  void _skipQuestion() {
    _nextQuestion();
  }

  void _showWhyAskedExplanation() {
    final l10n = AppLocalizations.of(context);
    final whyKey = _currentQuestion.whyAskedKey ?? 'why_asked';
    final explanation = l10n.translate(whyKey);
    final bhashini = ref.read(bhashiniServiceProvider);
    final profile = ref.read(userProfileProvider);

    bhashini.speak(explanation, languageCode: profile.languageCode);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppTheme.saffronOrange),
            const SizedBox(width: 8),
            Text(l10n.translate('why_asked')),
          ],
        ),
        content: Text(
          explanation,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              bhashini.stop();
              Navigator.pop(ctx);
            },
            child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _finishIntake() async {
    final profile = ref.read(userProfileProvider);
    if (profile.mode == AppMode.voice) {
      final helpDeskRepo = ref.read(helpDeskRepositoryProvider);
      await helpDeskRepo.submitVoiceIntake(
        profile: profile,
        recordings: _voiceRecordings,
        transcripts: _voiceTranscripts,
      );
    }
    if (!mounted) return;
    // Step: Ask for output gist language as requested
    context.push('/output-language');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(userProfileProvider);
    final isVoiceMode = profile.mode == AppMode.voice;

    if (_showSummary) {
      return _buildSummaryScreen(context, l10n, profile);
    }

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(
          l10n.translate(
            'question_progress',
            params: {
              'current': '${_currentQuestionIndex + 1}',
              'total': '${IntakeQuestions.list.length}',
            },
          ),
        ),
        leading: _currentQuestionIndex > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _prevQuestion,
              )
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
        actions: [
          // Persistent Mode Switcher Button
          TextButton.icon(
            onPressed: () {
              final newMode = isVoiceMode ? AppMode.text : AppMode.voice;
              ref.read(userProfileProvider.notifier).setMode(newMode);
            },
            icon: Icon(
              isVoiceMode ? Icons.chat_bubble_outline : Icons.mic_none,
              color: AppTheme.cream,
              size: 20,
            ),
            label: Text(
              isVoiceMode ? l10n.translate('switch_to_text') : l10n.translate('switch_to_voice'),
              style: const TextStyle(color: AppTheme.cream, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Accessible Progress Dots Indicator
            _buildProgressDots(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question Header Card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppTheme.dividerColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.translate(_currentQuestion.key),
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                          fontSize: 22,
                                          color: AppTheme.deepNavy,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _isSpeakingQuestion ? Icons.volume_up : Icons.volume_down_outlined,
                                    color: AppTheme.saffronOrange,
                                    size: 30,
                                  ),
                                  tooltip: l10n.translate('repeat_question'),
                                  onPressed: () => _playCurrentQuestion(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Slower button & Sensitive question Why Asked button
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: _toggleSpeed,
                                  icon: const Icon(Icons.slow_motion_video, size: 18),
                                  label: Text(
                                    _speechSpeed < 1.0 ? "Speed: 0.75x" : l10n.translate('slower'),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.midNavy,
                                  ),
                                ),
                                if (_currentQuestion.isSensitive) ...[
                                  const Spacer(),
                                  TextButton.icon(
                                    onPressed: _showWhyAskedExplanation,
                                    icon: const Icon(Icons.help_outline, size: 18, color: AppTheme.saffronOrange),
                                    label: Text(
                                      l10n.translate('why_asked'),
                                      style: const TextStyle(
                                        color: AppTheme.saffronOrange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // DUAL VIEW: Voice Mode or Text Mode
                    if (isVoiceMode)
                      _buildVoiceInteractionSection(l10n)
                    else
                      _buildTextInteractionSection(l10n),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentQuestion.isSensitive)
                    TextButton(
                      onPressed: _skipQuestion,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.mutedText,
                        minimumSize: const Size(100, 48),
                      ),
                      child: Text(
                        l10n.translate('skip'),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.saffronOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(140, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentQuestionIndex == IntakeQuestions.list.length - 1
                              ? "Review"
                              : "Next",
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDots() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(IntakeQuestions.list.length, (index) {
          final isCompleted = index < _currentQuestionIndex;
          final isCurrent = index == _currentQuestionIndex;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: isCurrent ? 20 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppTheme.saffronOrange
                  : (isCompleted ? AppTheme.indiaGreen : AppTheme.dividerColor),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVoiceInteractionSection(AppLocalizations l10n) {
    return Column(
      children: [
        // Pulsing Waveform visualizer
        WaveformWidget(
          levels: _liveWaveform,
          isRecording: _isRecording,
        ),
        const SizedBox(height: 16),

        // Live Transcript Display Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _currentTranscript.isNotEmpty
                  ? AppTheme.saffronOrange.withOpacity(0.5)
                  : AppTheme.dividerColor,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.subtitles_outlined, size: 20, color: AppTheme.midNavy),
                  const SizedBox(width: 8),
                  Text(
                    "Transcript",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.midNavy.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _currentTranscript.isEmpty
                    ? "Tap the big orange button below and speak your answer..."
                    : _currentTranscript,
                style: TextStyle(
                  fontSize: 17,
                  fontStyle: _currentTranscript.isEmpty ? FontStyle.italic : FontStyle.normal,
                  color: _currentTranscript.isEmpty ? AppTheme.mutedText : AppTheme.bodyText,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Big Pulsing Mic Button
        Center(
          child: ScaleTransition(
            scale: _isRecording ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording ? Colors.red : AppTheme.saffronOrange,
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording ? Colors.red : AppTheme.saffronOrange).withOpacity(0.35),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                iconSize: 48,
                icon: Icon(
                  _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                ),
                tooltip: _isRecording ? l10n.translate('stop') : l10n.translate('record'),
                onPressed: () {
                  if (_isRecording) {
                    _stopRecording();
                  } else {
                    _startRecording();
                  }
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Voice Controls: Record, Stop, Re-record, Keep this one
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            if (!_isRecording && _currentTranscript.isNotEmpty) ...[
              OutlinedButton.icon(
                onPressed: _reRecord,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(l10n.translate('re_record')),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(130, 48),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _nextQuestion,
                icon: const Icon(Icons.thumb_up_alt_outlined, size: 20),
                label: Text(l10n.translate('keep_this')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.indiaGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(140, 48),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTextInteractionSection(AppLocalizations l10n) {
    switch (_currentQuestion.inputType) {
      case QuestionInputType.text:
        return TextField(
          controller: _textController,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            hintText: "Type your answer here...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.dividerColor),
            ),
          ),
          onChanged: (val) {
            ref.read(userProfileProvider.notifier).updateAnswer(_currentQuestion.key, val);
          },
        );

      case QuestionInputType.number:
        return TextField(
          controller: _textController,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: "Enter number...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.dividerColor),
            ),
          ),
          onChanged: (val) {
            final numVal = int.tryParse(val);
            if (numVal != null) {
              ref.read(userProfileProvider.notifier).updateAnswer(_currentQuestion.key, numVal);
            }
          },
        );

      case QuestionInputType.choice:
        return Column(
          children: _currentQuestion.options.map((opt) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppTheme.dividerColor),
                ),
                tileColor: Colors.white,
                title: Text(
                  opt,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () {
                  _saveChoiceAnswer(opt);
                  _nextQuestion();
                },
              ),
            );
          }).toList(),
        );

      case QuestionInputType.multiChoice:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _currentQuestion.options.map((opt) {
                final isSelected = _selectedMultiChoice.contains(opt.toLowerCase());
                return FilterChip(
                  label: Text(opt),
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppTheme.deepNavy,
                  ),
                  selected: isSelected,
                  selectedColor: AppTheme.saffronOrange,
                  backgroundColor: Colors.white,
                  checkmarkColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isSelected ? AppTheme.saffronOrange : AppTheme.dividerColor,
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedMultiChoice.add(opt.toLowerCase());
                      } else {
                        _selectedMultiChoice.remove(opt.toLowerCase());
                      }
                    });
                    ref.read(userProfileProvider.notifier).updateAnswer('q_need', _selectedMultiChoice);
                  },
                );
              }).toList(),
            ),
          ],
        );
    }
  }

  void _saveChoiceAnswer(String choice) {
    final notifier = ref.read(userProfileProvider.notifier);
    switch (_currentQuestion.key) {
      case 'q_gender':
        notifier.updateAnswer('q_gender', choice.toLowerCase());
        break;
      case 'q_state':
        notifier.updateAnswer('q_state', choice);
        break;
      case 'q_area':
        notifier.updateAnswer('q_area', choice.toLowerCase().contains('rural') ? 'rural' : 'urban');
        break;
      case 'q_caste':
        notifier.updateAnswer('q_caste', choice);
        break;
      case 'q_income':
        int val = 150000;
        if (choice.contains('Below')) val = 80000;
        if (choice.contains('2,50,000 - 5,00,000')) val = 300000;
        if (choice.contains('Above')) val = 600000;
        notifier.updateAnswer('q_income', val);
        break;
      case 'q_occupation':
        notifier.updateAnswer('q_occupation', choice.toLowerCase());
        break;
      case 'q_education':
        notifier.updateAnswer('q_education', choice);
        break;
      case 'q_disability':
        notifier.updateAnswer('q_disability', choice == 'Yes');
        break;
      case 'q_sector_focus':
        notifier.updateAnswer('q_sector_focus', choice);
        break;
    }
  }

  Widget _buildSummaryScreen(BuildContext context, AppLocalizations l10n, UserProfile profile) {
    final summaryItems = [
      {"label": "Name", "value": profile.name ?? "Not provided", "index": 0},
      {"label": "Age", "value": profile.age != null ? "${profile.age} years" : "Not provided", "index": 1},
      {"label": "Gender", "value": profile.gender ?? "Not provided", "index": 2},
      {"label": "State", "value": profile.state ?? "Not provided", "index": 3},
      {"label": "Area", "value": profile.area ?? "Not provided", "index": 4},
      {"label": "Caste Category", "value": profile.casteCategory ?? "Skipped", "index": 5},
      {"label": "Annual Income", "value": profile.annualIncome != null ? "₹${profile.annualIncome}" : "Skipped", "index": 6},
      {"label": "Occupation", "value": profile.occupation ?? "Not provided", "index": 7},
      {"label": "Education", "value": profile.education ?? "Not provided", "index": 8},
      {"label": "Disability", "value": profile.hasDisability == true ? "Yes" : "No/Skipped", "index": 9},
      {"label": "Family Size", "value": profile.familySize != null ? "${profile.familySize} members" : "Not provided", "index": 10},
      {"label": "Needs", "value": profile.primaryNeeds.isNotEmpty ? profile.primaryNeeds.join(', ') : "General", "index": 11},
    ];

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: Text(l10n.translate('summary_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: "Read Summary Aloud",
            onPressed: () {
              final bhashini = ref.read(bhashiniServiceProvider);
              final text = summaryItems.map((e) => "${e['label']}: ${e['value']}").join(". ");
              bhashini.speak(text, languageCode: profile.languageCode);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: summaryItems.length,
                separatorBuilder: (ctx, idx) => const Divider(height: 1),
                itemBuilder: (ctx, idx) {
                  final item = summaryItems[idx];
                  return ListTile(
                    tileColor: Colors.white,
                    title: Text(item['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item['value'] as String, style: const TextStyle(fontSize: 16)),
                    trailing: TextButton(
                      child: Text(l10n.translate('edit_answer')),
                      onPressed: () {
                        setState(() {
                          _showSummary = false;
                          _currentQuestionIndex = item['index'] as int;
                        });
                        _loadCurrentAnswer();
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: ElevatedButton.icon(
                onPressed: _finishIntake,
                icon: const Icon(Icons.check_circle_rounded),
                label: Text(l10n.translate('confirm_and_submit')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
