import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VolunteerShellScreen extends StatelessWidget {
  final Widget child;
  final String location;

  const VolunteerShellScreen({
    Key? key,
    required this.child,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(location),
        onTap: (index) => _onItemTapped(index, context),
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: 'Verify',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'SHG',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Assist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/volunteer/dashboard')) return 0;
    if (location.startsWith('/volunteer/verification-queue')) return 1;
    if (location.startsWith('/volunteer/shg')) return 2;
    if (location.startsWith('/volunteer/assist-citizen')) return 3;
    if (location.startsWith('/volunteer/performance')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/volunteer/dashboard');
        break;
      case 1:
        context.go('/volunteer/verification-queue');
        break;
      case 2:
        context.go('/volunteer/shg');
        break;
      case 3:
        context.go('/volunteer/assist-citizen');
        break;
      case 4:
        context.go('/volunteer/performance');
        break;
    }
  }
}
