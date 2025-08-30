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
import '../core/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/blocs/auth_bloc.dart';
import '../features/auth/domain/auth_events_states.dart';

final appRouter = GoRouter(
  initialLocation: '/jwt-test',
  routes: [
    // Root route redirects to role selection
    GoRoute(
      path: '/',
      name: 'root',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/jwt-test',
      name: 'jwt-test',
      builder: (context, state) => _JwtTestScreen(),
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

class _JwtTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JWT Token Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'JWT Token Test Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final apiService = ApiService();
                const token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OGIyZWEyOTRlMjJlYzFhOTA3NGIxZTQiLCJpYXQiOjE3NTY1NTU4MzIsImV4cCI6MTc1NzE2MDYzMn0.tcbn5a43cgpS85VTcSCIzY9KhpMTADhgBhhMFI-VNxs';
                await apiService.saveToken(token);
                
                final authBloc = context.read<AuthBloc>();
                authBloc.add(CheckAuthStatusEvent());
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('JWT Token set successfully!')),
                );
              },
              child: const Text('Set JWT Token'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final apiService = ApiService();
                final token = await apiService.getToken();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Current token: ${token?.substring(0, 20) ?? 'None'}...')),
                );
              },
              child: const Text('Check Current Token'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final apiService = ApiService();
                await apiService.clearToken();
                
                final authBloc = context.read<AuthBloc>();
                authBloc.add(CheckAuthStatusEvent());
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Token cleared!')),
                );
              },
              child: const Text('Clear Token'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/role-selection'),
              child: const Text('Go to Role Selection'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/citizen-home'),
              child: const Text('Go to Citizen Home'),
            ),
          ],
        ),
      ),
    );
  }
}
