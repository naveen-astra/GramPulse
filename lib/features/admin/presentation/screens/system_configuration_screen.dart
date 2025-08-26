import 'package:flutter/material.dart';

class SystemConfigurationScreen extends StatefulWidget {
  const SystemConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<SystemConfigurationScreen> createState() => _SystemConfigurationScreenState();
}

class _SystemConfigurationScreenState extends State<SystemConfigurationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Configuration'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'General'),
            Tab(text: 'Users & Roles'),
            Tab(text: 'Integrations'),
            Tab(text: 'Maintenance'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGeneralTab(),
          _buildUsersAndRolesTab(),
          _buildIntegrationsTab(),
          _buildMaintenanceTab(),
        ],
      ),
    );
  }

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'System Settings',
            children: [
              _buildSettingItem(
                title: 'Application Name',
                subtitle: 'Current: GramPulse',
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit application name
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Application Version',
                subtitle: 'v1.0.2 (Build 452)',
                trailing: TextButton(
                  onPressed: () {
                    // TODO: Implement check for updates
                  },
                  child: const Text('Check for Updates'),
                ),
              ),
              _buildSettingItem(
                title: 'Enable Citizen Reports',
                subtitle: 'Allow citizens to submit reports',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Enable Volunteer Registration',
                subtitle: 'Allow citizens to register as volunteers',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Notification Settings',
            children: [
              _buildSettingItem(
                title: 'Email Notifications',
                subtitle: 'Configure email templates and triggers',
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // TODO: Navigate to email settings
                  },
                ),
              ),
              _buildSettingItem(
                title: 'SMS Notifications',
                subtitle: 'Configure SMS templates and triggers',
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // TODO: Navigate to SMS settings
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Push Notifications',
                subtitle: 'Configure push notification settings',
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // TODO: Navigate to push notification settings
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Notification Frequency',
                subtitle: 'Current: As events occur',
                trailing: DropdownButton<String>(
                  value: 'As events occur',
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // TODO: Implement dropdown change
                  },
                  items: <String>['As events occur', 'Daily digest', 'Weekly digest']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Localization Settings',
            children: [
              _buildSettingItem(
                title: 'Default Language',
                subtitle: 'Current: English',
                trailing: DropdownButton<String>(
                  value: 'English',
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // TODO: Implement dropdown change
                  },
                  items: <String>['English', 'Hindi', 'Tamil', 'Telugu', 'Kannada', 'Malayalam']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              _buildSettingItem(
                title: 'Date Format',
                subtitle: 'Current: DD/MM/YYYY',
                trailing: DropdownButton<String>(
                  value: 'DD/MM/YYYY',
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // TODO: Implement dropdown change
                  },
                  items: <String>['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY/MM/DD']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              _buildSettingItem(
                title: 'Time Format',
                subtitle: 'Current: 24-hour',
                trailing: DropdownButton<String>(
                  value: '24-hour',
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // TODO: Implement dropdown change
                  },
                  items: <String>['24-hour', '12-hour (AM/PM)']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              _buildSettingItem(
                title: 'Currency',
                subtitle: 'Current: ₹ (INR)',
                trailing: DropdownButton<String>(
                  value: '₹ (INR)',
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // TODO: Implement dropdown change
                  },
                  items: <String>['₹ (INR)', '\$ (USD)', '€ (EUR)', '£ (GBP)']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Security Settings',
            children: [
              _buildSettingItem(
                title: 'Password Policy',
                subtitle: 'Configure minimum requirements and expiration',
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // TODO: Navigate to password policy settings
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Two-Factor Authentication',
                subtitle: 'Require 2FA for admin accounts',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Session Timeout',
                subtitle: 'Current: 30 minutes',
                trailing: DropdownButton<String>(
                  value: '30 minutes',
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // TODO: Implement dropdown change
                  },
                  items: <String>['15 minutes', '30 minutes', '1 hour', '2 hours', '4 hours']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              _buildSettingItem(
                title: 'IP Restriction',
                subtitle: 'Restrict admin access by IP address',
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // TODO: Navigate to IP restriction settings
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement save settings
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildUsersAndRolesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'Role Management',
            children: [
              _buildRoleItem(
                title: 'Super Admin',
                subtitle: 'Full system access and permissions',
                userCount: 2,
              ),
              _buildRoleItem(
                title: 'Department Admin',
                subtitle: 'Department-specific administration',
                userCount: 8,
              ),
              _buildRoleItem(
                title: 'Moderator',
                subtitle: 'Content moderation and report handling',
                userCount: 12,
              ),
              _buildRoleItem(
                title: 'Analyst',
                subtitle: 'View reports and analytics data',
                userCount: 6,
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement create new role
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Role'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'User Accounts',
            children: [
              _buildStatCard(
                title: 'Total Users',
                value: '12,654',
                icon: Icons.people,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Citizens',
                      value: '12,456',
                      icon: Icons.person,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Volunteers',
                      value: '485',
                      icon: Icons.volunteer_activism,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Admins',
                      value: '28',
                      icon: Icons.admin_panel_settings,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Active Now',
                      value: '483',
                      icon: Icons.online_prediction,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Recent Account Activity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildActivityItem(
                username: 'rajesh.kumar@example.com',
                action: 'Account created',
                time: '2 hours ago',
                role: 'Citizen',
              ),
              _buildActivityItem(
                username: 'priya.sharma@example.com',
                action: 'Role changed to Volunteer',
                time: '5 hours ago',
                role: 'Volunteer',
              ),
              _buildActivityItem(
                username: 'amit.patel@example.com',
                action: 'Password reset',
                time: '1 day ago',
                role: 'Citizen',
              ),
              _buildActivityItem(
                username: 'sanjay.singh@example.com',
                action: 'Department changed to Water',
                time: '2 days ago',
                role: 'Department Admin',
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to user management
                  },
                  icon: const Icon(Icons.manage_accounts),
                  label: const Text('User Management'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Permission Matrix',
            children: [
              const Text(
                'Configure permissions for each role and user type in the system.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Text(
                              'Permission',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Super Admin',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Dept Admin',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Moderator',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Analyst',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    _buildPermissionRow(
                      permission: 'User Management',
                      superAdmin: true,
                      deptAdmin: false,
                      moderator: false,
                      analyst: false,
                    ),
                    _buildPermissionRow(
                      permission: 'Role Management',
                      superAdmin: true,
                      deptAdmin: false,
                      moderator: false,
                      analyst: false,
                    ),
                    _buildPermissionRow(
                      permission: 'System Configuration',
                      superAdmin: true,
                      deptAdmin: false,
                      moderator: false,
                      analyst: false,
                    ),
                    _buildPermissionRow(
                      permission: 'View Analytics',
                      superAdmin: true,
                      deptAdmin: true,
                      moderator: false,
                      analyst: true,
                    ),
                    _buildPermissionRow(
                      permission: 'Manage Reports',
                      superAdmin: true,
                      deptAdmin: true,
                      moderator: true,
                      analyst: false,
                    ),
                    _buildPermissionRow(
                      permission: 'Fund Allocation',
                      superAdmin: true,
                      deptAdmin: true,
                      moderator: false,
                      analyst: false,
                    ),
                    _buildPermissionRow(
                      permission: 'Export Data',
                      superAdmin: true,
                      deptAdmin: true,
                      moderator: false,
                      analyst: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to permission settings
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Permissions'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Authentication Methods',
            children: [
              _buildSettingItem(
                title: 'Email & Password',
                subtitle: 'Basic authentication method',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Google Sign-In',
                subtitle: 'Allow sign in with Google accounts',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Facebook Sign-In',
                subtitle: 'Allow sign in with Facebook accounts',
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Phone Authentication',
                subtitle: 'Allow sign in with phone number and OTP',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Single Sign-On (SSO)',
                subtitle: 'Configure SSO for organizational accounts',
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // TODO: Navigate to SSO settings
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement save settings
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildIntegrationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: 'API Configuration',
            children: [
              _buildSettingItem(
                title: 'API Status',
                subtitle: 'REST API for external integrations',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'API Version',
                subtitle: 'Current: v2.0',
                trailing: DropdownButton<String>(
                  value: 'v2.0',
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // TODO: Implement dropdown change
                  },
                  items: <String>['v1.0', 'v1.5', 'v2.0']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              _buildSettingItem(
                title: 'Rate Limiting',
                subtitle: 'Current: 100 requests per minute',
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit rate limiting
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'API Keys',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildApiKeyItem(
                name: 'Mobile App',
                createdDate: 'Created: Jun 15, 2025',
                lastUsed: 'Last used: 2 hours ago',
              ),
              _buildApiKeyItem(
                name: 'Web Dashboard',
                createdDate: 'Created: Jul 22, 2025',
                lastUsed: 'Last used: 5 minutes ago',
              ),
              _buildApiKeyItem(
                name: 'Analytics Integration',
                createdDate: 'Created: Aug 05, 2025',
                lastUsed: 'Last used: 1 day ago',
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement generate new API key
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Generate New API Key'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'External Services',
            children: [
              _buildIntegrationItem(
                title: 'SMS Gateway',
                subtitle: 'SendSMS.com',
                status: 'Connected',
                isConnected: true,
              ),
              _buildIntegrationItem(
                title: 'Email Service',
                subtitle: 'SendGrid',
                status: 'Connected',
                isConnected: true,
              ),
              _buildIntegrationItem(
                title: 'Maps API',
                subtitle: 'Google Maps',
                status: 'Connected',
                isConnected: true,
              ),
              _buildIntegrationItem(
                title: 'Payment Gateway',
                subtitle: 'RazorPay',
                status: 'Not Connected',
                isConnected: false,
              ),
              _buildIntegrationItem(
                title: 'Cloud Storage',
                subtitle: 'AWS S3',
                status: 'Connected',
                isConnected: true,
              ),
              _buildIntegrationItem(
                title: 'Analytics Service',
                subtitle: 'Google Analytics',
                status: 'Connected',
                isConnected: true,
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement add new integration
                  },
                  icon: const Icon(Icons.add_link),
                  label: const Text('Add New Integration'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Data Exchange Protocols',
            children: [
              _buildSettingItem(
                title: 'Open Data Protocol',
                subtitle: 'Share data with other government systems',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Data Export Format',
                subtitle: 'Current: JSON',
                trailing: DropdownButton<String>(
                  value: 'JSON',
                  underline: Container(),
                  onChanged: (String? newValue) {
                    // TODO: Implement dropdown change
                  },
                  items: <String>['JSON', 'XML', 'CSV', 'Excel']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              _buildSettingItem(
                title: 'Automated Data Sharing',
                subtitle: 'Schedule automated data exports',
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // TODO: Navigate to data sharing settings
                  },
                ),
              ),
              _buildSettingItem(
                title: 'API Documentation',
                subtitle: 'Public API documentation for developers',
                trailing: OutlinedButton(
                  onPressed: () {
                    // TODO: View API documentation
                  },
                  child: const Text('View'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Webhooks',
            children: [
              const Text(
                'Configure webhooks to notify external systems about events.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildWebhookItem(
                name: 'New Report Notification',
                url: 'https://example.com/webhooks/reports',
                events: ['report.created', 'report.updated'],
                isActive: true,
              ),
              _buildWebhookItem(
                name: 'User Registration',
                url: 'https://crm.example.com/api/users',
                events: ['user.created'],
                isActive: true,
              ),
              _buildWebhookItem(
                name: 'Payment Notification',
                url: 'https://billing.example.com/payments',
                events: ['payment.success', 'payment.failed'],
                isActive: false,
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement add webhook
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Webhook'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement save settings
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
          _buildSection(
            title: 'System Status',
            children: [
              _buildSystemStatusItem(
                title: 'API Server',
                status: 'Operational',
                isOperational: true,
                details: 'Response time: 45ms',
              ),
              _buildSystemStatusItem(
                title: 'Database',
                status: 'Operational',
                isOperational: true,
                details: 'Load: 32%',
              ),
              _buildSystemStatusItem(
                title: 'File Storage',
                status: 'Operational',
                isOperational: true,
                details: 'Used: 258GB of 1TB',
              ),
              _buildSystemStatusItem(
                title: 'Cache Server',
                status: 'Degraded',
                isOperational: false,
                details: 'High memory usage',
              ),
              _buildSystemStatusItem(
                title: 'Email Service',
                status: 'Operational',
                isOperational: true,
                details: 'Queue: 8 emails',
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Implement refresh status
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Status'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Backup & Restore',
            children: [
              const Text(
                'Last Backup: August 26, 2025 at 01:00 AM',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement create backup
                      },
                      icon: const Icon(Icons.backup),
                      label: const Text('Create Backup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement restore backup
                      },
                      icon: const Icon(Icons.restore),
                      label: const Text('Restore Backup'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Backup History',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _buildBackupItem(
                date: 'August 26, 2025 01:00 AM',
                size: '482 MB',
                type: 'Automatic',
              ),
              _buildBackupItem(
                date: 'August 25, 2025 01:00 AM',
                size: '475 MB',
                type: 'Automatic',
              ),
              _buildBackupItem(
                date: 'August 24, 2025 01:00 AM',
                size: '471 MB',
                type: 'Automatic',
              ),
              _buildBackupItem(
                date: 'August 23, 2025 12:32 PM',
                size: '468 MB',
                type: 'Manual',
              ),
              const SizedBox(height: 16),
              _buildSettingItem(
                title: 'Automatic Backups',
                subtitle: 'Daily at 01:00 AM',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement toggle
                  },
                ),
              ),
              _buildSettingItem(
                title: 'Backup Retention',
                subtitle: 'Keep backups for 30 days',
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // TODO: Implement edit retention
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'Database Maintenance',
            children: [
              _buildMaintenanceActionItem(
                title: 'Optimize Database',
                subtitle: 'Clean up and optimize database performance',
                icon: Icons.speed,
                buttonText: 'Optimize',
              ),
              _buildMaintenanceActionItem(
                title: 'Run Integrity Check',
                subtitle: 'Verify database integrity and fix issues',
                icon: Icons.check_circle,
                buttonText: 'Run Check',
              ),
              _buildMaintenanceActionItem(
                title: 'Clean Old Records',
                subtitle: 'Archive or delete old records and attachments',
                icon: Icons.cleaning_services,
                buttonText: 'Clean Up',
              ),
              _buildMaintenanceActionItem(
                title: 'Database Statistics',
                subtitle: 'View detailed database statistics and metrics',
                icon: Icons.bar_chart,
                buttonText: 'View Stats',
              ),
              const SizedBox(height: 16),
              const Text(
                'Database Size: 3.82 GB',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.38,
                backgroundColor: Colors.grey[200],
                color: Colors.blue,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '38% of allocated space used',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: 'System Logs',
            children: [
              const Text(
                'View and download system logs for troubleshooting.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildLogTypeItem(
                title: 'Application Logs',
                subtitle: 'Application events and errors',
                icon: Icons.app_registration,
              ),
              _buildLogTypeItem(
                title: 'Access Logs',
                subtitle: 'User access and authentication',
                icon: Icons.login,
              ),
              _buildLogTypeItem(
                title: 'Error Logs',
                subtitle: 'System errors and exceptions',
                icon: Icons.error,
              ),
              _buildLogTypeItem(
                title: 'Audit Logs',
                subtitle: 'User actions and data changes',
                icon: Icons.history,
              ),
              _buildLogTypeItem(
                title: 'Performance Logs',
                subtitle: 'System performance metrics',
                icon: Icons.speed,
              ),
              const SizedBox(height: 16),
              const Text(
                'Recent Error Logs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogEntryItem(
                      level: 'ERROR',
                      message: 'Failed to connect to SMS gateway',
                      timestamp: '2025-08-27 09:32:15',
                    ),
                    _buildLogEntryItem(
                      level: 'WARN',
                      message: 'High database load detected',
                      timestamp: '2025-08-27 08:45:22',
                    ),
                    _buildLogEntryItem(
                      level: 'ERROR',
                      message: 'Payment processing failed for transaction #8754',
                      timestamp: '2025-08-26 18:12:03',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to log viewer
                  },
                  icon: const Icon(Icons.assignment),
                  label: const Text('Advanced Log Viewer'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement save settings
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Settings'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildRoleItem({
    required String title,
    required String subtitle,
    required int userCount,
  }) {
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
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.security,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$userCount Users',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit role
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String username,
    required String action,
    required String time,
    required String role,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: const Icon(
              Icons.person,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  action,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  role,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRow({
    required String permission,
    required bool superAdmin,
    required bool deptAdmin,
    required bool moderator,
    required bool analyst,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(permission),
            ),
            Expanded(
              child: Center(
                child: Icon(
                  superAdmin ? Icons.check_circle : Icons.cancel,
                  color: superAdmin ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Icon(
                  deptAdmin ? Icons.check_circle : Icons.cancel,
                  color: deptAdmin ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Icon(
                  moderator ? Icons.check_circle : Icons.cancel,
                  color: moderator ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Icon(
                  analyst ? Icons.check_circle : Icons.cancel,
                  color: analyst ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyItem({
    required String name,
    required String createdDate,
    required String lastUsed,
  }) {
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
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Implement view API key
                    },
                    child: const Text('View'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: Implement revoke API key
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Revoke'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                createdDate,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                lastUsed,
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

  Widget _buildIntegrationItem({
    required String title,
    required String subtitle,
    required String status,
    required bool isConnected,
  }) {
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
              color: isConnected ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isConnected ? Icons.link : Icons.link_off,
              color: isConnected ? Colors.green : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isConnected ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              isConnected ? Icons.settings : Icons.add_circle_outline,
            ),
            onPressed: () {
              // TODO: Implement settings or connect
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWebhookItem({
    required String name,
    required String url,
    required List<String> events,
    required bool isActive,
  }) {
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
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Switch(
                value: isActive,
                onChanged: (value) {
                  // TODO: Implement toggle webhook
                },
              ),
            ],
          ),
          Text(
            url,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: events
                .map(
                  (event) => Chip(
                    label: Text(
                      event,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // TODO: Implement test webhook
                },
                child: const Text('Test'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // TODO: Implement edit webhook
                },
                child: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // TODO: Implement delete webhook
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusItem({
    required String title,
    required String status,
    required bool isOperational,
    required String details,
  }) {
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
              color: isOperational ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOperational ? Icons.check_circle : Icons.warning,
              color: isOperational ? Colors.green : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  details,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isOperational ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: isOperational ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Implement refresh
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackupItem({
    required String date,
    required String size,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.backup,
              color: Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Size: $size • Type: $type',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.restore, size: 20),
                onPressed: () {
                  // TODO: Implement restore
                },
                tooltip: 'Restore',
              ),
              IconButton(
                icon: const Icon(Icons.download, size: 20),
                onPressed: () {
                  // TODO: Implement download
                },
                tooltip: 'Download',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () {
                  // TODO: Implement delete
                },
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceActionItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonText,
  }) {
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
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              // TODO: Implement action
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildLogTypeItem({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
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
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              // TODO: Implement view logs
            },
            child: const Text('View'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              // TODO: Implement download logs
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogEntryItem({
    required String level,
    required String message,
    required String timestamp,
  }) {
    Color levelColor;
    if (level == 'ERROR') {
      levelColor = Colors.red;
    } else if (level == 'WARN') {
      levelColor = Colors.orange;
    } else if (level == 'INFO') {
      levelColor = Colors.blue;
    } else {
      levelColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: levelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  level,
                  style: TextStyle(
                    color: levelColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                timestamp,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
