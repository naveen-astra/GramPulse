import 'package:flutter/material.dart';

class AdminControlRoomScreen extends StatelessWidget {
  const AdminControlRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Room'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh data
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusOverview(),
            const SizedBox(height: 24),
            _buildActiveAlerts(),
            const SizedBox(height: 24),
            _buildResourceAllocation(),
            const SizedBox(height: 24),
            _buildKeyPerformanceMetrics(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create new broadcast or alert
        },
        child: const Icon(Icons.add_alert),
        tooltip: 'Create Alert',
      ),
    );
  }

  Widget _buildStatusOverview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'System Status Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('LIVE'),
                  backgroundColor: Colors.green,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusItem(
                  title: 'System',
                  status: 'Online',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                _buildStatusItem(
                  title: 'Alerts',
                  status: '3 Active',
                  icon: Icons.warning,
                  color: Colors.orange,
                ),
                _buildStatusItem(
                  title: 'Resources',
                  status: '85% Available',
                  icon: Icons.battery_charging_full,
                  color: Colors.blue,
                ),
                _buildStatusItem(
                  title: 'Network',
                  status: 'Strong',
                  icon: Icons.wifi,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Last Updated: ${DateTime.now().hour}:${DateTime.now().minute}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required String title,
    required String status,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          status,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveAlerts() {
    final alerts = [
      {
        'level': 'Critical',
        'title': 'Water Supply Disruption',
        'location': 'Northern Sector, Block 5',
        'time': '30 minutes ago',
        'color': Colors.red,
        'icon': Icons.water_drop,
      },
      {
        'level': 'Moderate',
        'title': 'Power Outage',
        'location': 'Eastern Sector, Near School',
        'time': '1 hour ago',
        'color': Colors.orange,
        'icon': Icons.power,
      },
      {
        'level': 'Low',
        'title': 'Road Maintenance',
        'location': 'Market Area',
        'time': '3 hours ago',
        'color': Colors.yellow[700],
        'icon': Icons.construction,
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
                  'Active Alerts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text('History'),
                  onPressed: () {
                    // TODO: Navigate to alert history
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...alerts.map((alert) => _buildAlertItem(alert)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertItem(Map<String, dynamic> alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (alert['color'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (alert['color'] as Color).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (alert['color'] as Color).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              alert['icon'] as IconData,
              color: alert['color'] as Color,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (alert['color'] as Color),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        alert['level'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      alert['time'] as String,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  alert['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert['location'] as String,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () {
                  // TODO: View alert details
                },
                tooltip: 'View Details',
              ),
              IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  // TODO: Mark as resolved
                },
                tooltip: 'Mark as Resolved',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResourceAllocation() {
    final resources = [
      {
        'name': 'Water Tankers',
        'allocated': 12,
        'available': 5,
        'icon': Icons.local_shipping,
        'color': Colors.blue,
      },
      {
        'name': 'Maintenance Teams',
        'allocated': 8,
        'available': 2,
        'icon': Icons.engineering,
        'color': Colors.orange,
      },
      {
        'name': 'Medical Units',
        'allocated': 6,
        'available': 4,
        'icon': Icons.medical_services,
        'color': Colors.red,
      },
      {
        'name': 'Power Generators',
        'allocated': 10,
        'available': 3,
        'icon': Icons.power,
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
                  'Resource Allocation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to resource management
                  },
                  child: const Text('Manage'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...resources.map((resource) => _buildResourceItem(resource)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(Map<String, dynamic> resource) {
    final total = (resource['allocated'] as int) + (resource['available'] as int);
    final usedPercentage = (resource['allocated'] as int) / total;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (resource['color'] as Color).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              resource['icon'] as IconData,
              color: resource['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: usedPercentage,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(resource['color'] as Color),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Allocated: ${resource['allocated']}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Available: ${resource['available']}',
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
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              // TODO: Allocate more resources
            },
            tooltip: 'Allocate Resources',
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPerformanceMetrics() {
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
                  'Key Performance Metrics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'Today',
                  items: ['Today', 'This Week', 'This Month', 'This Quarter']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    // TODO: Handle dropdown selection
                  },
                  underline: Container(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricCard(
                  value: '87%',
                  label: 'Issue Resolution',
                  trend: '+4%',
                  isPositive: true,
                ),
                _buildMetricCard(
                  value: '2.3 hrs',
                  label: 'Avg Response Time',
                  trend: '-15min',
                  isPositive: true,
                ),
                _buildMetricCard(
                  value: '94%',
                  label: 'System Uptime',
                  trend: '+1%',
                  isPositive: true,
                ),
                _buildMetricCard(
                  value: '78%',
                  label: 'Resource Utilization',
                  trend: '+5%',
                  isPositive: false,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Placeholder for chart
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Performance Trend Chart',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String value,
    required String label,
    required String trend,
    required bool isPositive,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            Icon(
              isPositive ? Icons.arrow_upward : Icons.arrow_downward,
              color: isPositive ? Colors.green : Colors.red,
              size: 12,
            ),
            Text(
              trend,
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
