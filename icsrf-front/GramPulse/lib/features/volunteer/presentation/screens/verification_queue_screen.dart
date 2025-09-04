import 'package:flutter/material.dart';

enum Priority { high, medium, low }
enum VerificationStatus { pending, inProgress, completed, cancelled }

class VerificationRequest {
  final String id;
  final String title;
  final String description;
  final String location;
  final Priority priority;
  final String category;
  final DateTime submittedAt;
  final String estimatedTime;
  final String distance;
  final String citizenName;
  final String citizenContact;
  final VerificationStatus status;
  final List<String> images;

  VerificationRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.priority,
    required this.category,
    required this.submittedAt,
    required this.estimatedTime,
    required this.distance,
    required this.citizenName,
    required this.citizenContact,
    required this.status,
    required this.images,
  });
}

class VerificationQueueScreen extends StatefulWidget {
  const VerificationQueueScreen({Key? key}) : super(key: key);

  @override
  State<VerificationQueueScreen> createState() => _VerificationQueueScreenState();
}

class _VerificationQueueScreenState extends State<VerificationQueueScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'priority';
  
  final List<VerificationRequest> allRequests = [
    VerificationRequest(
      id: '1',
      title: 'Road Repair Verification',
      description: 'Pothole on Main Street needs verification before repair work begins',
      location: 'Main Street, Sector 5',
      priority: Priority.high,
      category: 'Infrastructure',
      submittedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      estimatedTime: '30 min',
      distance: '0.8 km',
      citizenName: 'Rajesh Kumar',
      citizenContact: '+91 98765 43210',
      status: VerificationStatus.pending,
      images: ['https://via.placeholder.com/300x200'],
    ),
    VerificationRequest(
      id: '2',
      title: 'Water Supply Issue',
      description: 'No water supply for 3 days in residential area',
      location: 'Gandhi Nagar, Block A',
      priority: Priority.medium,
      category: 'Water Supply',
      submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
      estimatedTime: '45 min',
      distance: '1.2 km',
      citizenName: 'Priya Sharma',
      citizenContact: '+91 98765 43211',
      status: VerificationStatus.pending,
      images: ['https://via.placeholder.com/300x200'],
    ),
    VerificationRequest(
      id: '3',
      title: 'Street Light Malfunction',
      description: 'Multiple street lights not working causing safety concerns',
      location: 'Park Avenue, Sector 8',
      priority: Priority.low,
      category: 'Public Safety',
      submittedAt: DateTime.now().subtract(const Duration(hours: 4)),
      estimatedTime: '20 min',
      distance: '2.1 km',
      citizenName: 'Amit Patel',
      citizenContact: '+91 98765 43212',
      status: VerificationStatus.inProgress,
      images: ['https://via.placeholder.com/300x200'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Verification Queue'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                // Refresh the requests list
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRequestsList(_getFilteredRequests('all')),
          _buildRequestsList(_getFilteredRequests('pending')),
          _buildRequestsList(_getFilteredRequests('inProgress')),
          _buildRequestsList(_getFilteredRequests('completed')),
        ],
      ),
    );
  }

  List<VerificationRequest> _getFilteredRequests(String filter) {
    List<VerificationRequest> filtered = allRequests;
    
    switch (filter) {
      case 'pending':
        filtered = allRequests.where((r) => r.status == VerificationStatus.pending).toList();
        break;
      case 'inProgress':
        filtered = allRequests.where((r) => r.status == VerificationStatus.inProgress).toList();
        break;
      case 'completed':
        filtered = allRequests.where((r) => r.status == VerificationStatus.completed).toList();
        break;
      default:
        filtered = allRequests;
    }

    // Apply sorting
    switch (_sortBy) {
      case 'priority':
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'distance':
        filtered.sort((a, b) => double.parse(a.distance.split(' ')[0]).compareTo(double.parse(b.distance.split(' ')[0])));
        break;
      case 'time':
        filtered.sort((a, b) => a.submittedAt.compareTo(b.submittedAt));
        break;
    }
    
    return filtered;
  }

  Widget _buildRequestsList(List<VerificationRequest> requests) {
    if (requests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No verification requests found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          // Refresh logic here
        });
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildEnhancedRequestCard(request),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedRequestCard(VerificationRequest request) {
    Color priorityColor = Colors.grey;
    IconData priorityIcon = Icons.low_priority;
    
    switch (request.priority) {
      case Priority.high:
        priorityColor = Colors.red;
        priorityIcon = Icons.priority_high;
        break;
      case Priority.medium:
        priorityColor = Colors.orange;
        priorityIcon = Icons.remove;
        break;
      case Priority.low:
        priorityColor = Colors.green;
        priorityIcon = Icons.low_priority;
        break;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: priorityColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(priorityIcon, size: 16, color: priorityColor),
                          const SizedBox(width: 4),
                          Text(
                            request.priority.name.toUpperCase(),
                            style: TextStyle(
                              color: priorityColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _getTimeAgo(request.submittedAt),
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  request.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.blue.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        request.location,
                        style: TextStyle(color: Colors.blue.shade600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(Icons.category, request.category, Colors.purple),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.access_time, request.estimatedTime, Colors.orange),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.directions, request.distance, Colors.green),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue.shade100,
                      child: Icon(Icons.person, size: 18, color: Colors.blue.shade600),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.citizenName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            request.citizenContact,
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showRequestDetails(request),
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                      side: BorderSide(color: Colors.blue.shade600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _startVerification(request),
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Verifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('High Priority'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Medium Priority'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Low Priority'),
              value: true,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const Text('Distance'),
            RangeSlider(
              values: const RangeValues(0, 5),
              max: 10,
              divisions: 20,
              labels: const RangeLabels('0 km', '5 km'),
              onChanged: (values) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Priority'),
              value: 'priority',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Distance'),
              value: 'distance',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('Time'),
              value: 'time',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDetails(VerificationRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(request.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request.description),
              const SizedBox(height: 12),
              Text('Location:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request.location),
              const SizedBox(height: 12),
              Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request.category),
              const SizedBox(height: 12),
              Text('Citizen Contact:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${request.citizenName} - ${request.citizenContact}'),
              const SizedBox(height: 12),
              Text('Estimated Time:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request.estimatedTime),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startVerification(request);
            },
            child: const Text('Start Verification'),
          ),
        ],
      ),
    );
  }

  void _startVerification(VerificationRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are about to start verification for:'),
            const SizedBox(height: 8),
            Text(
              request.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Verification Steps:'),
            const SizedBox(height: 8),
            const Text('1. Navigate to the location'),
            const Text('2. Verify the reported issue'),
            const Text('3. Take photos for evidence'),
            const Text('4. Submit verification report'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Here you would typically navigate to a verification details screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Started verification for ${request.title}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Accept & Start'),
          ),
        ],
      ),
    );
  }
}
