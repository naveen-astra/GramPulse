import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/phone_auth_screen_new.dart';
import '../features/auth/presentation/screens/otp_verification_screen_new.dart';
import '../features/citizen/presentation/screens/citizen_home_screen_new.dart';
import '../features/citizen/presentation/screens/citizen_dashboard_screen.dart';
import '../features/citizen/presentation/screens/report_issue_screen.dart';
import '../features/citizen/presentation/screens/my_reports_screen.dart';
import '../features/officer/presentation/screens/officer_login_screen.dart';
import '../features/officer/presentation/screens/officer_otp_screen.dart';
import '../features/officer/presentation/screens/officer_dashboard_screen.dart';
import '../features/auth/presentation/screens/role_selection_screen.dart';
import '../features/officer/presentation/screens/officer_incidents_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/profile/data/models/user_profile.dart';

final appRouter = GoRouter(
  initialLocation: '/auth',
  routes: [
    // Root route redirects to auth
    GoRoute(
      path: '/',
      name: 'root',
      builder: (context, state) => const PhoneAuthScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      name: 'role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const PhoneAuthScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      name: 'otp-verification',
      builder: (context, state) {
        final phone = state.extra as String? ?? '';
        return OtpVerificationScreen(phone: phone);
      },
    ),
    GoRoute(
      path: '/citizen-home',
      name: 'citizen-home',
      builder: (context, state) => const CitizenHomeScreenNew(),
    ),
    // New citizen features with nested routing
    GoRoute(
      path: '/citizen',
      name: 'citizen',
      builder: (context, state) => const CitizenDashboardScreen(),
      routes: [
        GoRoute(
          path: 'report',
          name: 'citizen-report',
          builder: (context, state) => const ReportIssueScreen(),
        ),
        GoRoute(
          path: 'reports',
          name: 'citizen-reports',
          builder: (context, state) => const MyReportsScreen(),
        ),
      ],
    ),
    // Officer authentication routes
    GoRoute(
      path: '/officer-login',
      name: 'officer-login',
      builder: (context, state) => const OfficerLoginScreen(),
    ),
    GoRoute(
      path: '/officer-otp',
      name: 'officer-otp',
      builder: (context, state) {
        final phone = state.extra as String? ?? '';
        return OfficerOTPScreen(phone: phone);
      },
    ),
    // Officer dashboard with nested routes
    GoRoute(
      path: '/officer',
      name: 'officer',
      builder: (context, state) => const OfficerDashboardScreen(),
      routes: [
        GoRoute(
          path: 'incidents',
          name: 'officer-incidents',
          builder: (context, state) {
            final queryParams = state.uri.queryParameters;
            return OfficerIncidentsScreen(
              initialStatus: queryParams['status'],
              initialCategory: queryParams['category'],
            );
          },
        ),
      ],
    ),
    // Profile routes
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      name: 'edit-profile',
      builder: (context, state) {
        final profile = state.extra as UserProfile?;
        if (profile == null) {
          // If no profile is passed, redirect to profile screen
          return const ProfileScreen();
        }
        return EditProfileScreen(profile: profile);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Page not found: ${state.matchedLocation}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/auth'),
            child: const Text('Go to Home'),
          ),
        ],
      ),
    ),
  ),
);
