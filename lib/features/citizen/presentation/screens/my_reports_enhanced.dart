import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:grampulse/features/citizen/domain/models/incident_models.dart';
import 'package:grampulse/features/citizen/presentation/bloc/incident/incident_bloc.dart';
import 'package:grampulse/features/citizen/presentation/bloc/incident/incident_event.dart';
import 'package:grampulse/features/citizen/presentation/bloc/incident/incident_state.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStatus = 'ALL';

  final Map<String, String> statusMap = {
    'ALL': 'All',
    'NEW': 'New',
    'ASSIGNED': 'Assigned',
    'IN_PROGRESS': 'In Progress',
    'RESOLVED': 'Resolved',
    'CLOSED': 'Closed',
  };

  final Map<String, Color> statusColors = {
    'NEW': Colors.orange,
    'ASSIGNED': Colors.blue,
    'IN_PROGRESS': Colors.purple,
    'RESOLVED': Colors.green,
    'CLOSED': Colors.grey,
  };

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
    return BlocProvider(
      create: (context) => IncidentBloc()..add(LoadMyIncidents()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Issues'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () {
                context.read<IncidentBloc>().add(LoadMyIncidents());
              },
              icon: const Icon(Icons.refresh),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              onSelected: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return statusMap.entries.map((entry) {
                  return PopupMenuItem<String>(
                    value: entry.key,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: statusColors[entry.key] ?? Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(entry.value),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'All', icon: Icon(Icons.list)),
              Tab(text: 'Active', icon: Icon(Icons.pending)),
              Tab(text: 'Resolved', icon: Icon(Icons.check_circle)),
            ],
          ),
        ),
        body: BlocBuilder<IncidentBloc, IncidentState>(
          builder: (context, state) {
            if (state is IncidentLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is IncidentError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading issues',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<IncidentBloc>().add(LoadMyIncidents());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is IncidentLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildAllIncidentsList(state.myIncidents),
                  _buildActiveIncidentsList(state.myIncidents),
                  _buildResolvedIncidentsList(state.myIncidents),
                ],
              );
            }

            return const Center(
              child: Text('No issues found'),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/citizen/report');
          },
          backgroundColor: Colors.blue.shade600,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAllIncidentsList(List<Incident> incidents) {
    if (incidents.isEmpty) {
      return _buildEmptyState(
        'No issues reported yet',
        'Tap the + button to report your first issue',
        Icons.report_problem,
      );
    }

    return Column(
      children: [
        _buildStatusSummary(incidents),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<IncidentBloc>().add(LoadMyIncidents());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                return _buildIncidentCard(incidents[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveIncidentsList(List<Incident> incidents) {
    final activeIncidents = incidents.where((incident) =>
        !['RESOLVED', 'CLOSED'].contains(incident.status)).toList();

    if (activeIncidents.isEmpty) {
      return _buildEmptyState(
        'No active issues',
        'All your issues have been resolved',
        Icons.check_circle_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<IncidentBloc>().add(LoadMyIncidents());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activeIncidents.length,
        itemBuilder: (context, index) {
          return _buildIncidentCard(activeIncidents[index]);
        },
      ),
    );
  }

  Widget _buildResolvedIncidentsList(List<Incident> incidents) {
    final resolvedIncidents = incidents.where((incident) =>
        ['RESOLVED', 'CLOSED'].contains(incident.status)).toList();

    if (resolvedIncidents.isEmpty) {
      return _buildEmptyState(
        'No resolved issues',
        'Resolved issues will appear here',
        Icons.history,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<IncidentBloc>().add(LoadMyIncidents());
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: resolvedIncidents.length,
        itemBuilder: (context, index) {
          return _buildIncidentCard(resolvedIncidents[index]);
        },
      ),
    );
  }

  Widget _buildStatusSummary(List<Incident> incidents) {
    final statusCounts = <String, int>{};
    for (var incident in incidents) {
      statusCounts[incident.status] = (statusCounts[incident.status] ?? 0) + 1;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issue Status Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: statusCounts.entries.map((entry) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColors[entry.key]?.withOpacity(0.1) ?? Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: statusColors[entry.key] ?? Colors.grey,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColors[entry.key] ?? Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${statusMap[entry.key] ?? entry.key}: ${entry.value}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColors[entry.key] ?? Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIncidentCard(Incident incident) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showIncidentDetails(incident);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      incident.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColors[incident.status]?.withOpacity(0.1) ?? Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColors[incident.status] ?? Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      statusMap[incident.status] ?? incident.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColors[incident.status] ?? Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                incident.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      incident.location.address ?? 
                      '${incident.location.latitude.toStringAsFixed(4)}, ${incident.location.longitude.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _getSeverityIcon(incident.severity),
                    size: 16,
                    color: _getSeverityColor(incident.severity),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getSeverityText(incident.severity),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getSeverityColor(incident.severity),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(incident.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSeverityIcon(int severity) {
    switch (severity) {
      case 1: return Icons.info;
      case 2: return Icons.warning;
      case 3: return Icons.error;
      default: return Icons.info;
    }
  }

  Color _getSeverityColor(int severity) {
    switch (severity) {
      case 1: return Colors.blue;
      case 2: return Colors.orange;
      case 3: return Colors.red;
      default: return Colors.grey;
    }
  }

  String _getSeverityText(int severity) {
    switch (severity) {
      case 1: return 'Low';
      case 2: return 'Medium';
      case 3: return 'High';
      default: return 'Unknown';
    }
  }

  void _showIncidentDetails(Incident incident) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              incident.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: statusColors[incident.status]?.withOpacity(0.1) ?? Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: statusColors[incident.status] ?? Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              statusMap[incident.status] ?? incident.status,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: statusColors[incident.status] ?? Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Description', incident.description),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        'Location', 
                        incident.location.address ?? 
                        '${incident.location.latitude.toStringAsFixed(6)}, ${incident.location.longitude.toStringAsFixed(6)}'
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Severity', _getSeverityText(incident.severity)),
                      const SizedBox(height: 16),
                      _buildDetailRow('Reported', DateFormat('MMMM dd, yyyy • HH:mm').format(incident.createdAt)),
                      const SizedBox(height: 16),
                      _buildDetailRow('Last Updated', DateFormat('MMMM dd, yyyy • HH:mm').format(incident.updatedAt)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                // TODO: Navigate to location on map
                              },
                              icon: const Icon(Icons.map),
                              label: const Text('View on Map'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                // TODO: Share incident details
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
