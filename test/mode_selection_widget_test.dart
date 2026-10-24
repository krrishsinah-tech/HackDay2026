import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:umeed/core/l10n/app_localizations.dart';
import 'package:umeed/domain/models/user_profile.dart';
import 'package:umeed/features/onboarding/mode_selection_screen.dart';
import 'package:umeed/providers/app_providers.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: child,
      ),
    );
  }

  group('Mode Selection Widget Tests', () {
    testWidgets('Renders both Voice Mode and Text Mode cards with badges', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const ModeSelectionScreen()));
      await tester.pumpAndSettle();

      // Check Voice Mode card
      expect(find.byKey(const Key('mode_voice_card')), findsOneWidget);
      expect(find.text("Voice Mode"), findsOneWidget);
      expect(find.text("Recommended for low literacy"), findsOneWidget);
      expect(find.byIcon(Icons.mic_rounded), findsOneWidget);

      // Check Text Mode card
      expect(find.byKey(const Key('mode_text_card')), findsOneWidget);
      expect(find.text("Text Mode"), findsOneWidget);
      expect(find.text("For those who can read and type"), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);
    });

    testWidgets('Audio prompt bar is visible and clickable', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const ModeSelectionScreen()));
      await tester.pumpAndSettle();

      expect(find.text("Press the orange button to speak, or the blue button to type."), findsOneWidget);
    });
  });
}
