import 'package:flutter/material.dart';

class AdminSystemConfigurationScreen extends StatelessWidget {
  const AdminSystemConfigurationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('System Configuration'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Users & Roles'),
              Tab(text: 'Integrations'),
              Tab(text: 'Maintenance'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGeneralTab(),
            _buildUsersRolesTab(),
            _buildIntegrationsTab(),
            _buildMaintenanceTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSystemSettings(),
          const SizedBox(height: 24),
          _buildNotificationSettings(),
          const SizedBox(height: 24),
          _buildLocalizationSettings(),
          const SizedBox(height: 24),
          _buildSecuritySettings(),
        ],
      ),
    );
  }

  Widget _buildSystemSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: 'Application Name',
              subtitle: 'GramPulse',
              trailing: const Icon(Icons.edit),
              onTap: () {
                // TODO: Edit application name
              },
            ),
            _buildSettingItem(
              title: 'Application Version',
              subtitle: 'v1.0.3',
              trailing: const Icon(Icons.info),
              onTap: () {
                // TODO: Show version info
              },
            ),
            _buildSwitchSettingItem(
              title: 'Enable Public Access',
              subtitle: 'Allow public to view certain data without login',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'Enable Location Services',
              subtitle: 'Use GPS and location data for better service',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'Debug Mode',
              subtitle: 'Enable detailed logging (reduces performance)',
              value: false,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchSettingItem(
              title: 'Email Notifications',
              subtitle: 'Send system notifications via email',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'SMS Notifications',
              subtitle: 'Send system notifications via SMS',
              value: false,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'Push Notifications',
              subtitle: 'Send push notifications to mobile devices',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSettingItem(
              title: 'SMS Gateway Configuration',
              subtitle: 'Configure SMS gateway settings',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to SMS gateway config
              },
            ),
            _buildSettingItem(
              title: 'Email Server Configuration',
              subtitle: 'Configure SMTP server settings',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to email server config
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalizationSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Localization Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: 'Default Language',
              subtitle: 'English',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Change default language
              },
            ),
            _buildSettingItem(
              title: 'Available Languages',
              subtitle: 'English, Hindi, Tamil, Telugu',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Manage available languages
              },
            ),
            _buildSettingItem(
              title: 'Date Format',
              subtitle: 'DD/MM/YYYY',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Change date format
              },
            ),
            _buildSettingItem(
              title: 'Time Format',
              subtitle: '24-hour',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Change time format
              },
            ),
            _buildSettingItem(
              title: 'Default Currency',
              subtitle: 'INR (₹)',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Change default currency
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              title: 'Password Policy',
              subtitle: 'Minimum 8 characters, requires special chars',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Configure password policy
              },
            ),
            _buildSwitchSettingItem(
              title: 'Two-Factor Authentication',
              subtitle: 'Require 2FA for admin accounts',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSettingItem(
              title: 'Session Timeout',
              subtitle: '30 minutes',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Configure session timeout
              },
            ),
            _buildSwitchSettingItem(
              title: 'Account Lockout',
              subtitle: 'Lock account after 5 failed attempts',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'API Access Control',
              subtitle: 'Enable API access with authentication',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildActionButton(
              title: 'Security Audit Log',
              icon: Icons.security,
              color: Colors.blue,
              onTap: () {
                // TODO: View security audit log
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersRolesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoleManagement(),
          const SizedBox(height: 24),
          _buildUserAccounts(),
          const SizedBox(height: 24),
          _buildPermissionMatrix(),
          const SizedBox(height: 24),
          _buildUserAuthentication(),
        ],
      ),
    );
  }

  Widget _buildRoleManagement() {
    final roles = [
      {
        'name': 'Administrator',
        'users': 3,
        'permissions': 'Full system access',
        'color': Colors.red,
      },
      {
        'name': 'Department Officer',
        'users': 12,
        'permissions': 'Department management, reporting',
        'color': Colors.blue,
      },
      {
        'name': 'Field Officer',
        'users': 25,
        'permissions': 'Field operations, reporting',
        'color': Colors.green,
      },
      {
        'name': 'Volunteer',
        'users': 48,
        'permissions': 'Limited access, reporting',
        'color': Colors.orange,
      },
      {
        'name': 'Citizen',
        'users': 2843,
        'permissions': 'Report issues, view status',
        'color': Colors.purple,
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Role Management',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Create new role
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Role'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...roles.map((role) => _buildRoleItem(role)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleItem(Map<String, dynamic> role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: role['color'] as Color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Permissions: ${role['permissions']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${role['users']} users',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      // TODO: Edit role
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      // TODO: Delete role
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserAccounts() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User Accounts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to user management
                  },
                  child: const Text('Manage Users'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildUserStats(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildRecentUserActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildUserStat(
          count: '2,931',
          label: 'Total Users',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _buildUserStat(
          count: '148',
          label: 'Active Today',
          icon: Icons.person_pin,
          color: Colors.green,
        ),
        _buildUserStat(
          count: '32',
          label: 'New This Week',
          icon: Icons.person_add,
          color: Colors.orange,
        ),
        _buildUserStat(
          count: '5',
          label: 'Locked Accounts',
          icon: Icons.lock,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildUserStat({
    required String count,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentUserActivity() {
    final activities = [
      {
        'user': 'Rajesh Kumar',
        'action': 'Created new account',
        'time': '2 hours ago',
        'icon': Icons.person_add,
      },
      {
        'user': 'Anita Sharma',
        'action': 'Changed role from Citizen to Volunteer',
        'time': '4 hours ago',
        'icon': Icons.swap_horiz,
      },
      {
        'user': 'Vikram Singh',
        'action': 'Account locked (5 failed attempts)',
        'time': '1 day ago',
        'icon': Icons.lock,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent User Activity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...activities.map((activity) => _buildActivityItem(activity)).toList(),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () {
              // TODO: View all activity
            },
            child: const Text('View All Activity'),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(
          activity['icon'] as IconData,
          color: Colors.blue,
        ),
      ),
      title: Text(activity['user'] as String),
      subtitle: Text(activity['action'] as String),
      trailing: Text(
        activity['time'] as String,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPermissionMatrix() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Permission Matrix',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // This would typically be a complex matrix UI
            // Placeholder for demonstration
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.table_chart,
                    size: 48,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Configure detailed permissions for each role and feature',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Edit permission matrix
                    },
                    child: const Text('Edit Permissions'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAuthentication() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authentication Methods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchSettingItem(
              title: 'Email & Password',
              subtitle: 'Traditional login with email',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'Mobile OTP',
              subtitle: 'One-time password via SMS',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'Google Sign-In',
              subtitle: 'Allow sign in with Google account',
              value: false,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'Aadhaar Integration',
              subtitle: 'Verify using Aadhaar ID',
              value: false,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSettingItem(
              title: 'Single Sign-On Configuration',
              subtitle: 'Configure SSO for government employees',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to SSO configuration
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildApiConfiguration(),
          const SizedBox(height: 24),
          _buildExternalServices(),
          const SizedBox(height: 24),
          _buildDataExchanges(),
          const SizedBox(height: 24),
          _buildWebhooks(),
        ],
      ),
    );
  }

  Widget _buildApiConfiguration() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'API Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Generate new API key
                  },
                  icon: const Icon(Icons.vpn_key),
                  label: const Text('Generate Key'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSwitchSettingItem(
              title: 'Enable API Access',
              subtitle: 'Allow external systems to access via API',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSettingItem(
              title: 'API Rate Limiting',
              subtitle: '1000 requests per hour',
              trailing: const Icon(Icons.edit, size: 16),
              onTap: () {
                // TODO: Edit rate limiting
              },
            ),
            _buildSettingItem(
              title: 'API Documentation',
              subtitle: 'View and share API documentation',
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () {
                // TODO: Open API documentation
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'API Key',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '••••••••••••••••••••••••••••••',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          // TODO: Show/hide API key
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          // TODO: Copy API key
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Created: August 10, 2025 • Expires: August 10, 2026',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExternalServices() {
    final services = [
      {
        'name': 'Weather Service',
        'status': 'Connected',
        'lastSync': '1 hour ago',
        'icon': Icons.cloud,
        'isConnected': true,
      },
      {
        'name': 'Government Portal',
        'status': 'Connected',
        'lastSync': '1 day ago',
        'icon': Icons.account_balance,
        'isConnected': true,
      },
      {
        'name': 'SMS Gateway',
        'status': 'Connected',
        'lastSync': '30 minutes ago',
        'icon': Icons.sms,
        'isConnected': true,
      },
      {
        'name': 'Payment Gateway',
        'status': 'Disconnected',
        'lastSync': 'Never',
        'icon': Icons.payment,
        'isConnected': false,
      },
      {
        'name': 'Geographic Information System',
        'status': 'Connected',
        'lastSync': '2 hours ago',
        'icon': Icons.map,
        'isConnected': true,
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'External Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Add new service
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Service'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...services.map((service) => _buildServiceItem(service)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (service['isConnected'] as bool) ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              service['icon'] as IconData,
              color: (service['isConnected'] as bool) ? Colors.blue : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: (service['isConnected'] as bool) ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${service['status']} • Last sync: ${service['lastSync']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // TODO: Configure service
                },
                tooltip: 'Configure',
              ),
              IconButton(
                icon: Icon(
                  (service['isConnected'] as bool) ? Icons.link_off : Icons.link,
                ),
                onPressed: () {
                  // TODO: Connect/disconnect service
                },
                tooltip: (service['isConnected'] as bool) ? 'Disconnect' : 'Connect',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataExchanges() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Exchange Protocols',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchSettingItem(
              title: 'REST API',
              subtitle: 'Standard RESTful API interfaces',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'GraphQL Endpoint',
              subtitle: 'Advanced query capabilities',
              value: false,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'SOAP Services',
              subtitle: 'Legacy system compatibility',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSwitchSettingItem(
              title: 'CSV/Excel Exports',
              subtitle: 'Enable data exports in common formats',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
            _buildSettingItem(
              title: 'Data Export Schedule',
              subtitle: 'Configure automated data exports',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Configure data export schedule
              },
            ),
            _buildSettingItem(
              title: 'Import Templates',
              subtitle: 'Manage data import templates',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Manage import templates
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebhooks() {
    final webhooks = [
      {
        'name': 'New Report Notification',
        'endpoint': 'https://example.com/webhooks/new-report',
        'events': 'report.created',
        'status': 'Active',
      },
      {
        'name': 'Status Change Alert',
        'endpoint': 'https://example.com/webhooks/status-change',
        'events': 'report.updated, report.resolved',
        'status': 'Active',
      },
      {
        'name': 'User Registration',
        'endpoint': 'https://example.com/webhooks/user-register',
        'events': 'user.created',
        'status': 'Inactive',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Webhooks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Add new webhook
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Webhook'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...webhooks.map((webhook) => _buildWebhookItem(webhook)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWebhookItem(Map<String, dynamic> webhook) {
    final isActive = webhook['status'] == 'Active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                webhook['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  webhook['status'] as String,
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Endpoint: ${webhook['endpoint']}',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
          Text(
            'Events: ${webhook['events']}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Test webhook
                },
                icon: const Icon(Icons.send),
                label: const Text('Test'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Edit webhook
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: Delete webhook
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSystemStatus(),
          const SizedBox(height: 24),
          _buildBackupRestore(),
          const SizedBox(height: 24),
          _buildDatabaseMaintenance(),
          const SizedBox(height: 24),
          _buildSystemLogs(),
        ],
      ),
    );
  }

  Widget _buildSystemStatus() {
    final components = [
      {
        'name': 'Web Application',
        'status': 'Operational',
        'uptime': '99.98%',
        'lastIssue': '15 days ago',
        'isOperational': true,
      },
      {
        'name': 'Mobile API',
        'status': 'Operational',
        'uptime': '99.95%',
        'lastIssue': '2 days ago',
        'isOperational': true,
      },
      {
        'name': 'Database',
        'status': 'Operational',
        'uptime': '99.99%',
        'lastIssue': '32 days ago',
        'isOperational': true,
      },
      {
        'name': 'File Storage',
        'status': 'Operational',
        'uptime': '99.97%',
        'lastIssue': '8 days ago',
        'isOperational': true,
      },
      {
        'name': 'SMS Gateway',
        'status': 'Degraded Performance',
        'uptime': '98.32%',
        'lastIssue': 'Ongoing',
        'isOperational': false,
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'System Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Refresh status
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...components.map((component) => _buildComponentStatus(component)).toList(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Updated: ${DateTime.now().hour}:${DateTime.now().minute}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View incident history
                  },
                  child: const Text('View Incident History'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentStatus(Map<String, dynamic> component) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (component['isOperational'] as bool) ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            (component['isOperational'] as bool) ? Icons.check_circle : Icons.warning,
            color: (component['isOperational'] as bool) ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  component['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Status: ${component['status']}',
                  style: TextStyle(
                    color: (component['isOperational'] as bool) ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Uptime: ${component['uptime']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                'Last issue: ${component['lastIssue']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackupRestore() {
    final backups = [
      {
        'name': 'Daily Backup',
        'date': 'August 27, 2025 02:00 AM',
        'size': '2.3 GB',
        'type': 'Automated',
      },
      {
        'name': 'Pre-Update Backup',
        'date': 'August 25, 2025 10:15 AM',
        'size': '2.2 GB',
        'type': 'Manual',
      },
      {
        'name': 'Weekly Backup',
        'date': 'August 21, 2025 02:00 AM',
        'size': '2.2 GB',
        'type': 'Automated',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Backup & Restore',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Create new backup
                  },
                  icon: const Icon(Icons.backup),
                  label: const Text('Create Backup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Recent Backups',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...backups.map((backup) => _buildBackupItem(backup)).toList(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Backup Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildSettingItem(
              title: 'Automatic Backups',
              subtitle: 'Daily at 2:00 AM',
              trailing: const Icon(Icons.edit, size: 16),
              onTap: () {
                // TODO: Edit backup schedule
              },
            ),
            _buildSettingItem(
              title: 'Backup Retention',
              subtitle: 'Keep last 30 days',
              trailing: const Icon(Icons.edit, size: 16),
              onTap: () {
                // TODO: Edit retention policy
              },
            ),
            _buildSettingItem(
              title: 'Backup Storage',
              subtitle: 'Cloud Storage (3 copies)',
              trailing: const Icon(Icons.edit, size: 16),
              onTap: () {
                // TODO: Edit storage settings
              },
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Restore from backup
              },
              icon: const Icon(Icons.restore),
              label: const Text('Restore from Backup'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupItem(Map<String, dynamic> backup) {
    return ListTile(
      title: Text(backup['name'] as String),
      subtitle: Text('${backup['date']} • ${backup['size']} • ${backup['type']}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // TODO: Download backup
            },
            tooltip: 'Download',
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: () {
              // TODO: Restore from this backup
            },
            tooltip: 'Restore',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // TODO: Delete backup
            },
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }

  Widget _buildDatabaseMaintenance() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Database Maintenance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              title: 'Clear System Cache',
              icon: Icons.cleaning_services,
              color: Colors.blue,
              onTap: () {
                // TODO: Clear cache
              },
            ),
            _buildActionButton(
              title: 'Optimize Database',
              icon: Icons.speed,
              color: Colors.green,
              onTap: () {
                // TODO: Optimize database
              },
            ),
            _buildActionButton(
              title: 'Rebuild Indexes',
              icon: Icons.build,
              color: Colors.orange,
              onTap: () {
                // TODO: Rebuild indexes
              },
            ),
            _buildActionButton(
              title: 'Clean Up Temporary Files',
              icon: Icons.delete_sweep,
              color: Colors.purple,
              onTap: () {
                // TODO: Clean up temp files
              },
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildActionButton(
              title: 'Reset System (DANGER)',
              icon: Icons.warning,
              color: Colors.red,
              onTap: () {
                // TODO: Show reset system dialog
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemLogs() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'System Logs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'All Logs',
                    items: [
                      'All Logs',
                      'Error Logs',
                      'Access Logs',
                      'Security Logs',
                      'Audit Logs',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      // TODO: Handle log type selection
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder for log viewer
            Container(
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '[2025-08-27 08:32:15] [INFO] Application started',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '[2025-08-27 08:33:22] [INFO] User login: admin@example.com',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '[2025-08-27 08:35:41] [WARN] Rate limit exceeded for IP: 192.168.1.105',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '[2025-08-27 08:36:12] [ERROR] Database connection timeout',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '[2025-08-27 08:36:18] [INFO] Database connection established',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Download logs
                  },
                  icon: const Icon(Icons.file_download),
                  label: const Text('Download Logs'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Clear logs
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Clear Logs'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Log Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildSettingItem(
              title: 'Log Level',
              subtitle: 'Information',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Change log level
              },
            ),
            _buildSettingItem(
              title: 'Log Retention',
              subtitle: 'Keep logs for 30 days',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Change log retention
              },
            ),
            _buildSwitchSettingItem(
              title: 'Remote Logging',
              subtitle: 'Send logs to monitoring service',
              value: true,
              onChanged: (value) {
                // TODO: Handle toggle
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchSettingItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
