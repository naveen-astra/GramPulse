import 'package:flutter/material.dart';

class AdminDepartmentPerformanceScreen extends StatelessWidget {
  const AdminDepartmentPerformanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Performance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Show date range selector
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filters
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDepartmentFilters(),
            const SizedBox(height: 24),
            _buildPerformanceOverview(),
            const SizedBox(height: 24),
            _buildDepartmentComparison(),
            const SizedBox(height: 24),
            _buildTopPerformers(),
            const SizedBox(height: 24),
            _buildIssueBreakdown(),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentFilters() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Department',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            value: 'All Departments',
            items: [
              'All Departments',
              'Water Supply',
              'Sanitation',
              'Power & Electricity',
              'Roads & Infrastructure',
              'Healthcare',
              'Education',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              // TODO: Handle department selection
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Time Period',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            value: 'Last Quarter',
            items: [
              'This Week',
              'This Month',
              'Last Quarter',
              'Last 6 Months',
              'This Year',
              'Custom Range',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              // TODO: Handle time period selection
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPerformanceScore(
                  title: 'Response Rate',
                  score: '87%',
                  subtitle: '+4% from last period',
                  icon: Icons.speed,
                  color: Colors.green,
                ),
                _buildPerformanceScore(
                  title: 'Resolution Rate',
                  score: '76%',
                  subtitle: '+2% from last period',
                  icon: Icons.check_circle,
                  color: Colors.blue,
                ),
                _buildPerformanceScore(
                  title: 'Satisfaction',
                  score: '4.2/5',
                  subtitle: '+0.3 from last period',
                  icon: Icons.star,
                  color: Colors.amber,
                ),
                _buildPerformanceScore(
                  title: 'Budget Utilization',
                  score: '92%',
                  subtitle: '+7% from last period',
                  icon: Icons.account_balance,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Performance Trend',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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

  Widget _buildPerformanceScore({
    required String title,
    required String score,
    required String subtitle,
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
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentComparison() {
    final departments = [
      {
        'name': 'Water Supply',
        'performance': 0.92,
        'trend': '+5%',
        'isPositive': true,
      },
      {
        'name': 'Sanitation',
        'performance': 0.88,
        'trend': '+3%',
        'isPositive': true,
      },
      {
        'name': 'Power & Electricity',
        'performance': 0.75,
        'trend': '-2%',
        'isPositive': false,
      },
      {
        'name': 'Roads & Infrastructure',
        'performance': 0.82,
        'trend': '+7%',
        'isPositive': true,
      },
      {
        'name': 'Healthcare',
        'performance': 0.90,
        'trend': '+1%',
        'isPositive': true,
      },
      {
        'name': 'Education',
        'performance': 0.85,
        'trend': '0%',
        'isPositive': true,
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
                  'Department Comparison',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to detailed comparison
                  },
                  child: const Text('Detailed View'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...departments.map((dept) => _buildDepartmentItem(dept)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentItem(Map<String, dynamic> dept) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              dept['name'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: dept['performance'] as double,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getPerformanceColor(dept['performance'] as double),
              ),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: Text(
              '${((dept['performance'] as double) * 100).toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getPerformanceColor(dept['performance'] as double),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Row(
              children: [
                Icon(
                  (dept['isPositive'] as bool)
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 12,
                  color: (dept['isPositive'] as bool) ? Colors.green : Colors.red,
                ),
                Text(
                  dept['trend'] as String,
                  style: TextStyle(
                    color: (dept['isPositive'] as bool) ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(double performance) {
    if (performance >= 0.9) {
      return Colors.green;
    } else if (performance >= 0.8) {
      return Colors.blue;
    } else if (performance >= 0.7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildTopPerformers() {
    final performers = [
      {
        'name': 'Amit Kumar',
        'department': 'Water Supply',
        'role': 'Senior Officer',
        'performance': 98,
        'image': 'https://randomuser.me/api/portraits/men/32.jpg',
      },
      {
        'name': 'Priya Singh',
        'department': 'Healthcare',
        'role': 'Coordinator',
        'performance': 96,
        'image': 'https://randomuser.me/api/portraits/women/44.jpg',
      },
      {
        'name': 'Rajesh Sharma',
        'department': 'Roads & Infrastructure',
        'role': 'Project Manager',
        'performance': 95,
        'image': 'https://randomuser.me/api/portraits/men/59.jpg',
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
                  'Top Performers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all performers
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...performers.map((performer) => _buildPerformerItem(performer)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformerItem(Map<String, dynamic> performer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(performer['image'] as String),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  performer['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${performer['role']} - ${performer['department']}',
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
              color: Colors.green,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${performer['performance']}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueBreakdown() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Issue Breakdown by Department',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for chart
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Issue Distribution Chart',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(color: Colors.blue, label: 'Water Supply', value: '32%'),
                _buildLegendItem(color: Colors.green, label: 'Sanitation', value: '18%'),
                _buildLegendItem(color: Colors.red, label: 'Power', value: '25%'),
                _buildLegendItem(color: Colors.orange, label: 'Roads', value: '15%'),
                _buildLegendItem(color: Colors.purple, label: 'Other', value: '10%'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Critical Issues by Department',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildCriticalIssueItem(
              department: 'Water Supply',
              issueCount: 12,
              resolvedCount: 8,
              color: Colors.blue,
            ),
            _buildCriticalIssueItem(
              department: 'Power & Electricity',
              issueCount: 9,
              resolvedCount: 4,
              color: Colors.red,
            ),
            _buildCriticalIssueItem(
              department: 'Roads & Infrastructure',
              issueCount: 5,
              resolvedCount: 3,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCriticalIssueItem({
    required String department,
    required int issueCount,
    required int resolvedCount,
    required Color color,
  }) {
    final percentage = (resolvedCount / issueCount) * 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(department),
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: resolvedCount / issueCount,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              '$resolvedCount of $issueCount (${percentage.toInt()}%)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
