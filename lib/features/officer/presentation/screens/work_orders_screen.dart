import 'package:flutter/material.dart';

class WorkOrdersScreen extends StatelessWidget {
  const WorkOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Show search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildWorkOrderList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create new work order
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: DefaultTabController(
        length: 4,
        child: TabBar(
          indicatorColor: Colors.indigo,
          labelColor: Colors.indigo,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All Orders'),
            Tab(text: 'Pending'),
            Tab(text: 'In Progress'),
            Tab(text: 'Completed'),
          ],
          onTap: (index) {
            // TODO: Switch tabs
          },
        ),
      ),
    );
  }

  Widget _buildWorkOrderList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWorkOrderItem(
          id: 'WO-2023-157',
          title: 'Pipeline Repair',
          description: 'Fix leaking pipeline at Main Road junction',
          location: 'Main Road, Market Area',
          assignedTo: 'Technician: Ravi Kumar',
          dueDate: 'Aug 15, 2023',
          status: 'In Progress',
          statusColor: Colors.blue,
          progress: 0.6,
        ),
        _buildWorkOrderItem(
          id: 'WO-2023-153',
          title: 'Water Testing',
          description: 'Collect and test water samples from community well',
          location: 'Community Well, Northern Block',
          assignedTo: 'Lab Technician: Anjali Sharma',
          dueDate: 'Aug 18, 2023',
          status: 'Scheduled',
          statusColor: Colors.purple,
          progress: 0.2,
        ),
        _buildWorkOrderItem(
          id: 'WO-2023-149',
          title: 'Pump Maintenance',
          description: 'Regular maintenance of main water pump',
          location: 'Water Treatment Plant',
          assignedTo: 'Engineer: Suresh Patel',
          dueDate: 'Aug 10, 2023',
          status: 'Completed',
          statusColor: Colors.green,
          progress: 1.0,
        ),
        _buildWorkOrderItem(
          id: 'WO-2023-145',
          title: 'Tank Cleaning',
          description: 'Clean and sanitize the community water tank',
          location: 'Central Area, Block 3',
          assignedTo: 'Unassigned',
          dueDate: 'Aug 25, 2023',
          status: 'Pending',
          statusColor: Colors.orange,
          progress: 0.0,
        ),
        _buildWorkOrderItem(
          id: 'WO-2023-142',
          title: 'Valve Replacement',
          description: 'Replace faulty water valve at distribution point',
          location: 'Southern Sector, Near School',
          assignedTo: 'Technician: Mohan Singh',
          dueDate: 'Aug 20, 2023',
          status: 'In Progress',
          statusColor: Colors.blue,
          progress: 0.4,
        ),
      ],
    );
  }

  Widget _buildWorkOrderItem({
    required String id,
    required String title,
    required String description,
    required String location,
    required String assignedTo,
    required String dueDate,
    required String status,
    required Color statusColor,
    required double progress,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Open work order details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.work,
                    color: Colors.indigo,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    id,
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          assignedTo,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Due: $dueDate',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Progress',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _getProgressColor(progress),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text('View'),
                        onPressed: () {
                          // TODO: View work order details
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Update'),
                        onPressed: () {
                          // TODO: Update work order
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }
}
