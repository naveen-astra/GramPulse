import 'package:flutter/material.dart';

enum NotificationType { verification, shg, feedback, reminder, general, urgent }
enum Priority { high, medium, low }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Priority priority;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.priority,
    this.actionUrl,
    this.metadata,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'New Verification Request',
      message: 'A road repair issue needs verification in Sector 5',
      type: NotificationType.verification,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isRead: false,
      priority: Priority.high,
    ),
    NotificationItem(
      id: '2',
      title: 'SHG Application Approved',
      message: 'Mahila Shakti Samuh loan application has been approved',
      type: NotificationType.shg,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      priority: Priority.medium,
    ),
    NotificationItem(
      id: '3',
      title: 'Citizen Feedback',
      message: 'You received a 5-star rating for your assistance',
      type: NotificationType.feedback,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
      priority: Priority.low,
    ),
    NotificationItem(
      id: '4',
      title: 'Training Session Reminder',
      message: 'Community training session starts in 30 minutes',
      type: NotificationType.reminder,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      isRead: false,
      priority: Priority.high,
    ),
    NotificationItem(
      id: '5',
      title: 'Document Verification Complete',
      message: 'Aadhaar verification for Ramesh Kumar has been completed',
      type: NotificationType.verification,
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: true,
      priority: Priority.medium,
    ),
    NotificationItem(
      id: '6',
      title: 'Urgent: Flood Alert',
      message: 'Heavy rainfall warning issued for your area. Check emergency protocols.',
      type: NotificationType.urgent,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      priority: Priority.high,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: Row(
          children: [
            const Text('Notifications'),
            const SizedBox(width: 8),
            _getUnreadCount() > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_getUnreadCount()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  _showNotificationSettings();
                  break;
                case 'clear':
                  _clearAllNotifications();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 8),
                    Text('Notification Settings'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.clear_all),
                    SizedBox(width: 8),
                    Text('Clear All'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.all_inbox, size: 18),
                  const SizedBox(width: 4),
                  const Text('All'),
                  if (_getUnreadCount() > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_getUnreadCount()}',
                        style: const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.priority_high, size: 18),
                  SizedBox(width: 4),
                  Text('Priority'),
                ],
              ),
            ),
            const Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.done_all, size: 18),
                  SizedBox(width: 4),
                  Text('Read'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(notifications),
          _buildNotificationsList(_getPriorityNotifications()),
          _buildNotificationsList(_getReadNotifications()),
        ],
      ),
    );
  }

  int _getUnreadCount() {
    return notifications.where((n) => !n.isRead).length;
  }

  List<NotificationItem> _getPriorityNotifications() {
    return notifications.where((n) => n.priority == Priority.high).toList();
  }

  List<NotificationItem> _getReadNotifications() {
    return notifications.where((n) => n.isRead).toList();
  }

  Widget _buildNotificationsList(List<NotificationItem> notificationList) {
    if (notificationList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No notifications found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          // Add new notification for demo
          notifications.insert(
            0,
            NotificationItem(
              id: 'new_${DateTime.now().millisecondsSinceEpoch}',
              title: 'New Issue Reported',
              message: 'Water supply issue reported in your area',
              type: NotificationType.verification,
              timestamp: DateTime.now(),
              isRead: false,
              priority: Priority.medium,
            ),
          );
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notificationList.length,
        itemBuilder: (context, index) {
          final notification = notificationList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildNotificationCard(notification),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    IconData typeIcon;
    Color typeColor;
    
    switch (notification.type) {
      case NotificationType.verification:
        typeIcon = Icons.verified_outlined;
        typeColor = Colors.blue;
        break;
      case NotificationType.shg:
        typeIcon = Icons.group;
        typeColor = Colors.green;
        break;
      case NotificationType.feedback:
        typeIcon = Icons.star_outline;
        typeColor = Colors.orange;
        break;
      case NotificationType.reminder:
        typeIcon = Icons.schedule;
        typeColor = Colors.purple;
        break;
      case NotificationType.urgent:
        typeIcon = Icons.warning_outlined;
        typeColor = Colors.red;
        break;
      default:
        typeIcon = Icons.info_outline;
        typeColor = Colors.grey;
    }

    return Card(
      elevation: notification.isRead ? 1 : 3,
      color: notification.isRead ? Colors.grey.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: notification.priority == Priority.high && !notification.isRead
            ? BorderSide(color: Colors.red.shade300, width: 1)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  typeIcon,
                  color: typeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (notification.priority == Priority.high)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'HIGH',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getTimeAgo(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'read':
                      _markAsRead(notification.id);
                      break;
                    case 'delete':
                      _deleteNotification(notification.id);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (!notification.isRead)
                    const PopupMenuItem(
                      value: 'read',
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 18),
                          SizedBox(width: 8),
                          Text('Mark as read'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
                child: const Icon(Icons.more_vert, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    if (!notification.isRead) {
      _markAsRead(notification.id);
    }
    
    // Show detailed notification view
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${notification.timestamp.day}/${notification.timestamp.month}/${notification.timestamp.year} at ${notification.timestamp.hour}:${notification.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  notification.type.name.toUpperCase(),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (notification.type == NotificationType.verification)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to verification screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening verification queue...')),
                );
              },
              child: const Text('Take Action'),
            ),
        ],
      ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        notifications[index] = NotificationItem(
          id: notifications[index].id,
          title: notifications[index].title,
          message: notifications[index].message,
          type: notifications[index].type,
          timestamp: notifications[index].timestamp,
          isRead: true,
          priority: notifications[index].priority,
          actionUrl: notifications[index].actionUrl,
          metadata: notifications[index].metadata,
        );
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      notifications = notifications.map((n) => NotificationItem(
        id: n.id,
        title: n.title,
        message: n.message,
        type: n.type,
        timestamp: n.timestamp,
        isRead: true,
        priority: n.priority,
        actionUrl: n.actionUrl,
        metadata: n.metadata,
      )).toList();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification deleted')),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Verification Requests'),
                subtitle: const Text('Get notified about new verification requests'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('SHG Updates'),
                subtitle: const Text('Updates about SHG applications and meetings'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Citizen Feedback'),
                subtitle: const Text('Ratings and feedback from citizens'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Training Reminders'),
                subtitle: const Text('Upcoming training sessions and workshops'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Urgent Alerts'),
                subtitle: const Text('Emergency and urgent notifications'),
                value: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const Text(
                'Sound & Vibration',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text('Sound'),
                value: true,
                onChanged: (value) {},
              ),
              SwitchListTile(
                title: const Text('Vibration'),
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead 
                ? Colors.grey.shade200 
                : Colors.blue.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Priority indicator
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(notification.priority),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Notification icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(notification.type),
                      color: _getTypeColor(notification.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontWeight: notification.isRead 
                                      ? FontWeight.w500 
                                      : FontWeight.bold,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.verification:
        return Colors.orange;
      case NotificationType.shg:
        return Colors.purple;
      case NotificationType.feedback:
        return Colors.green;
      case NotificationType.reminder:
        return Colors.blue;
      case NotificationType.update:
        return Colors.indigo;
      case NotificationType.assistance:
        return Colors.teal;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.verification:
        return Icons.verified;
      case NotificationType.shg:
        return Icons.group;
      case NotificationType.feedback:
        return Icons.star;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.update:
        return Icons.update;
      case NotificationType.assistance:
        return Icons.help;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettings extends StatefulWidget {
  const _NotificationSettings();

  @override
  State<_NotificationSettings> createState() => __NotificationSettingsState();
}

class __NotificationSettingsState extends State<_NotificationSettings> {
  bool verificationsEnabled = true;
  bool shgUpdatesEnabled = true;
  bool feedbackEnabled = true;
  bool remindersEnabled = true;
  bool assistanceRequestsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          _SettingTile(
            title: 'Verification Requests',
            subtitle: 'Get notified about new verification tasks',
            value: verificationsEnabled,
            onChanged: (value) => setState(() => verificationsEnabled = value),
          ),
          
          _SettingTile(
            title: 'SHG Updates',
            subtitle: 'Updates about SHG applications and activities',
            value: shgUpdatesEnabled,
            onChanged: (value) => setState(() => shgUpdatesEnabled = value),
          ),
          
          _SettingTile(
            title: 'Citizen Feedback',
            subtitle: 'Ratings and feedback from citizens',
            value: feedbackEnabled,
            onChanged: (value) => setState(() => feedbackEnabled = value),
          ),
          
          _SettingTile(
            title: 'Reminders',
            subtitle: 'Training sessions and scheduled activities',
            value: remindersEnabled,
            onChanged: (value) => setState(() => remindersEnabled = value),
          ),
          
          _SettingTile(
            title: 'Assistance Requests',
            subtitle: 'New requests for citizen assistance',
            value: assistanceRequestsEnabled,
            onChanged: (value) => setState(() => assistanceRequestsEnabled = value),
          ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save Settings'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.indigo.shade600,
          ),
        ],
      ),
    );
  }
}

// Data models
enum NotificationType {
  verification,
  shg,
  feedback,
  reminder,
  update,
  assistance,
}

enum Priority {
  high,
  medium,
  low,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Priority priority;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.priority,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    Priority? priority,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      priority: priority ?? this.priority,
    );
  }
}
