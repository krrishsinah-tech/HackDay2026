import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class WaveformWidget extends StatelessWidget {
  final List<double> levels; // 16 values between 0.1 and 1.0
  final bool isRecording;

  const WaveformWidget({
    super.key,
    required this.levels,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    final displayLevels = levels.isEmpty
        ? List.generate(16, (i) => 0.15)
        : levels;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isRecording ? AppTheme.saffronOrange.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(displayLevels.length, (index) {
          final level = displayLevels[index].clamp(0.1, 1.0);
          final barHeight = 12.0 + (level * 46.0);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: 5,
            height: barHeight,
            decoration: BoxDecoration(
              color: isRecording ? AppTheme.saffronOrange : AppTheme.midNavy.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
