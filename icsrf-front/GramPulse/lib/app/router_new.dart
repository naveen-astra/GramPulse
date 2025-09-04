import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/screens/phone_auth_screen_new.dart';
import '../features/auth/presentation/screens/otp_verification_screen_new.dart';
import '../features/auth/presentation/screens/role_pre_selection_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/bloc/splash_bloc.dart';
import '../features/citizen/presentation/screens/citizen_home_screen_new.dart';
import '../features/citizen/presentation/screens/citizen_dashboard_screen.dart';
import '../features/citizen/presentation/screens/report_issue_screen.dart';
import '../features/citizen/presentation/screens/my_reports_screen.dart';
import '../features/volunteer/presentation/screens/volunteer_dashboard_screen.dart';
import '../features/volunteer/presentation/screens/assist_citizen_screen.dart';
import '../features/volunteer/presentation/screens/verification_queue_screen.dart';
import '../features/volunteer/presentation/screens/notifications_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash screen - entry point
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => BlocProvider(
        create: (context) => SplashBloc()..add(const CheckAuthStatusEvent()),
        child: const SplashScreen(),
      ),
    ),
    // Role pre-selection screen - shows before authentication
    GoRoute(
      path: '/role-selection',
      name: 'role-selection',
      builder: (context, state) => const RolePreSelectionScreen(),
    ),
    // Phone authentication with role parameter
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) {
        final role = state.uri.queryParameters['role'];
        return PhoneAuthScreen(selectedRole: role);
      },
    ),
    GoRoute(
      path: '/otp-verification',
      name: 'otp-verification',
      builder: (context, state) {
        final phone = state.extra as String? ?? '';
        final role = state.uri.queryParameters['role'];
        return OtpVerificationScreen(
          phone: phone,
          selectedRole: role,
        );
      },
    ),
    // Citizen routes
    GoRoute(
      path: '/citizen-home',
      name: 'citizen-home',
      builder: (context, state) => const CitizenHomeScreenNew(),
    ),
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
    // Volunteer routes
    GoRoute(
      path: '/volunteer/dashboard',
      name: 'volunteer-dashboard',
      builder: (context, state) => const VolunteerDashboardScreen(),
    ),
    GoRoute(
      path: '/volunteer/assist-citizen',
      name: 'volunteer-assist-citizen',
      builder: (context, state) => const AssistCitizenScreen(),
    ),
    GoRoute(
      path: '/volunteer/verification-queue',
      name: 'volunteer-verification-queue',
      builder: (context, state) => const VerificationQueueScreen(),
    ),
    GoRoute(
      path: '/volunteer/verification-queue/:id',
      name: 'volunteer-verification-detail',
      builder: (context, state) {
        // For now, just navigate to the verification queue screen
        // You can enhance this later to show specific request details
        return const VerificationQueueScreen();
      },
    ),
    GoRoute(
      path: '/volunteer/notifications',
      name: 'volunteer-notifications',
      builder: (context, state) => const NotificationsScreen(),
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
