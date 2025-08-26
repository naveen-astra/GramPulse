import 'package:flutter/material.dart';

class VerificationQueueScreen extends StatelessWidget {
  const VerificationQueueScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _buildVerificationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip(label: 'All', isSelected: true),
            _buildChip(label: 'High Priority'),
            _buildChip(label: 'Medium Priority'),
            _buildChip(label: 'Low Priority'),
            _buildChip(label: 'Nearby'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({required String label, bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildVerificationList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildVerificationItem(
          title: 'Water Supply Issue',
          description: 'No water supply for the past 2 days in northern sector',
          location: 'North Village, 1.2 km away',
          timeAgo: '32 min ago',
          priority: 'High',
          priorityColor: Colors.red,
          imageUrl: 'https://example.com/water_issue.jpg',
        ),
        _buildVerificationItem(
          title: 'Road Maintenance Required',
          description: 'Potholes and cracks in the main road near village center',
          location: 'Main Street, 0.8 km away',
          timeAgo: '1 hour ago',
          priority: 'Medium',
          priorityColor: Colors.orange,
          imageUrl: 'https://example.com/road_issue.jpg',
        ),
        _buildVerificationItem(
          title: 'Street Light Failure',
          description: 'Three street lights are not working on Market Street',
          location: 'Market Area, 1.5 km away',
          timeAgo: '2 hours ago',
          priority: 'Low',
          priorityColor: Colors.green,
          imageUrl: 'https://example.com/light_issue.jpg',
        ),
        _buildVerificationItem(
          title: 'Public Park Maintenance',
          description: 'Garbage and debris in the public park needs cleaning',
          location: 'Central Park, 2.0 km away',
          timeAgo: '3 hours ago',
          priority: 'Medium',
          priorityColor: Colors.orange,
          imageUrl: 'https://example.com/park_issue.jpg',
        ),
        _buildVerificationItem(
          title: 'School Building Damage',
          description: 'Wall of primary school building has cracks and needs repair',
          location: 'Village School, 1.7 km away',
          timeAgo: '5 hours ago',
          priority: 'High',
          priorityColor: Colors.red,
          imageUrl: 'https://example.com/school_issue.jpg',
        ),
      ],
    );
  }

  Widget _buildVerificationItem({
    required String title,
    required String description,
    required String location,
    required String timeAgo,
    required String priority,
    required Color priorityColor,
    String? imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.map),
                        label: const Text('View on Map'),
                        onPressed: () {
                          // TODO: View on map
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.verified_user),
                        label: const Text('Verify'),
                        onPressed: () {
                          // TODO: Start verification process
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
