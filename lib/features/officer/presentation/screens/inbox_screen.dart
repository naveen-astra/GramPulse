import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Officer Inbox'),
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
            child: _buildInboxList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Create new issue or message
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: DefaultTabController(
        length: 3,
        child: TabBar(
          indicatorColor: Colors.indigo,
          labelColor: Colors.indigo,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'New Issues'),
            Tab(text: 'In Progress'),
            Tab(text: 'Resolved'),
          ],
          onTap: (index) {
            // TODO: Switch tabs
          },
        ),
      ),
    );
  }

  Widget _buildInboxList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInboxItem(
          title: 'Water Supply Disruption',
          description: 'No water supply for the past 2 days in northern sector',
          sender: 'Citizen: Ramesh Kumar',
          timeAgo: '2 hours ago',
          isUrgent: true,
          isNew: true,
        ),
        _buildInboxItem(
          title: 'Water Quality Complaint',
          description: 'Water appears cloudy and has an unusual odor',
          sender: 'Volunteer: Sunita Devi',
          timeAgo: '4 hours ago',
          isUrgent: false,
          isNew: true,
        ),
        _buildInboxItem(
          title: 'Leaking Pipeline',
          description: 'Water leaking from the main pipeline near the community center',
          sender: 'Citizen: Mohan Singh',
          timeAgo: '12 hours ago',
          isUrgent: false,
          isNew: false,
        ),
        _buildInboxItem(
          title: 'Water Pressure Low',
          description: 'Very low water pressure in the morning hours',
          sender: 'Volunteer: Anjali Sharma',
          timeAgo: '1 day ago',
          isUrgent: false,
          isNew: false,
        ),
        _buildInboxItem(
          title: 'Water Tank Overflow',
          description: 'Municipal water tank is overflowing and causing wastage',
          sender: 'Citizen: Rajesh Verma',
          timeAgo: '2 days ago',
          isUrgent: true,
          isNew: false,
        ),
      ],
    );
  }

  Widget _buildInboxItem({
    required String title,
    required String description,
    required String sender,
    required String timeAgo,
    required bool isUrgent,
    required bool isNew,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Open issue details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isNew)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (isNew) const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isUrgent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Urgent',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
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
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.indigo.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      sender,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
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
                      // TODO: View issue details
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.assignment_turned_in, size: 16),
                    label: const Text('Assign'),
                    onPressed: () {
                      // TODO: Assign issue
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
