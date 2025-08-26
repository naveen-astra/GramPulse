import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell screen for Administrator user role
/// Provides side drawer navigation between:
/// - Control Room
/// - Department Performance
/// - Fund Allocation & Relief
/// - System Configuration
/// - Analytics & Reports
class AdminShellScreen extends StatelessWidget {
  final Widget child;
  final String location;

  const AdminShellScreen({
    required this.child,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrator Portal'),
      ),
      drawer: _buildNavigationDrawer(context),
      body: child,
    );
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 40, color: Colors.indigo),
                ),
                SizedBox(height: 10),
                Text(
                  'Administrator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.dashboard,
            title: 'Control Room',
            routeName: 'admin_control_room',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.business,
            title: 'Department Performance',
            routeName: 'admin_department_performance',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.account_balance,
            title: 'Fund Allocation & Relief',
            routeName: 'admin_fund_allocation',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.settings,
            title: 'System Configuration',
            routeName: 'admin_system_configuration',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.analytics,
            title: 'Analytics & Reports',
            routeName: 'admin_analytics_reports',
          ),
          const Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // TODO: Implement logout functionality
              context.goNamed('login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? routeName,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap ?? () {
        if (routeName != null) {
          context.goNamed(routeName);
        }
        Navigator.pop(context); // Close the drawer
      },
    );
  }
}
