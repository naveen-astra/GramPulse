import 'package:flutter/material.dart';

class PerformanceMetric {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;

  PerformanceMetric({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });
}

class ActivityData {
  final String activity;
  final int count;
  final DateTime date;

  ActivityData({
    required this.activity,
    required this.count,
    required this.date,
  });
}

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({Key? key}) : super(key: key);

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = 'This Month';
  
  final List<PerformanceMetric> metrics = [
    PerformanceMetric(
      title: 'Verifications',
      value: '127',
      change: '+15%',
      isPositive: true,
      icon: Icons.verified,
      color: Colors.blue,
    ),
    PerformanceMetric(
      title: 'Citizens Helped',
      value: '89',
      change: '+23%',
      isPositive: true,
      icon: Icons.people_outline,
      color: Colors.green,
    ),
    PerformanceMetric(
      title: 'Average Rating',
      value: '4.8',
      change: '+0.3',
      isPositive: true,
      icon: Icons.star_outline,
      color: Colors.orange,
    ),
    PerformanceMetric(
      title: 'Response Time',
      value: '12 min',
      change: '-5 min',
      isPositive: true,
      icon: Icons.timer_outlined,
      color: Colors.purple,
    ),
  ];

  final List<ActivityData> weeklyData = [
    ActivityData(activity: 'Mon', count: 12, date: DateTime.now().subtract(const Duration(days: 6))),
    ActivityData(activity: 'Tue', count: 19, date: DateTime.now().subtract(const Duration(days: 5))),
    ActivityData(activity: 'Wed', count: 15, date: DateTime.now().subtract(const Duration(days: 4))),
    ActivityData(activity: 'Thu', count: 25, date: DateTime.now().subtract(const Duration(days: 3))),
    ActivityData(activity: 'Fri', count: 22, date: DateTime.now().subtract(const Duration(days: 2))),
    ActivityData(activity: 'Sat', count: 18, date: DateTime.now().subtract(const Duration(days: 1))),
    ActivityData(activity: 'Sun', count: 14, date: DateTime.now()),
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
        title: const Text('Performance Dashboard'),
        backgroundColor: Colors.amber.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            initialValue: selectedPeriod,
            onSelected: (value) {
              setState(() {
                selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'This Week', child: Text('This Week')),
              const PopupMenuItem(value: 'This Month', child: Text('This Month')),
              const PopupMenuItem(value: 'Last 3 Months', child: Text('Last 3 Months')),
              const PopupMenuItem(value: 'This Year', child: Text('This Year')),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(selectedPeriod, style: const TextStyle(fontSize: 14)),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Analytics'),
            Tab(text: 'Rankings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildAnalyticsTab(),
          _buildRankingsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade600, Colors.amber.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'Excellent Performance!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'You are in the top 10% of volunteers this month',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '127',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Tasks Completed',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '4.8',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Avg Rating',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '12',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Min Response',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Metrics Grid
          const Text(
            'Key Metrics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              final metric = metrics[index];
              return _buildMetricCard(metric);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Recent Achievements
          const Text(
            'Recent Achievements',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _buildAchievementCard(
            'Speed Demon',
            'Responded to 10 requests in under 5 minutes',
            Icons.flash_on,
            Colors.orange,
            '2 days ago',
          ),
          const SizedBox(height: 12),
          _buildAchievementCard(
            'Helper Hero',
            'Completed 100 citizen assistance tasks',
            Icons.emoji_events,
            Colors.gold,
            '1 week ago',
          ),
          const SizedBox(height: 12),
          _buildAchievementCard(
            'Top Rated',
            'Maintained 4.8+ rating for 30 days',
            Icons.star,
            Colors.purple,
            '2 weeks ago',
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity Chart
          const Text(
            'Weekly Activity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: _buildCustomBarChart(),
          ),
          
          const SizedBox(height: 24),
          
          // Category Breakdown
          const Text(
            'Task Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Container(
            height: 250,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: 40,
                    title: 'Verification\n40%',
                    color: Colors.blue,
                    radius: 80,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 25,
                    title: 'SHG Support\n25%',
                    color: Colors.green,
                    radius: 80,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 20,
                    title: 'Document Help\n20%',
                    color: Colors.orange,
                    radius: 80,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: 15,
                    title: 'Training\n15%',
                    color: Colors.purple,
                    radius: 80,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Performance Trends
          const Text(
            'Performance Trends',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _buildTrendCard('Response Time', '12 min', '-5 min from last month', Colors.green, Icons.trending_down),
          const SizedBox(height: 12),
          _buildTrendCard('Completion Rate', '96%', '+4% from last month', Colors.green, Icons.trending_up),
          const SizedBox(height: 12),
          _buildTrendCard('Citizen Satisfaction', '4.8/5', '+0.3 from last month', Colors.green, Icons.trending_up),
        ],
      ),
    );
  }

  Widget _buildRankingsTab() {
    final List<Map<String, dynamic>> rankings = [
      {'name': 'You', 'rank': 8, 'score': 1247, 'isCurrentUser': true},
      {'name': 'Priya Sharma', 'rank': 1, 'score': 1580, 'isCurrentUser': false},
      {'name': 'Rajesh Kumar', 'rank': 2, 'score': 1520, 'isCurrentUser': false},
      {'name': 'Amit Patel', 'rank': 3, 'score': 1485, 'isCurrentUser': false},
      {'name': 'Sunita Devi', 'rank': 4, 'score': 1420, 'isCurrentUser': false},
      {'name': 'Mohammad Ali', 'rank': 5, 'score': 1380, 'isCurrentUser': false},
      {'name': 'Kavya Reddy', 'rank': 6, 'score': 1325, 'isCurrentUser': false},
      {'name': 'Ravi Singh', 'rank': 7, 'score': 1280, 'isCurrentUser': false},
      {'name': 'Meera Joshi', 'rank': 9, 'score': 1190, 'isCurrentUser': false},
      {'name': 'Deepak Verma', 'rank': 10, 'score': 1150, 'isCurrentUser': false},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Rank Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade600, Colors.amber.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Your Current Rank',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  '#8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Out of 247 volunteers',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Top 10% performer',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          const Text(
            'Leaderboard',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Leaderboard List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rankings.length,
            itemBuilder: (context, index) {
              final volunteer = rankings[index];
              return _buildRankingCard(volunteer);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Rank improvement tips
          const Text(
            'Rank Improvement Tips',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          _buildTipCard(
            'Respond Faster',
            'Try to respond to requests within 5 minutes to improve your score',
            Icons.timer,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            'Complete More Tasks',
            'Take on additional verification and assistance tasks',
            Icons.assignment_turned_in,
            Colors.green,
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            'Maintain Quality',
            'Focus on providing excellent service to maintain high ratings',
            Icons.star,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(PerformanceMetric metric) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: metric.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(metric.icon, color: metric.color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: metric.isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  metric.change,
                  style: TextStyle(
                    color: metric.isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(String title, String description, IconData icon, Color color, String timeAgo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo,
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
    );
  }

  Widget _buildTrendCard(String title, String value, String trend, Color trendColor, IconData trendIcon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(trendIcon, color: trendColor, size: 16),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: trendColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingCard(Map<String, dynamic> volunteer) {
    final isCurrentUser = volunteer['isCurrentUser'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.amber.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser ? Border.all(color: Colors.amber.shade300) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(volunteer['rank']),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '#${volunteer['rank']}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volunteer['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  '${volunteer['score']} points',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'You',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber.shade600; // Gold
      case 2:
        return Colors.grey.shade400; // Silver
      case 3:
        return Colors.brown.shade400; // Bronze
      default:
        return Colors.blue.shade600;
    }
  }
}
                    'Track your volunteer activities and impact',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Performance metrics
            const Text(
              'This Month',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _MetricCard(
                  title: 'Verifications',
                  value: '45',
                  subtitle: '+12 from last month',
                  icon: Icons.verified,
                  color: Colors.green,
                ),
                _MetricCard(
                  title: 'Citizens Helped',
                  value: '28',
                  subtitle: '+8 from last month',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _MetricCard(
                  title: 'Response Time',
                  value: '2.3h',
                  subtitle: 'Average',
                  icon: Icons.timer,
                  color: Colors.orange,
                ),
                _MetricCard(
                  title: 'Reputation',
                  value: '245',
                  subtitle: '+15 points',
                  icon: Icons.star,
                  color: Colors.amber,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Achievements
            const Text(
              'Recent Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _AchievementItem(
                    title: 'Quick Responder',
                    description: 'Responded to 10 requests within 30 minutes',
                    icon: Icons.flash_on,
                    color: Colors.yellow,
                    date: 'Yesterday',
                  ),
                  const Divider(),
                  _AchievementItem(
                    title: 'Verification Expert',
                    description: 'Completed 50 verifications this month',
                    icon: Icons.verified,
                    color: Colors.green,
                    date: '2 days ago',
                  ),
                  const Divider(),
                  _AchievementItem(
                    title: 'Community Helper',
                    description: 'Helped 5 SHGs with scheme applications',
                    icon: Icons.group,
                    color: Colors.purple,
                    date: '1 week ago',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Activity timeline
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _ActivityItem(
                    title: 'Verified road repair issue',
                    location: 'Main Street, Sector 5',
                    time: '2 hours ago',
                    status: 'Completed',
                    statusColor: Colors.green,
                  ),
                  const Divider(),
                  _ActivityItem(
                    title: 'Assisted with loan application',
                    location: 'SHG - Mahila Shakti Samuh',
                    time: '5 hours ago',
                    status: 'In Progress',
                    statusColor: Colors.orange,
                  ),
                  const Divider(),
                  _ActivityItem(
                    title: 'Conducted training session',
                    location: 'Community Center',
                    time: '1 day ago',
                    status: 'Completed',
                    statusColor: Colors.green,
                  ),
                  const Divider(),
                  _ActivityItem(
                    title: 'Verified water supply issue',
                    location: 'Residential Area B',
                    time: '2 days ago',
                    status: 'Completed',
                    statusColor: Colors.green,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Feedback and ratings
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.feedback,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Citizen Feedback',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Overall Rating: '),
                      Row(
                        children: List.generate(5, (index) => Icon(
                          Icons.star,
                          color: index < 4 ? Colors.amber : Colors.grey.shade300,
                          size: 20,
                        )),
                      ),
                      const Text(' 4.2/5'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on 23 reviews from citizens you\'ve helped',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 14,
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
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: color,
                  size: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String date;

  const _AchievementItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
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
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String location;
  final String time;
  final String status;
  final Color statusColor;

  const _ActivityItem({
    required this.title,
    required this.location,
    required this.time,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
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
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
