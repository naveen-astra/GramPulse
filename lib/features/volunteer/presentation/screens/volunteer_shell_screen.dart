import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell screen for Volunteer user role
/// Provides bottom navigation between:
/// - Dashboard
/// - Verification Queue
/// - Assist Citizen
/// - Performance
class VolunteerShellScreen extends StatelessWidget {
  final Widget child;
  final String location;

  const VolunteerShellScreen({
    required this.child,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _calculateSelectedIndex(location),
      onTap: (int idx) => _onItemTapped(idx, context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fact_check),
          label: 'Verification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Assist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Performance',
        ),
      ],
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/volunteer/dashboard')) return 0;
    if (location.startsWith('/volunteer/verification-queue')) return 1;
    if (location.startsWith('/volunteer/assist-citizen')) return 2;
    if (location.startsWith('/volunteer/performance')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('volunteer_dashboard');
        break;
      case 1:
        context.goNamed('volunteer_verification_queue');
        break;
      case 2:
        context.goNamed('volunteer_assist_citizen');
        break;
      case 3:
        context.goNamed('volunteer_performance');
        break;
    }
  }
}
