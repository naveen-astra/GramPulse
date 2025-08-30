import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/officer_bloc.dart';
import '../bloc/officer_event.dart';
import '../bloc/officer_state.dart';
import 'officer_incidents_screen.dart';

class OfficerDashboardScreen extends StatefulWidget {
  const OfficerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? _officerProfile;

  @override
  void initState() {
    super.initState();
    context.read<OfficerBloc>().add(const OfficerLoadDashboard());
    context.read<OfficerBloc>().add(const OfficerLoadProfile());
  }

  void _refreshDashboard() {
    context.read<OfficerBloc>().add(const OfficerLoadDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Officer Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDashboard,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                context.read<OfficerBloc>().add(const OfficerLogout());
                context.go('/role-selection');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<OfficerBloc, OfficerState>(
        listener: (context, state) {
          if (state is OfficerDashboardLoaded) {
            setState(() {
              _dashboardData = state.dashboardData;
            });
          }
          
          if (state is OfficerAuthenticated) {
            setState(() {
              _officerProfile = state.officerData;
            });
          }

          if (state is OfficerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<OfficerBloc, OfficerState>(
          builder: (context, state) {
            if (state is OfficerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async => _refreshDashboard(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Officer Profile Card
                    _buildProfileCard(),
                    
                    const SizedBox(height: 20),
                    
                    // Statistics Cards
                    _buildStatsGrid(),
                    
                    const SizedBox(height: 20),
                    
                    // Quick Actions
                    _buildQuickActions(),
                    
                    const SizedBox(height: 20),
                    
                    // Recent Incidents
                    _buildRecentIncidents(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Icon(
                Icons.person,
                size: 35,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _officerProfile?['name'] ?? 'Officer Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _officerProfile?['designation'] ?? 'Officer',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _officerProfile?['departmentDetails']?['name'] ?? 'Department',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getEscalationLevelName(_officerProfile?['escalationLevel'] ?? 1),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildStatsGrid() {
    final stats = _dashboardData?['stats'] ?? {};
    
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          'Total Assigned',
          '${stats['totalAssigned'] ?? 0}',
          Icons.assignment,
          Colors.blue,
        ),
        _buildStatCard(
          'New Incidents',
          '${stats['newIncidents'] ?? 0}',
          Icons.new_releases,
          Colors.orange,
        ),
        _buildStatCard(
          'In Progress',
          '${stats['inProgress'] ?? 0}',
          Icons.work,
          Colors.purple,
        ),
        _buildStatCard(
          'Completed',
          '${stats['completed'] ?? 0}',
          Icons.check_circle,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduced padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Fix overflow issue
          children: [
            Icon(icon, size: 28, color: color), // Smaller icon
            const SizedBox(height: 6), // Reduced spacing
            Text(
              value,
              style: const TextStyle(
                fontSize: 20, // Smaller font
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4), // Reduced spacing
            Flexible( // Make text flexible to prevent overflow
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11, // Smaller font
                  color: Colors.grey.shade600,
                ),
                maxLines: 2, // Allow 2 lines
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'View All Incidents',
                    Icons.list,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OfficerIncidentsScreen(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'New Incidents',
                    Icons.notification_important,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OfficerIncidentsScreen(
                          initialStatus: 'ASSIGNED',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentIncidents() {
    final recentIncidents = _dashboardData?['recentIncidents'] ?? [];
    
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
                  'Recent Incidents',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OfficerIncidentsScreen(),
                    ),
                  ),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (recentIncidents.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No recent incidents',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentIncidents.length.clamp(0, 3),
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final incident = recentIncidents[index];
                  return _buildIncidentListItem(incident);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentListItem(Map<String, dynamic> incident) {
    final incidentData = incident['incident'] ?? {};
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(incident['status'] ?? '').withOpacity(0.2),
        child: Icon(
          _getCategoryIcon(incidentData['categoryId'] ?? ''),
          color: _getStatusColor(incident['status'] ?? ''),
        ),
      ),
      title: Text(
        incidentData['title'] ?? 'Unknown Issue',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status: ${incident['status'] ?? 'Unknown'}',
            style: TextStyle(
              color: _getStatusColor(incident['status'] ?? ''),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Assigned: ${_formatDate(incident['assignedAt'])}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Navigate to incident details
      },
    );
  }

  String _getEscalationLevelName(int level) {
    switch (level) {
      case 1:
        return 'Field Officer';
      case 2:
        return 'Nodal Officer';
      case 3:
        return 'Head Officer';
      default:
        return 'Officer';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ASSIGNED':
        return Colors.orange;
      case 'IN_PROGRESS':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'WATER':
        return Icons.water_drop;
      case 'ELECTRICITY':
        return Icons.electrical_services;
      case 'ROAD':
        return Icons.construction;
      case 'WASTE':
        return Icons.delete;
      case 'HEALTH':
        return Icons.local_hospital;
      default:
        return Icons.report_problem;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown';
    try {
      final DateTime dateTime = DateTime.parse(date.toString());
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Unknown';
    }
  }
}
