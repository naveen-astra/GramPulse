import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/volunteer_dashboard_bloc.dart';
import '../widgets/stats_card.dart';
import '../widgets/verification_request_card.dart';
import '../widgets/nearby_requests_map.dart';
import '../../../auth/domain/auth_events_states.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';

class VolunteerDashboardScreen extends StatelessWidget {
  const VolunteerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => VolunteerDashboardBloc()..add(const LoadDashboard()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: const _VolunteerDashboardView(),
    );
  }
}

class _VolunteerDashboardView extends StatelessWidget {
  const _VolunteerDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Dashboard'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<VolunteerDashboardBloc>().add(const RefreshDashboard());
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.push('/volunteer/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocBuilder<VolunteerDashboardBloc, VolunteerDashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is DashboardError) {
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
                      context.read<VolunteerDashboardBloc>().add(const LoadDashboard());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<VolunteerDashboardBloc>().add(const RefreshDashboard());
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
                          colors: [Colors.blue.shade600, Colors.blue.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome, Volunteer!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Help make your community better',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats cards
                    const Text(
                      'Your Performance',
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
                          StatsCard(
                            title: 'Pending',
                            value: state.stats.pendingVerifications.toString(),
                            icon: Icons.pending_actions,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          StatsCard(
                            title: 'Verified Today',
                            value: state.stats.verifiedToday.toString(),
                            icon: Icons.verified,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 12),
                          StatsCard(
                            title: 'Response Rate',
                            value: '${state.stats.responseRate.toInt()}%',
                            icon: Icons.speed,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          StatsCard(
                            title: 'Reputation',
                            value: state.stats.reputation.toString(),
                            icon: Icons.star,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Nearby verification requests map
                    const Text(
                      'Nearby Requests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: NearbyRequestsMap(
                          requests: state.nearbyRequests,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Quick Actions Section
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                      children: [
                        _buildQuickActionCard(
                          context: context,
                          title: 'View All Issues',
                          icon: Icons.list_alt,
                          color: Colors.blue,
                          onTap: () => context.push('/volunteer/verification-queue'),
                        ),
                        _buildQuickActionCard(
                          context: context,
                          title: 'Document Help',
                          icon: Icons.description,
                          color: Colors.orange,
                          onTap: () => context.push('/volunteer/assist-citizen'),
                        ),
                        _buildQuickActionCard(
                          context: context,
                          title: 'SHG Support',
                          icon: Icons.group,
                          color: Colors.purple,
                          onTap: () => context.push('/volunteer/assist-citizen'),
                        ),
                        _buildQuickActionCard(
                          context: context,
                          title: 'Training Sessions',
                          icon: Icons.school,
                          color: Colors.teal,
                          onTap: () => context.push('/volunteer/assist-citizen'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Verification queue
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Verification Queue',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/volunteer/verification-queue');
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    if (state.verificationQueue.isEmpty)
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
                              Icons.check_circle_outline,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No pending verifications',
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
                        itemCount: state.verificationQueue.length > 3 ? 3 : state.verificationQueue.length,
                        itemBuilder: (context, index) {
                          final request = state.verificationQueue[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: VerificationRequestCard(
                              request: request,
                              onVerifyNow: () {
                                context.read<VolunteerDashboardBloc>().add(
                                  AcceptVerification(request.id),
                                );
                                // Navigate to verification screen
                                context.push('/volunteer/verification-queue/${request.id}');
                              },
                              onSkip: () {
                                context.read<VolunteerDashboardBloc>().add(
                                  SkipVerification(request.id),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Assist Citizens card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.help_outline,
                                color: Colors.green.shade600,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Assist Citizens',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Help citizens understand government schemes, assist with applications, and provide guidance.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push('/volunteer/assist-citizen');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Start Assisting'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          }
          
          return const Center(
            child: Text('Unknown state'),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutEvent());
                context.go('/role-selection');
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
