import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/officer_bloc.dart';
import '../bloc/officer_event.dart';
import '../bloc/officer_state.dart';

class OfficerIncidentsScreen extends StatefulWidget {
  final String? initialStatus;
  final String? initialCategory;

  const OfficerIncidentsScreen({
    Key? key,
    this.initialStatus,
    this.initialCategory,
  }) : super(key: key);

  @override
  State<OfficerIncidentsScreen> createState() => _OfficerIncidentsScreenState();
}

class _OfficerIncidentsScreenState extends State<OfficerIncidentsScreen> {
  List<Map<String, dynamic>> _incidents = [];
  String? _selectedStatus;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _selectedCategory = widget.initialCategory;
    _loadIncidents();
  }

  void _loadIncidents() {
    context.read<OfficerBloc>().add(OfficerLoadIncidents(
      status: _selectedStatus,
      category: _selectedCategory,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incidents'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                if (value == 'all') {
                  _selectedStatus = null;
                } else {
                  _selectedStatus = value;
                }
              });
              _loadIncidents();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Incidents')),
              const PopupMenuItem(value: 'ASSIGNED', child: Text('Assigned')),
              const PopupMenuItem(value: 'IN_PROGRESS', child: Text('In Progress')),
              const PopupMenuItem(value: 'COMPLETED', child: Text('Completed')),
            ],
          ),
        ],
      ),
      body: BlocListener<OfficerBloc, OfficerState>(
        listener: (context, state) {
          if (state is OfficerIncidentsLoaded) {
            setState(() {
              _incidents = state.incidents;
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

            if (_incidents.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No incidents found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for new assignments',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _loadIncidents(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _incidents.length,
                itemBuilder: (context, index) {
                  final incident = _incidents[index];
                  return _buildIncidentCard(incident);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIncidentCard(Map<String, dynamic> incident) {
    final incidentData = incident['incident'] ?? {};
    final assignmentStatus = incident['assignmentStatus'] ?? 'ASSIGNED';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getStatusColor(assignmentStatus).withOpacity(0.2),
                  child: Icon(
                    _getCategoryIcon(incidentData['categoryId'] ?? ''),
                    color: _getStatusColor(assignmentStatus),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        incidentData['title'] ?? 'Unknown Issue',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Category: ${incidentData['categoryId'] ?? 'Unknown'}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(assignmentStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    assignmentStatus,
                    style: TextStyle(
                      color: _getStatusColor(assignmentStatus),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              incidentData['description'] ?? 'No description available',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
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
                    incidentData['location']?['address'] ?? 'Location not specified',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  'Priority: ${_getPriorityText(incidentData['severity'] ?? 1)}',
                  style: TextStyle(
                    color: _getPriorityColor(incidentData['severity'] ?? 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assigned: ${_formatDate(incident['assignedAt'])}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
                Row(
                  children: [
                    if (assignmentStatus == 'ASSIGNED')
                      ElevatedButton(
                        onPressed: () => _updateStatus(
                          incident['assignmentId'],
                          'IN_PROGRESS',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Accept', style: TextStyle(fontSize: 12)),
                      ),
                    if (assignmentStatus == 'IN_PROGRESS') ...[
                      ElevatedButton(
                        onPressed: () => _updateStatus(
                          incident['assignmentId'],
                          'COMPLETED',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Complete', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(String assignmentId, String status) {
    context.read<OfficerBloc>().add(OfficerUpdateAssignmentStatus(
      assignmentId,
      status,
    ));
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status updated to $status'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Reload incidents after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      _loadIncidents();
    });
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

  String _getPriorityText(int severity) {
    switch (severity) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return 'Unknown';
    }
  }

  Color _getPriorityColor(int severity) {
    switch (severity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
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
