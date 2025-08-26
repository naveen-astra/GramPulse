import 'package:flutter/material.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reports'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _demoReports.length,
        itemBuilder: (context, index) {
          final report = _demoReports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        report['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      _getStatusChip(report['status']),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report['description'],
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        report['location'],
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
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Reported on ${report['date']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement view details
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View Details'),
                      ),
                      if (report['status'] != 'Resolved')
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Implement follow up
                          },
                          icon: const Icon(Icons.message),
                          label: const Text('Follow Up'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement new report
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getStatusChip(String status) {
    Color chipColor;
    Color textColor = Colors.white;

    switch (status) {
      case 'Pending':
        chipColor = Colors.orange;
        break;
      case 'In Progress':
        chipColor = Colors.blue;
        break;
      case 'Resolved':
        chipColor = Colors.green;
        break;
      case 'Rejected':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Demo data
  static const List<Map<String, dynamic>> _demoReports = [
    const {
      'title': 'Water Leakage',
      'description': 'There is a major water pipe leakage near the community park entrance causing flooding on the pathway',
      'location': 'Community Park, Gandhi Road',
      'date': 'Aug 25, 2025',
      'status': 'In Progress',
    },
    const {
      'title': 'Street Light Not Working',
      'description': 'The street light at the corner of Gandhi Road and Nehru Street has been out for a week, creating a safety hazard at night',
      'location': 'Gandhi Road & Nehru Street Junction',
      'date': 'Aug 20, 2025',
      'status': 'Pending',
    },
    const {
      'title': 'Garbage Collection Issue',
      'description': 'Garbage has not been collected from our street for the past 3 days, causing sanitation concerns',
      'location': 'Residential Block 4, Ambedkar Nagar',
      'date': 'Aug 18, 2025',
      'status': 'Resolved',
    },
    const {
      'title': 'Pothole on Main Road',
      'description': 'Large pothole on the main road near the bus stop. Already caused damage to multiple vehicles',
      'location': 'Main Road, opposite Government School',
      'date': 'Aug 15, 2025',
      'status': 'Rejected',
    },
  ];
}
