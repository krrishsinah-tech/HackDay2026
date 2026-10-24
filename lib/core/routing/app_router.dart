import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/help_desk_submission.dart';
import '../../features/onboarding/welcome_screen.dart';
import '../../features/onboarding/splash_and_consent_screen.dart';
import '../../features/onboarding/language_selection_screen.dart';
import '../../features/onboarding/mode_selection_screen.dart';
import '../../features/intake/intake_screen.dart';
import '../../features/intake/help_desk_handoff_screen.dart';
import '../../features/dashboard/output_language_screen.dart';
import '../../features/dashboard/scheme_gist_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/scheme_detail/scheme_detail_screen.dart';
import '../../features/scheme_detail/scheme_compare_screen.dart';
import '../../features/scheme_detail/scheme_application_journey_screen.dart';
import '../../features/admin/help_desk_console_screen.dart';
import '../../features/settings/settings_and_privacy_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/consent',
      builder: (context, state) => const SplashAndConsentScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageSelectionScreen(),
    ),
    GoRoute(
      path: '/mode',
      builder: (context, state) => const ModeSelectionScreen(),
    ),
    GoRoute(
      path: '/intake',
      builder: (context, state) => const IntakeScreen(),
    ),
    GoRoute(
      path: '/output-language',
      builder: (context, state) => const OutputLanguageScreen(),
    ),
    GoRoute(
      path: '/gist',
      builder: (context, state) => const SchemeGistScreen(),
    ),
    GoRoute(
      path: '/handoff',
      builder: (context, state) {
        final submission = state.extra as HelpDeskSubmission?;
        return HelpDeskHandoffScreen(submission: submission);
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/scheme/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return SchemeDetailScreen(schemeId: id);
      },
    ),
    GoRoute(
      path: '/compare',
      builder: (context, state) {
        final schemeId = state.uri.queryParameters['schemeId'];
        return SchemeCompareScreen(initialSchemeId: schemeId);
      },
    ),
    GoRoute(
      path: '/apply/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return SchemeApplicationJourneyScreen(schemeId: id);
      },
    ),
    GoRoute(
      path: '/helpdesk',
      builder: (context, state) => const HelpDeskConsoleScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsAndPrivacyScreen(),
    ),
  ],
);
