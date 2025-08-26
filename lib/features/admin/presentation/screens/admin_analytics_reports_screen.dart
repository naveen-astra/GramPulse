import 'package:flutter/material.dart';

class AdminAnalyticsReportsScreen extends StatelessWidget {
  const AdminAnalyticsReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics & Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Performance'),
              Tab(text: 'Reports'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                // TODO: Show date range selector
              },
            ),
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () {
                // TODO: Export report
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(),
            _buildPerformanceTab(),
            _buildReportsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeRangeSelector(),
          const SizedBox(height: 24),
          _buildKeyMetricsGrid(),
          const SizedBox(height: 24),
          _buildTrendsChart(),
          const SizedBox(height: 24),
          _buildRegionalPerformance(),
          const SizedBox(height: 24),
          _buildCitizenSatisfaction(),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: 'Last Quarter',
                  isExpanded: true,
                  items: [
                    'Last 7 Days',
                    'Last Month',
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
            ),
          ),
        ),
        const SizedBox(width: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh data
            },
          ),
        ),
      ],
    );
  }

  Widget _buildKeyMetricsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          title: 'Total Reports',
          value: '3,842',
          trend: '+12%',
          isPositive: true,
          icon: Icons.report_problem,
          color: Colors.orange,
          chartColor: Colors.orange,
        ),
        _buildMetricCard(
          title: 'Resolution Rate',
          value: '78%',
          trend: '+5%',
          isPositive: true,
          icon: Icons.check_circle,
          color: Colors.green,
          chartColor: Colors.green,
        ),
        _buildMetricCard(
          title: 'Avg. Response Time',
          value: '1.8 days',
          trend: '-0.3 days',
          isPositive: true,
          icon: Icons.timer,
          color: Colors.blue,
          chartColor: Colors.blue,
        ),
        _buildMetricCard(
          title: 'Citizen Satisfaction',
          value: '4.3/5',
          trend: '+0.2',
          isPositive: true,
          icon: Icons.star,
          color: Colors.amber,
          chartColor: Colors.amber,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required IconData icon,
    required Color color,
    required Color chartColor,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  trend,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Placeholder for mini chart
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: chartColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.show_chart,
                  color: chartColor.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsChart() {
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
                  'Issue Trends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'Last 6 Months',
                    items: [
                      'Last Month',
                      'Last 3 Months',
                      'Last 6 Months',
                      'This Year',
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
                  'Trends Chart',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildChartLegendItem(color: Colors.blue, label: 'Water Issues'),
                _buildChartLegendItem(color: Colors.green, label: 'Sanitation'),
                _buildChartLegendItem(color: Colors.red, label: 'Power Outages'),
                _buildChartLegendItem(color: Colors.orange, label: 'Road Issues'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegendItem({
    required Color color,
    required String label,
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
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRegionalPerformance() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Regional Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for map chart
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Regional Performance Map',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Top Performing Regions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildRegionItem(
              name: 'North District',
              performance: 92,
              trend: '+4%',
              isPositive: true,
            ),
            _buildRegionItem(
              name: 'Central District',
              performance: 88,
              trend: '+2%',
              isPositive: true,
            ),
            _buildRegionItem(
              name: 'East District',
              performance: 85,
              trend: '+5%',
              isPositive: true,
            ),
            const SizedBox(height: 16),
            const Text(
              'Needs Improvement',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildRegionItem(
              name: 'South District',
              performance: 68,
              trend: '-2%',
              isPositive: false,
            ),
            _buildRegionItem(
              name: 'West District',
              performance: 72,
              trend: '+1%',
              isPositive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionItem({
    required String name,
    required int performance,
    required String trend,
    required bool isPositive,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(name),
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: performance / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getPerformanceColor(performance)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '$performance%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _getPerformanceColor(performance),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: isPositive ? Colors.green : Colors.red,
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
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(int performance) {
    if (performance >= 90) {
      return Colors.green;
    } else if (performance >= 80) {
      return Colors.blue;
    } else if (performance >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildCitizenSatisfaction() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Citizen Satisfaction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      '4.3',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        Icon(Icons.star_half, color: Colors.amber, size: 20),
                      ],
                    ),
                    Text(
                      'Based on 1,832 ratings',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildRatingBar(label: '5 Stars', percent: 0.52),
            _buildRatingBar(label: '4 Stars', percent: 0.32),
            _buildRatingBar(label: '3 Stars', percent: 0.10),
            _buildRatingBar(label: '2 Stars', percent: 0.04),
            _buildRatingBar(label: '1 Star', percent: 0.02),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Compared to last period: +0.2',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      size: 14,
                      color: Colors.green,
                    ),
                    Text(
                      '+4.8%',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar({
    required String label,
    required double percent,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percent * 100).toInt()}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDepartmentSelector(),
          const SizedBox(height: 24),
          _buildDepartmentPerformanceOverview(),
          const SizedBox(height: 24),
          _buildResourceUtilization(),
          const SizedBox(height: 24),
          _buildIssueResolutionMetrics(),
          const SizedBox(height: 24),
          _buildEmployeePerformance(),
        ],
      ),
    );
  }

  Widget _buildDepartmentSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: 'All Departments',
            isExpanded: true,
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
      ),
    );
  }

  Widget _buildDepartmentPerformanceOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for radar chart
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Performance Radar Chart',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPerformanceDimension(
                  dimension: 'Efficiency',
                  score: 87,
                  icon: Icons.speed,
                  color: Colors.blue,
                ),
                _buildPerformanceDimension(
                  dimension: 'Quality',
                  score: 92,
                  icon: Icons.high_quality,
                  color: Colors.green,
                ),
                _buildPerformanceDimension(
                  dimension: 'Timeliness',
                  score: 78,
                  icon: Icons.timer,
                  color: Colors.orange,
                ),
                _buildPerformanceDimension(
                  dimension: 'Satisfaction',
                  score: 85,
                  icon: Icons.sentiment_satisfied_alt,
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceDimension({
    required String dimension,
    required int score,
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
          '$score%',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          dimension,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceUtilization() {
    final resources = [
      {
        'name': 'Budget Utilization',
        'current': 65,
        'target': 75,
        'color': Colors.blue,
      },
      {
        'name': 'Human Resources',
        'current': 92,
        'target': 90,
        'color': Colors.orange,
      },
      {
        'name': 'Equipment Usage',
        'current': 78,
        'target': 85,
        'color': Colors.green,
      },
      {
        'name': 'Time Efficiency',
        'current': 82,
        'target': 80,
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
            const Text(
              'Resource Utilization',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...resources.map((resource) => _buildResourceItem(resource)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(Map<String, dynamic> resource) {
    final current = resource['current'] as int;
    final target = resource['target'] as int;
    final color = resource['color'] as Color;
    final isAtOrAboveTarget = current >= target;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resource['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '$current%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const Text(' vs '),
                  Text(
                    'Target $target%',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isAtOrAboveTarget ? Icons.check_circle : Icons.warning,
                    color: isAtOrAboveTarget ? Colors.green : Colors.orange,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 8,
                width: (current / 100) * double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Positioned(
                left: (target / 100) * double.infinity - 1,
                child: Container(
                  height: 16,
                  width: 2,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIssueResolutionMetrics() {
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
                  'Issue Resolution Metrics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'This Quarter',
                    items: [
                      'This Month',
                      'This Quarter',
                      'This Year',
                      'All Time',
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
                  'Issue Resolution Timeline Chart',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResolutionStat(
                  label: 'Avg. Resolution Time',
                  value: '3.2 days',
                  trend: '-8%',
                  isPositive: true,
                ),
                _buildResolutionStat(
                  label: 'First Response',
                  value: '6.5 hours',
                  trend: '-12%',
                  isPositive: true,
                ),
                _buildResolutionStat(
                  label: 'Resolution Rate',
                  value: '92%',
                  trend: '+4%',
                  isPositive: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionStat({
    required String label,
    required String value,
    required String trend,
    required bool isPositive,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
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
              size: 12,
              color: isPositive ? Colors.green : Colors.red,
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

  Widget _buildEmployeePerformance() {
    final employees = [
      {
        'name': 'Rajesh Kumar',
        'role': 'Water Supply Officer',
        'performance': 95,
        'trend': '+3%',
        'isPositive': true,
      },
      {
        'name': 'Sunita Devi',
        'role': 'Sanitation Manager',
        'performance': 92,
        'trend': '+5%',
        'isPositive': true,
      },
      {
        'name': 'Vikram Singh',
        'role': 'Infrastructure Engineer',
        'performance': 88,
        'trend': '-2%',
        'isPositive': false,
      },
      {
        'name': 'Priya Sharma',
        'role': 'Healthcare Coordinator',
        'performance': 90,
        'trend': '+1%',
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
                  'Top Performers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all employees
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...employees.map((employee) => _buildEmployeeItem(employee)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeItem(Map<String, dynamic> employee) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            child: Text(
              employee['name'].toString().substring(0, 1),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  employee['role'] as String,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _getPerformanceColor(employee['performance'] as int).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${employee['performance']}%',
              style: TextStyle(
                color: _getPerformanceColor(employee['performance'] as int),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(
                    (employee['isPositive'] as bool) ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: (employee['isPositive'] as bool) ? Colors.green : Colors.red,
                  ),
                  Text(
                    employee['trend'] as String,
                    style: TextStyle(
                      color: (employee['isPositive'] as bool) ? Colors.green : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                'vs last quarter',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    final reports = [
      {
        'name': 'Monthly Performance Summary',
        'date': 'August 15, 2025',
        'type': 'Performance',
        'icon': Icons.bar_chart,
        'color': Colors.blue,
      },
      {
        'name': 'Issue Resolution Report',
        'date': 'August 10, 2025',
        'type': 'Issues',
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'name': 'Budget Allocation & Spending',
        'date': 'August 5, 2025',
        'type': 'Finance',
        'icon': Icons.account_balance,
        'color': Colors.purple,
      },
      {
        'name': 'Citizen Satisfaction Survey Results',
        'date': 'July 28, 2025',
        'type': 'Feedback',
        'icon': Icons.people,
        'color': Colors.orange,
      },
      {
        'name': 'Infrastructure Maintenance Status',
        'date': 'July 20, 2025',
        'type': 'Infrastructure',
        'icon': Icons.build,
        'color': Colors.amber,
      },
      {
        'name': 'Resource Utilization Analysis',
        'date': 'July 15, 2025',
        'type': 'Resources',
        'icon': Icons.assessment,
        'color': Colors.teal,
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search reports',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildReportCategory(
                title: 'Available Reports',
                reports: reports,
              ),
              const SizedBox(height: 24),
              _buildReportCategory(
                title: 'Scheduled Reports',
                reports: [
                  {
                    'name': 'Weekly Performance Update',
                    'date': 'Every Monday',
                    'type': 'Automated',
                    'icon': Icons.update,
                    'color': Colors.indigo,
                  },
                  {
                    'name': 'Monthly Budget Overview',
                    'date': '1st of Every Month',
                    'type': 'Automated',
                    'icon': Icons.calendar_today,
                    'color': Colors.red,
                  },
                ],
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Create Custom Report',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select data sources, time periods, and parameters to generate a custom report for your specific needs.',
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Create custom report
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create New Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportCategory({
    required String title,
    required List<Map<String, dynamic>> reports,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...reports.map((report) => _buildReportItem(report)).toList(),
      ],
    );
  }

  Widget _buildReportItem(Map<String, dynamic> report) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (report['color'] as Color).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            report['icon'] as IconData,
            color: report['color'] as Color,
          ),
        ),
        title: Text(
          report['name'] as String,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${report['date']} • ${report['type']}',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                // TODO: View report
              },
              tooltip: 'View',
            ),
            IconButton(
              icon: const Icon(Icons.file_download),
              onPressed: () {
                // TODO: Download report
              },
              tooltip: 'Download',
            ),
          ],
        ),
      ),
    );
  }
}
