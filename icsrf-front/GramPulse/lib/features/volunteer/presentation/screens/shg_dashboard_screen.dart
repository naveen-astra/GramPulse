import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/shg_bloc.dart';
import '../widgets/shg_card.dart';
import '../widgets/scheme_card.dart';
import '../widgets/shg_stats_card.dart';

class SHGDashboardScreen extends StatelessWidget {
  const SHGDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SHGBloc()..add(const LoadSHGDashboard()),
      child: const _SHGDashboardView(),
    );
  }
}

class _SHGDashboardView extends StatelessWidget {
  const _SHGDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self-Help Groups'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SHGBloc>().add(const LoadSHGDashboard());
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Handle add new SHG
              _showAddSHGDialog(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<SHGBloc, SHGState>(
        builder: (context, state) {
          if (state is SHGLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is SHGError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SHGBloc>().add(const LoadSHGDashboard());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is SHGDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SHGBloc>().add(const LoadSHGDashboard());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade600, Colors.purple.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SHG Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Support and guide Self-Help Groups',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // SHG Statistics
                    const Text(
                      'SHG Overview',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SHGStatsCard(
                            title: 'Total SHGs',
                            value: state.stats.totalSHGs.toString(),
                            icon: Icons.group,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          SHGStatsCard(
                            title: 'Active SHGs',
                            value: state.stats.activeSHGs.toString(),
                            icon: Icons.verified,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 12),
                          SHGStatsCard(
                            title: 'Total Savings',
                            value: '₹${(state.stats.totalSavings / 1000).toStringAsFixed(0)}K',
                            icon: Icons.savings,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          SHGStatsCard(
                            title: 'Avg Participation',
                            value: '${state.stats.averageParticipation.toInt()}%',
                            icon: Icons.trending_up,
                            color: Colors.purple,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Self-Help Groups List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Self-Help Groups',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to full SHG list
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    if (state.shgList.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.group_add,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No SHGs registered yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.shgList.length,
                        itemBuilder: (context, index) {
                          final shg = state.shgList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SHGCard(
                              shg: shg,
                              onTap: () {
                                context.read<SHGBloc>().add(SelectSHG(shg.id));
                                context.push('/volunteer/shg/${shg.id}');
                              },
                            ),
                          );
                        },
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Government Schemes
                    const Text(
                      'Available Government Schemes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.availableSchemes.length,
                        itemBuilder: (context, index) {
                          final scheme = state.availableSchemes[index];
                          return Container(
                            width: 280,
                            margin: const EdgeInsets.only(right: 12),
                            child: SchemeCard(
                              scheme: scheme,
                              onGuide: () {
                                _showSchemeGuidanceDialog(context, scheme);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            title: 'Verify Applications',
                            description: 'Review pending scheme applications',
                            icon: Icons.assignment_turned_in,
                            color: Colors.green,
                            onTap: () {
                              // Navigate to applications
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickActionCard(
                            title: 'Training Schedule',
                            description: 'Organize SHG training sessions',
                            icon: Icons.schedule,
                            color: Colors.blue,
                            onTap: () {
                              // Navigate to training
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          }
          
          if (state is SHGDetailsLoaded) {
            return _SHGDetailsView(
              shg: state.shg,
              discussions: state.discussions,
              eligibleSchemes: state.eligibleSchemes,
            );
          }
          
          return const Center(
            child: Text('Unknown state'),
          );
        },
      ),
    );
  }

  void _showAddSHGDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New SHG'),
        content: const Text('This feature will allow volunteers to register new Self-Help Groups in their area.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement add SHG functionality
            },
            child: const Text('Add SHG'),
          ),
        ],
      ),
    );
  }

  void _showSchemeGuidanceDialog(BuildContext context, GovernmentScheme scheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Guide to ${scheme.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(scheme.description),
              const SizedBox(height: 16),
              const Text(
                'Benefits:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...scheme.benefits.map((benefit) => Text('• $benefit')),
              const SizedBox(height: 16),
              const Text(
                'How to help SHGs apply:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('1. Verify SHG eligibility'),
              const Text('2. Help gather required documents'),
              const Text('3. Assist with application form'),
              const Text('4. Submit through proper channels'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SHGDetailsView extends StatelessWidget {
  final SelfHelpGroup shg;
  final List<CommunityDiscussion> discussions;
  final List<GovernmentScheme> eligibleSchemes;

  const _SHGDetailsView({
    required this.shg,
    required this.discussions,
    required this.eligibleSchemes,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SHG Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shg.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('${shg.memberCount} members • ${shg.village}'),
                  Text('Total Savings: ₹${shg.totalSavings.toStringAsFixed(0)}'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Community Discussions
          const Text(
            'Community Discussions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: discussions.length,
            itemBuilder: (context, index) {
              final discussion = discussions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(discussion.title),
                  subtitle: Text(discussion.message),
                  trailing: Text('${discussion.replies} replies'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
