import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ControlRoomScreen extends StatelessWidget {
  const ControlRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Room'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusOverview(),
            const SizedBox(height: 24),
            _buildEmergencyAlerts(),
            const SizedBox(height: 24),
            _buildReportsTrend(),
            const SizedBox(height: 24),
            _buildDepartmentStatus(),
            const SizedBox(height: 24),
            _buildRecentActivities(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Status Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatusItem(
                  icon: Icons.report_problem,
                  color: Colors.red,
                  title: 'Critical Issues',
                  count: '3',
                ),
                _buildStatusItem(
                  icon: Icons.warning,
                  color: Colors.orange,
                  title: 'Warnings',
                  count: '12',
                ),
                _buildStatusItem(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  title: 'All Clear',
                  count: '85%',
                ),
                _buildStatusItem(
                  icon: Icons.people,
                  color: Colors.blue,
                  title: 'Active Users',
                  count: '483',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required Color color,
    required String title,
    required String count,
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
            size: 28,
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
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyAlerts() {
    final alerts = [
      {
        'title': 'Flood Warning',
        'location': 'Lower Krishna River Basin',
        'time': '2 hours ago',
        'level': 'High',
        'color': Colors.red,
      },
      {
        'title': 'Power Outage',
        'location': 'Ambedkar Nagar, Sectors 3-5',
        'time': '4 hours ago',
        'level': 'Medium',
        'color': Colors.orange,
      },
      {
        'title': 'Road Blockage',
        'location': 'Highway NH-7, KM 56-58',
        'time': '6 hours ago',
        'level': 'Low',
        'color': Colors.yellow,
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
                  'Emergency Alerts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: View all alerts
                  },
                  icon: const Icon(Icons.notifications),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
          color: (alert['color'] as Color).withOpacity(0.3),
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
              Icons.warning,
              color: alert['color'] as Color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  alert['location'] as String,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${alert['level']} priority • ${alert['time']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  // TODO: Navigate to details
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTrend() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reports Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value >= 0 && value < titles.length) {
                            return Text(titles[value.toInt()]);
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 50,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 15),
                        FlSpot(1, 20),
                        FlSpot(2, 25),
                        FlSpot(3, 40),
                        FlSpot(4, 35),
                        FlSpot(5, 28),
                        FlSpot(6, 32),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReportTypeItem(
                  title: 'Infrastructure',
                  count: '128',
                  color: Colors.blue,
                ),
                _buildReportTypeItem(
                  title: 'Sanitation',
                  count: '86',
                  color: Colors.green,
                ),
                _buildReportTypeItem(
                  title: 'Public Safety',
                  count: '52',
                  color: Colors.orange,
                ),
                _buildReportTypeItem(
                  title: 'Others',
                  count: '24',
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeItem({
    required String title,
    required String count,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
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

  Widget _buildDepartmentStatus() {
    final departments = [
      {
        'name': 'Water Department',
        'activeReports': 28,
        'resolvedToday': 12,
        'performance': 0.75,
      },
      {
        'name': 'Electricity Department',
        'activeReports': 16,
        'resolvedToday': 9,
        'performance': 0.85,
      },
      {
        'name': 'Roads & Infrastructure',
        'activeReports': 45,
        'resolvedToday': 8,
        'performance': 0.62,
      },
      {
        'name': 'Sanitation',
        'activeReports': 32,
        'resolvedToday': 14,
        'performance': 0.78,
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
            const Text(
              'Department Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...departments.map((dept) => _buildDepartmentItem(dept)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentItem(Map<String, dynamic> dept) {
    final performance = dept['performance'] as double;
    final color = performance >= 0.8
        ? Colors.green
        : performance >= 0.7
            ? Colors.blue
            : performance >= 0.6
                ? Colors.orange
                : Colors.red;

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
                dept['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${(performance * 100).toInt()}% Efficient',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDepartmentStat(
                label: 'Active Reports',
                value: dept['activeReports'].toString(),
              ),
              _buildDepartmentStat(
                label: 'Resolved Today',
                value: dept['resolvedToday'].toString(),
              ),
              OutlinedButton(
                onPressed: () {
                  // TODO: View department details
                },
                child: const Text('Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentStat({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
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

  Widget _buildRecentActivities() {
    final activities = [
      {
        'user': 'Sanjay Kumar (Water Dept)',
        'action': 'Resolved water leakage report #2834',
        'time': '10 minutes ago',
      },
      {
        'user': 'Priya Sharma (Admin)',
        'action': 'Assigned 5 new reports to Electricity Department',
        'time': '32 minutes ago',
      },
      {
        'user': 'Vikram Singh (Roads)',
        'action': 'Updated status of pothole repair to "In Progress"',
        'time': '1 hour ago',
      },
      {
        'user': 'System',
        'action': 'Automated daily report generated',
        'time': '2 hours ago',
      },
      {
        'user': 'Anita Desai (Sanitation)',
        'action': 'Closed 8 garbage collection tickets',
        'time': '3 hours ago',
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
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all activities
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...activities.map((activity) => _buildActivityItem(activity)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: const Icon(
              Icons.person,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['user'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  activity['action'] as String,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  activity['time'] as String,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                // Removing the divider between activities
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
