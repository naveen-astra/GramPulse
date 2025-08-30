import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/officer_bloc.dart';
import '../bloc/officer_event.dart';
import '../bloc/officer_state.dart';

class OfficerPriorityQueueScreen extends StatefulWidget {
  const OfficerPriorityQueueScreen({Key? key}) : super(key: key);

  @override
  State<OfficerPriorityQueueScreen> createState() => _OfficerPriorityQueueScreenState();
}

class _OfficerPriorityQueueScreenState extends State<OfficerPriorityQueueScreen> {
  List<Map<String, dynamic>> _priorityIncidents = [];
  String? _selectedUrgency;
  String? _selectedDepartment;
  bool _showSLAOnly = false;

  @override
  void initState() {
    super.initState();
    _loadPriorityQueue();
  }

  void _loadPriorityQueue() {
    // For now, using the existing incidents API but will enhance later
    context.read<OfficerBloc>().add(const OfficerLoadIncidents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Priority Queue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPriorityQueue,
          ),
        ],
      ),
      body: Column(
        children: [
          // Priority Queue Header with Metrics
          _buildPriorityHeader(),
          
          // Filter Chips
          _buildFilterChips(),
          
          // Priority Queue List
          Expanded(
            child: BlocListener<OfficerBloc, OfficerState>(
              listener: (context, state) {
                if (state is OfficerIncidentsLoaded) {
                  setState(() {
                    _priorityIncidents = state.incidents;
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

                  if (_priorityIncidents.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _loadPriorityQueue(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _priorityIncidents.length,
                      itemBuilder: (context, index) {
                        final incident = _priorityIncidents[index];
                        return _buildPriorityIncidentCard(incident, index + 1);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade600, Colors.red.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Priority Queue System',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Incidents sorted by SLA deadline, severity, and community support',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.priority_high,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            label: const Text('Critical'),
            selected: _selectedUrgency == 'CRITICAL',
            selectedColor: Colors.red.shade100,
            onSelected: (selected) {
              setState(() {
                _selectedUrgency = selected ? 'CRITICAL' : null;
              });
              _applyFilters();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('High Priority'),
            selected: _selectedUrgency == 'HIGH',
            selectedColor: Colors.orange.shade100,
            onSelected: (selected) {
              setState(() {
                _selectedUrgency = selected ? 'HIGH' : null;
              });
              _applyFilters();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('SLA Breach'),
            selected: _showSLAOnly,
            selectedColor: Colors.red.shade100,
            onSelected: (selected) {
              setState(() {
                _showSLAOnly = selected;
              });
              _applyFilters();
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('My Department'),
            selected: _selectedDepartment != null,
            selectedColor: Colors.blue.shade100,
            onSelected: (selected) {
              setState(() {
                _selectedDepartment = selected ? 'WSD' : null;
              });
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityIncidentCard(Map<String, dynamic> incident, int priority) {
    final incidentData = incident['incident'] ?? {};
    final assignmentStatus = incident['assignmentStatus'] ?? 'ASSIGNED';
    final severity = incidentData['severity'] ?? 1;
    
    // Simulate priority score calculation
    final priorityScore = _calculatePriorityScore(incidentData);
    final urgencyLevel = _getUrgencyLevel(priorityScore);
    final slaStatus = _getSLAStatus(incidentData);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: _getUrgencyColor(urgencyLevel),
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Priority Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor(urgencyLevel).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag,
                          size: 12,
                          color: _getUrgencyColor(urgencyLevel),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '#$priority',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getUrgencyColor(urgencyLevel),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getUrgencyColor(urgencyLevel),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      urgencyLevel,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getSLAColor(slaStatus).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      slaStatus,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getSLAColor(slaStatus),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Incident Details
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getUrgencyColor(urgencyLevel).withOpacity(0.2),
                    child: Icon(
                      _getCategoryIcon(incidentData['categoryId'] ?? ''),
                      color: _getUrgencyColor(urgencyLevel),
                      size: 20,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Priority Score: $priorityScore | Severity: ${_getSeverityText(severity)}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // SLA and Time Information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SLA Deadline',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatSLADeadline(incidentData),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getSLAColor(slaStatus),
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
                            'Reported',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatDate(incidentData['createdAt']),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Action Buttons
              Row(
                children: [
                  if (assignmentStatus == 'ASSIGNED')
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateStatus(incident['assignmentId'], 'IN_PROGRESS'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text('Accept', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  if (assignmentStatus == 'IN_PROGRESS') ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updateStatus(incident['assignmentId'], 'COMPLETED'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Complete', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _showEscalationDialog(incident),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                      side: BorderSide(color: Colors.red.shade600),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.arrow_upward, size: 16),
                    label: const Text('Escalate', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'No priority incidents found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All incidents are handled efficiently!',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Priority Queue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Department filter, urgency filter, etc.
            const Text('Filter options will be enhanced with backend integration'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showEscalationDialog(Map<String, dynamic> incident) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escalate Incident'),
        content: const Text('Escalation workflow will be implemented with backend integration'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement escalation logic
            },
            child: const Text('Escalate'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    // Apply filters to _priorityIncidents
    // This will be enhanced with backend filtering
    _loadPriorityQueue();
  }

  void _updateStatus(String assignmentId, String status) {
    context.read<OfficerBloc>().add(OfficerUpdateAssignmentStatus(
      assignmentId,
      status,
    ));
  }

  // Helper Methods
  int _calculatePriorityScore(Map<String, dynamic> incident) {
    final severity = incident['severity'] ?? 1;
    final category = incident['categoryId'] ?? '';
    
    int score = severity * 15;
    
    // Category-based scoring
    if (category.contains('EMERGENCY') || category.contains('HEALTH')) {
      score += 30;
    } else if (category.contains('WATER') || category.contains('ELECTRICITY')) {
      score += 20;
    }
    
    // Time-based urgency
    final createdAt = DateTime.tryParse(incident['createdAt'] ?? '');
    if (createdAt != null) {
      final hoursSince = DateTime.now().difference(createdAt).inHours;
      if (hoursSince > 24) score += 20;
      if (hoursSince > 48) score += 30;
    }
    
    return score.clamp(0, 100);
  }

  String _getUrgencyLevel(int priorityScore) {
    if (priorityScore >= 80) return 'EMERGENCY';
    if (priorityScore >= 60) return 'CRITICAL';
    if (priorityScore >= 40) return 'HIGH';
    if (priorityScore >= 20) return 'MEDIUM';
    return 'LOW';
  }

  String _getSLAStatus(Map<String, dynamic> incident) {
    // Mock SLA calculation
    final createdAt = DateTime.tryParse(incident['createdAt'] ?? '');
    if (createdAt == null) return 'NORMAL';
    
    final hoursSince = DateTime.now().difference(createdAt).inHours;
    if (hoursSince > 48) return 'BREACHED';
    if (hoursSince > 24) return 'WARNING';
    return 'NORMAL';
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'EMERGENCY': return Colors.red.shade700;
      case 'CRITICAL': return Colors.red.shade500;
      case 'HIGH': return Colors.orange.shade600;
      case 'MEDIUM': return Colors.yellow.shade700;
      case 'LOW': return Colors.green.shade600;
      default: return Colors.grey;
    }
  }

  Color _getSLAColor(String slaStatus) {
    switch (slaStatus) {
      case 'BREACHED': return Colors.red.shade600;
      case 'WARNING': return Colors.orange.shade600;
      case 'NORMAL': return Colors.green.shade600;
      default: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String categoryId) {
    if (categoryId.contains('WATER')) return Icons.water_drop;
    if (categoryId.contains('ELECTRICITY')) return Icons.electrical_services;
    if (categoryId.contains('HEALTH')) return Icons.local_hospital;
    if (categoryId.contains('ROAD')) return Icons.construction;
    return Icons.report_problem;
  }

  String _getSeverityText(int severity) {
    switch (severity) {
      case 1: return 'Low';
      case 2: return 'Medium';
      case 3: return 'High';
      case 4: return 'Critical';
      default: return 'Unknown';
    }
  }

  String _formatSLADeadline(Map<String, dynamic> incident) {
    // Mock SLA deadline calculation
    final createdAt = DateTime.tryParse(incident['createdAt'] ?? '');
    if (createdAt == null) return 'No deadline';
    
    final category = incident['categoryId'] ?? '';
    int slaHours = 48; // Default 48 hours
    
    if (category.contains('EMERGENCY') || category.contains('HEALTH')) {
      slaHours = 4;
    } else if (category.contains('WATER') || category.contains('ELECTRICITY')) {
      slaHours = 24;
    }
    
    final deadline = createdAt.add(Duration(hours: slaHours));
    final remaining = deadline.difference(DateTime.now());
    
    if (remaining.isNegative) {
      return 'Overdue by ${remaining.inHours.abs()}h';
    } else {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m left';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    final date = DateTime.tryParse(dateString);
    if (date == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}
