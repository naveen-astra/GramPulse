import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsReportsScreen extends StatelessWidget {
  const AnalyticsReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnalyticsTabs(),
            const SizedBox(height: 24),
            _buildReportOverview(),
            const SizedBox(height: 24),
            _buildCitizenEngagement(),
            const SizedBox(height: 24),
            _buildResolutionTrends(),
            const SizedBox(height: 24),
            _buildGeographicalDistribution(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Generate custom report
        },
        icon: const Icon(Icons.add_chart),
        label: const Text('Custom Report'),
      ),
    );
  }

  Widget _buildAnalyticsTabs() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsTab(
                    icon: Icons.bug_report,
                    title: 'Issues',
                    primaryStat: '2,842',
                    secondaryStat: '78% Resolved',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnalyticsTab(
                    icon: Icons.people,
                    title: 'Users',
                    primaryStat: '12,654',
                    secondaryStat: '+324 this month',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsTab(
                    icon: Icons.volunteer_activism,
                    title: 'Volunteers',
                    primaryStat: '485',
                    secondaryStat: '68 Active Today',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAnalyticsTab(
                    icon: Icons.analytics,
                    title: 'Insights',
                    primaryStat: '18',
                    secondaryStat: 'New insights available',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab({
    required IconData icon,
    required String title,
    required String primaryStat,
    required String secondaryStat,
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
            primaryStat,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            secondaryStat,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportOverview() {
    final categories = [
      {'name': 'Water Issues', 'count': 824, 'color': Colors.blue},
      {'name': 'Roads & Infrastructure', 'count': 682, 'color': Colors.orange},
      {'name': 'Electricity', 'count': 543, 'color': Colors.yellow},
      {'name': 'Sanitation', 'count': 428, 'color': Colors.green},
      {'name': 'Public Safety', 'count': 365, 'color': Colors.red},
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
                  'Report Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'Last 6 Months',
                  onChanged: (String? newValue) {
                    // TODO: Handle dropdown change
                  },
                  underline: Container(),
                  items: <String>['Last 6 Months', 'Last 3 Months', 'Last Month', 'Last Week']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1000,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${categories[groupIndex]['name']}: ${rod.toY.round()}',
                          const TextStyle(color: Colors.black),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value >= 0 && value < categories.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                (categories[value.toInt()]['name'] as String).split(' ')[0],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 200 == 0) {
                            return Text('${value.toInt()}');
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: List.generate(
                    categories.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: categories[index]['count'] as double,
                          color: categories[index]['color'] as Color,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 200,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300],
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildCategoryItem(
                  category: 'Total Reports',
                  count: '2,842',
                  trend: '+8%',
                  trendUp: true,
                ),
                _buildCategoryItem(
                  category: 'Resolved',
                  count: '2,215',
                  trend: '+12%',
                  trendUp: true,
                ),
                _buildCategoryItem(
                  category: 'Pending',
                  count: '482',
                  trend: '-4%',
                  trendUp: false,
                ),
                _buildCategoryItem(
                  category: 'Overdue',
                  count: '145',
                  trend: '-2%',
                  trendUp: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required String category,
    required String count,
    required String trend,
    required bool trendUp,
  }) {
    return SizedBox(
      width: 140,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 30,
            decoration: BoxDecoration(
              color: trendUp ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  Text(
                    count,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      color: trendUp ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCitizenEngagement() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Citizen Engagement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 25,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey[300],
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey[300],
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final months = ['Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'];
                                if (value >= 0 && value < months.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(months[value.toInt()]),
                                  );
                                }
                                return const Text('');
                              },
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 25,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        minX: 0,
                        maxX: 5,
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 35),
                              FlSpot(1, 42),
                              FlSpot(2, 48),
                              FlSpot(3, 60),
                              FlSpot(4, 75),
                              FlSpot(5, 85),
                            ],
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: Colors.white,
                                  strokeWidth: 2,
                                  strokeColor: Colors.blue,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEngagementStat(
                      title: 'App Downloads',
                      value: '12,654',
                      trend: '+24%',
                      trendUp: true,
                    ),
                    const SizedBox(height: 16),
                    _buildEngagementStat(
                      title: 'Active Users',
                      value: '8,421',
                      trend: '+18%',
                      trendUp: true,
                    ),
                    const SizedBox(height: 16),
                    _buildEngagementStat(
                      title: 'Reports Filed',
                      value: '2,842',
                      trend: '+32%',
                      trendUp: true,
                    ),
                    const SizedBox(height: 16),
                    _buildEngagementStat(
                      title: 'Engagement Rate',
                      value: '85%',
                      trend: '+12%',
                      trendUp: true,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'User Engagement Breakdown',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildEngagementBreakdown(
                  title: 'By Age Group',
                  data: [
                    {'label': '18-24', 'value': 15},
                    {'label': '25-34', 'value': 32},
                    {'label': '35-44', 'value': 28},
                    {'label': '45-54', 'value': 18},
                    {'label': '55+', 'value': 7},
                  ],
                ),
                const SizedBox(width: 16),
                _buildEngagementBreakdown(
                  title: 'By Activity',
                  data: [
                    {'label': 'Report Issues', 'value': 45},
                    {'label': 'Track Status', 'value': 30},
                    {'label': 'Volunteer', 'value': 15},
                    {'label': 'Community Forums', 'value': 10},
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementStat({
    required String title,
    required String value,
    required String trend,
    required bool trendUp,
  }) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Icon(
                trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                size: 12,
                color: trendUp ? Colors.green : Colors.red,
              ),
              Text(
                trend,
                style: TextStyle(
                  color: trendUp ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                ' vs last period',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementBreakdown({
    required String title,
    required List<Map<String, dynamic>> data,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          ...data.map((item) => _buildBreakdownItem(
                label: item['label'] as String,
                value: item['value'] as int,
              )),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem({
    required String label,
    required int value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '$value%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[200],
            color: Colors.blue,
            minHeight: 4,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionTrends() {
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
                  'Resolution Trends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'Last 6 Months',
                  onChanged: (String? newValue) {
                    // TODO: Handle dropdown change
                  },
                  underline: Container(),
                  items: <String>['Last 6 Months', 'Last 3 Months', 'Last Month', 'Last Week']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: 78,
                            title: '78%',
                            color: Colors.green,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: 17,
                            title: '17%',
                            color: Colors.orange,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: 5,
                            title: '5%',
                            color: Colors.red,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResolutionLegendItem(
                        color: Colors.green,
                        label: 'Resolved',
                        value: '2,215',
                        percentage: '78%',
                      ),
                      const SizedBox(height: 16),
                      _buildResolutionLegendItem(
                        color: Colors.orange,
                        label: 'In Progress',
                        value: '482',
                        percentage: '17%',
                      ),
                      const SizedBox(height: 16),
                      _buildResolutionLegendItem(
                        color: Colors.red,
                        label: 'Unresolved',
                        value: '145',
                        percentage: '5%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Resolution Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResolutionTimeItem(
                  title: 'Average',
                  value: '3.2 days',
                  trend: '-0.5 days',
                  trendUp: false,
                ),
                _buildResolutionTimeItem(
                  title: 'Water Issues',
                  value: '2.8 days',
                  trend: '-0.3 days',
                  trendUp: false,
                ),
                _buildResolutionTimeItem(
                  title: 'Roads',
                  value: '4.5 days',
                  trend: '-0.2 days',
                  trendUp: false,
                ),
                _buildResolutionTimeItem(
                  title: 'Sanitation',
                  value: '2.1 days',
                  trend: '-0.4 days',
                  trendUp: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionLegendItem({
    required Color color,
    required String label,
    required String value,
    required String percentage,
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
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  percentage,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResolutionTimeItem({
    required String title,
    required String value,
    required String trend,
    required bool trendUp,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Icon(
              trendUp ? Icons.arrow_upward : Icons.arrow_downward,
              size: 12,
              color: trendUp ? Colors.red : Colors.green,
            ),
            Text(
              trend,
              style: TextStyle(
                color: trendUp ? Colors.red : Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGeographicalDistribution() {
    final locations = [
      {
        'name': 'Gandhi Ward',
        'reports': 524,
        'resolved': 482,
        'performance': 0.92,
      },
      {
        'name': 'Nehru Colony',
        'reports': 386,
        'resolved': 312,
        'performance': 0.81,
      },
      {
        'name': 'Ambedkar Nagar',
        'reports': 458,
        'resolved': 385,
        'performance': 0.84,
      },
      {
        'name': 'Patel District',
        'reports': 342,
        'resolved': 272,
        'performance': 0.80,
      },
      {
        'name': 'Shastri Market',
        'reports': 278,
        'resolved': 235,
        'performance': 0.85,
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
                  'Geographical Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Open map view
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('Map View'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Top Areas by Report Volume',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...locations.map((location) => _buildLocationItem(location)).toList(),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Download detailed report
                },
                child: const Text('Download Detailed Area Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(Map<String, dynamic> location) {
    final performance = location['performance'] as double;
    final progressColor = performance >= 0.9
        ? Colors.green
        : performance >= 0.8
            ? Colors.blue
            : performance >= 0.7
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                location['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${(performance * 100).toInt()}% Resolved',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Reports',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${location['reports']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resolved',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${location['resolved']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${location['reports'] - location['resolved']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  // TODO: View area details
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
