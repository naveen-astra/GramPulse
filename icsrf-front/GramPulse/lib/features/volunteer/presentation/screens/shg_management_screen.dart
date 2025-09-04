import 'package:flutter/material.dart';
import 'package:grampulse/features/volunteer/presentation/widgets/shg_card.dart';
import 'package:grampulse/features/volunteer/presentation/widgets/shg_stats_card.dart';

class SHGManagementScreen extends StatefulWidget {
  const SHGManagementScreen({Key? key}) : super(key: key);

  @override
  State<SHGManagementScreen> createState() => _SHGManagementScreenState();
}

class _SHGManagementScreenState extends State<SHGManagementScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        title: const Text('SHG Management'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active SHGs'),
            Tab(text: 'Applications'),
            Tab(text: 'Analytics'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ActiveSHGsTab(),
          _ApplicationsTab(),
          _AnalyticsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create new SHG
        },
        backgroundColor: Colors.purple.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _ActiveSHGsTab extends StatelessWidget {
  final List<SHGData> activeSHGs = [
    SHGData(
      id: '1',
      name: 'Mahila Shakti Samuh',
      memberCount: 12,
      status: SHGStatus.active,
      monthlyContribution: 5000,
      totalSavings: 85000,
      location: 'Ward 3, Main Street',
      president: 'Sunita Devi',
      formationDate: DateTime(2023, 1, 15),
    ),
    SHGData(
      id: '2',
      name: 'Pragati Women Group',
      memberCount: 15,
      status: SHGStatus.active,
      monthlyContribution: 3000,
      totalSavings: 62000,
      location: 'Ward 5, Housing Colony',
      president: 'Meera Sharma',
      formationDate: DateTime(2022, 8, 20),
    ),
    SHGData(
      id: '3',
      name: 'Swayam Sahayata Samiti',
      memberCount: 10,
      status: SHGStatus.inactive,
      monthlyContribution: 2000,
      totalSavings: 28000,
      location: 'Ward 1, Old Town',
      president: 'Kamala Devi',
      formationDate: DateTime(2023, 5, 10),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Statistics overview
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: SHGStatsCard(
                  title: 'Total SHGs',
                  value: '${activeSHGs.length}',
                  icon: Icons.group,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SHGStatsCard(
                  title: 'Total Members',
                  value: '${activeSHGs.fold(0, (sum, shg) => sum + shg.memberCount)}',
                  icon: Icons.people,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        
        // Search and filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search SHGs...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  // Show filter options
                },
                icon: const Icon(Icons.filter_list),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.purple.shade50,
                  foregroundColor: Colors.purple.shade600,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // SHG list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: activeSHGs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SHGCard(
                  shg: activeSHGs[index],
                  onTap: () {
                    // Navigate to SHG details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ApplicationsTab extends StatelessWidget {
  final List<SHGApplication> applications = [
    SHGApplication(
      id: '1',
      groupName: 'Naya Ujala Samuh',
      applicantName: 'Priya Kumari',
      memberCount: 8,
      applicationDate: DateTime.now().subtract(const Duration(days: 2)),
      status: ApplicationStatus.pending,
      location: 'Ward 7, New Area',
      contactNumber: '+91 9876543210',
    ),
    SHGApplication(
      id: '2',
      groupName: 'Vikas Mahila Mandal',
      applicantName: 'Asha Devi',
      memberCount: 12,
      applicationDate: DateTime.now().subtract(const Duration(days: 5)),
      status: ApplicationStatus.underReview,
      location: 'Ward 2, Central Market',
      contactNumber: '+91 9876543211',
    ),
    SHGApplication(
      id: '3',
      groupName: 'Sarthak Group',
      applicantName: 'Rekha Sharma',
      memberCount: 10,
      applicationDate: DateTime.now().subtract(const Duration(days: 8)),
      status: ApplicationStatus.approved,
      location: 'Ward 4, Residential Area',
      contactNumber: '+91 9876543212',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                  Expanded(
                    child: Text(
                      application.groupName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(application.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(application.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(application.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Applicant: ${application.applicantName}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Members: ${application.memberCount} • ${application.location}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Applied ${_formatDate(application.applicationDate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (application.status == ApplicationStatus.pending) ...[
                        TextButton(
                          onPressed: () {
                            // Reject application
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          ),
                          child: const Text('Reject'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Approve application
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          ),
                          child: const Text('Approve'),
                        ),
                      ] else ...[
                        TextButton(
                          onPressed: () {
                            // View details
                          },
                          child: const Text('View Details'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return Colors.orange;
      case ApplicationStatus.underReview:
        return Colors.blue;
      case ApplicationStatus.approved:
        return Colors.green;
      case ApplicationStatus.rejected:
        return Colors.red;
    }
  }

  String _getStatusText(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.underReview:
        return 'Under Review';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

class _AnalyticsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key metrics
          const Text(
            'Key Metrics',
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
              SHGStatsCard(
                title: 'Total Savings',
                value: '₹1.75L',
                subtitle: '+12% this month',
                icon: Icons.savings,
                color: Colors.green,
              ),
              SHGStatsCard(
                title: 'Active Loans',
                value: '8',
                subtitle: '₹45,000 disbursed',
                icon: Icons.account_balance,
                color: Colors.blue,
              ),
              SHGStatsCard(
                title: 'Success Rate',
                value: '92%',
                subtitle: 'Loan repayment',
                icon: Icons.trending_up,
                color: Colors.orange,
              ),
              SHGStatsCard(
                title: 'New Members',
                value: '15',
                subtitle: 'This quarter',
                icon: Icons.person_add,
                color: Colors.purple,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Recent activities
          const Text(
            'Recent Activities',
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
                  title: 'New SHG Application',
                  description: 'Naya Ujala Samuh applied for registration',
                  time: '2 hours ago',
                  icon: Icons.group_add,
                  color: Colors.blue,
                ),
                const Divider(),
                _ActivityItem(
                  title: 'Loan Approved',
                  description: 'Mahila Shakti Samuh - ₹25,000 for micro-business',
                  time: '1 day ago',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                const Divider(),
                _ActivityItem(
                  title: 'Training Completed',
                  description: 'Financial literacy training for 3 SHGs',
                  time: '3 days ago',
                  icon: Icons.school,
                  color: Colors.orange,
                ),
                const Divider(),
                _ActivityItem(
                  title: 'Monthly Meeting',
                  description: 'Pragati Women Group conducted monthly review',
                  time: '1 week ago',
                  icon: Icons.event,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  const _ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
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
                    fontWeight: FontWeight.w500,
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
            time,
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

// Data models
enum SHGStatus { active, inactive, pending }
enum ApplicationStatus { pending, underReview, approved, rejected }

class SHGData {
  final String id;
  final String name;
  final int memberCount;
  final SHGStatus status;
  final double monthlyContribution;
  final double totalSavings;
  final String location;
  final String president;
  final DateTime formationDate;

  SHGData({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.status,
    required this.monthlyContribution,
    required this.totalSavings,
    required this.location,
    required this.president,
    required this.formationDate,
  });
}

class SHGApplication {
  final String id;
  final String groupName;
  final String applicantName;
  final int memberCount;
  final DateTime applicationDate;
  final ApplicationStatus status;
  final String location;
  final String contactNumber;

  SHGApplication({
    required this.id,
    required this.groupName,
    required this.applicantName,
    required this.memberCount,
    required this.applicationDate,
    required this.status,
    required this.location,
    required this.contactNumber,
  });
}
