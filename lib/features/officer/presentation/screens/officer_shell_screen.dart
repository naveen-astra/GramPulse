import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell screen for Officer user role
/// Provides bottom navigation between:
/// - Dashboard
/// - Inbox
/// - Work Orders
/// - Analytics
class OfficerShellScreen extends StatelessWidget {
  final Widget child;
  final String location;

  const OfficerShellScreen({
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
          icon: Icon(Icons.inbox),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'Work Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
      ],
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/officer/dashboard')) return 0;
    if (location.startsWith('/officer/inbox')) return 1;
    if (location.startsWith('/officer/work-orders')) return 2;
    if (location.startsWith('/officer/analytics')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed('officer_dashboard');
        break;
      case 1:
        context.goNamed('officer_inbox');
        break;
      case 2:
        context.goNamed('officer_work_orders');
        break;
      case 3:
        context.goNamed('officer_analytics');
        break;
    }
  }
}
