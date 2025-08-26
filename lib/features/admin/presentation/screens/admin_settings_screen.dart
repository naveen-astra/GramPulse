import 'package:flutter/material.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralSettings(),
            const SizedBox(height: 24),
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            _buildSecuritySettings(),
            const SizedBox(height: 24),
            _buildBackupSettings(),
            const SizedBox(height: 24),
            _buildAdvancedSettings(),
            const SizedBox(height: 24),
            _buildSystemMaintenance(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return _buildSettingsSection(
      title: 'General Settings',
      icon: Icons.settings,
      children: [
        _buildSettingItem(
          title: 'Application Name',
          subtitle: 'GramPulse',
          trailing: const Icon(Icons.edit),
          onTap: () {
            // TODO: Edit application name
          },
        ),
        _buildSettingItem(
          title: 'System Language',
          subtitle: 'English',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Change system language
          },
        ),
        _buildSettingItem(
          title: 'Default Region',
          subtitle: 'North District',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Change default region
          },
        ),
        _buildSwitchSettingItem(
          title: 'Enable Public Access',
          subtitle: 'Allow access to public data without login',
          value: true,
          onChanged: (value) {
            // TODO: Handle toggle
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsSection(
      title: 'Notification Settings',
      icon: Icons.notifications,
      children: [
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
          title: 'Notification Templates',
          subtitle: 'Manage notification message templates',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Navigate to notification templates
          },
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return _buildSettingsSection(
      title: 'Security Settings',
      icon: Icons.security,
      children: [
        _buildSettingItem(
          title: 'Password Policy',
          subtitle: 'Require strong passwords (8+ chars, special chars)',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Edit password policy
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
        _buildSwitchSettingItem(
          title: 'Account Lockout',
          subtitle: 'Lock account after 5 failed attempts',
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
            // TODO: Edit session timeout
          },
        ),
      ],
    );
  }

  Widget _buildBackupSettings() {
    return _buildSettingsSection(
      title: 'Backup & Data',
      icon: Icons.backup,
      children: [
        _buildSettingItem(
          title: 'Automatic Backups',
          subtitle: 'Daily at 2:00 AM',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Edit backup schedule
          },
        ),
        _buildSettingItem(
          title: 'Backup Storage',
          subtitle: 'Cloud Storage (3 copies)',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Edit backup storage
          },
        ),
        _buildSettingItem(
          title: 'Data Retention Policy',
          subtitle: 'Keep data for 3 years',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Edit data retention policy
          },
        ),
        _buildActionItem(
          title: 'Create Manual Backup',
          icon: Icons.download,
          color: Colors.blue,
          onTap: () {
            // TODO: Create manual backup
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return _buildSettingsSection(
      title: 'Advanced Settings',
      icon: Icons.code,
      children: [
        _buildSettingItem(
          title: 'API Access',
          subtitle: 'Configure API keys and permissions',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Configure API access
          },
        ),
        _buildSettingItem(
          title: 'Logging Level',
          subtitle: 'Information',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Configure logging level
          },
        ),
        _buildSwitchSettingItem(
          title: 'Debug Mode',
          subtitle: 'Enable detailed logging for troubleshooting',
          value: false,
          onChanged: (value) {
            // TODO: Handle toggle
          },
        ),
        _buildSettingItem(
          title: 'Integration Settings',
          subtitle: 'Configure third-party integrations',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Configure integrations
          },
        ),
      ],
    );
  }

  Widget _buildSystemMaintenance() {
    return _buildSettingsSection(
      title: 'System Maintenance',
      icon: Icons.build,
      children: [
        _buildActionItem(
          title: 'Clear System Cache',
          icon: Icons.cleaning_services,
          color: Colors.orange,
          onTap: () {
            // TODO: Clear system cache
          },
        ),
        _buildActionItem(
          title: 'Rebuild Indexes',
          icon: Icons.refresh,
          color: Colors.green,
          onTap: () {
            // TODO: Rebuild indexes
          },
        ),
        _buildActionItem(
          title: 'View System Logs',
          icon: Icons.article,
          color: Colors.blue,
          onTap: () {
            // TODO: View system logs
          },
        ),
        _buildActionItem(
          title: 'Reset System',
          icon: Icons.warning,
          color: Colors.red,
          onTap: () {
            // TODO: Show reset system dialog
          },
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: children,
          ),
        ),
      ],
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

  Widget _buildActionItem({
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
