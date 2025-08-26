import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Management'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Citizens'),
              Tab(text: 'Volunteers'),
              Tab(text: 'Officers'),
              Tab(text: 'Admins'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Show search
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: Show filters
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildUserList(userType: 'Citizen'),
            _buildUserList(userType: 'Volunteer'),
            _buildUserList(userType: 'Officer'),
            _buildUserList(userType: 'Admin'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Add new user
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildUserList({required String userType}) {
    // Generate sample users based on type
    final List<Map<String, dynamic>> users = _generateSampleUsers(userType);
    
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _buildUserCard(users[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          _buildFilterChip(label: 'Active', isSelected: true),
          _buildFilterChip(label: 'Verified', isSelected: false),
          _buildFilterChip(label: 'New', isSelected: false),
          _buildFilterChip(label: 'Blocked', isSelected: false),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected}) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // TODO: Handle filter selection
      },
      selectedColor: Colors.blue.withOpacity(0.2),
      checkmarkColor: Colors.blue,
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage(user['image']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['email'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(user['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user['status'],
                              style: TextStyle(
                                color: _getStatusColor(user['status']),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (user['verified'])
                            const Icon(Icons.verified_user, color: Colors.green, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    // TODO: Handle menu selection
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit User'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'block',
                      child: Text('Block User'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete User'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUserStat(
                    label: 'Joined',
                    value: user['joined'],
                    icon: Icons.calendar_today,
                  ),
                  _buildUserStat(
                    label: 'Location',
                    value: user['location'],
                    icon: Icons.location_on,
                  ),
                  _buildUserStat(
                    label: 'Last Active',
                    value: user['lastActive'],
                    icon: Icons.access_time,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  label: 'Reset Password',
                  icon: Icons.lock_reset,
                  color: Colors.orange,
                ),
                _buildActionButton(
                  label: 'Edit Permissions',
                  icon: Icons.security,
                  color: Colors.blue,
                ),
                _buildActionButton(
                  label: 'View Activity',
                  icon: Icons.history,
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return TextButton.icon(
      onPressed: () {
        // TODO: Handle button press
      },
      icon: Icon(icon, color: color, size: 16),
      label: Text(
        label,
        style: TextStyle(color: color, fontSize: 12),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Inactive':
        return Colors.orange;
      case 'Blocked':
        return Colors.red;
      case 'Pending':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _generateSampleUsers(String userType) {
    // This would normally come from a database or API
    if (userType == 'Citizen') {
      return [
        {
          'name': 'Rahul Sharma',
          'email': 'rahul.sharma@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '12 Jan 2023',
          'location': 'North District',
          'lastActive': '2 hours ago',
          'image': 'https://randomuser.me/api/portraits/men/32.jpg',
        },
        {
          'name': 'Priya Singh',
          'email': 'priya.singh@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '28 Feb 2023',
          'location': 'South District',
          'lastActive': '5 days ago',
          'image': 'https://randomuser.me/api/portraits/women/44.jpg',
        },
        {
          'name': 'Amit Kumar',
          'email': 'amit.kumar@example.com',
          'status': 'Inactive',
          'verified': true,
          'joined': '15 Mar 2022',
          'location': 'East District',
          'lastActive': '2 months ago',
          'image': 'https://randomuser.me/api/portraits/men/59.jpg',
        },
        {
          'name': 'Neha Gupta',
          'email': 'neha.gupta@example.com',
          'status': 'Blocked',
          'verified': false,
          'joined': '30 Nov 2022',
          'location': 'West District',
          'lastActive': '1 month ago',
          'image': 'https://randomuser.me/api/portraits/women/67.jpg',
        },
        {
          'name': 'Rajesh Patel',
          'email': 'rajesh.patel@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '5 Apr 2023',
          'location': 'Central District',
          'lastActive': '1 day ago',
          'image': 'https://randomuser.me/api/portraits/men/78.jpg',
        },
      ];
    } else if (userType == 'Volunteer') {
      return [
        {
          'name': 'Meena Verma',
          'email': 'meena.verma@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '15 Jan 2023',
          'location': 'North District',
          'lastActive': '1 hour ago',
          'image': 'https://randomuser.me/api/portraits/women/33.jpg',
        },
        {
          'name': 'Suresh Reddy',
          'email': 'suresh.reddy@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '22 Mar 2023',
          'location': 'South District',
          'lastActive': '3 days ago',
          'image': 'https://randomuser.me/api/portraits/men/42.jpg',
        },
        {
          'name': 'Sunita Devi',
          'email': 'sunita.devi@example.com',
          'status': 'Pending',
          'verified': false,
          'joined': '10 Jun 2023',
          'location': 'East District',
          'lastActive': 'Never',
          'image': 'https://randomuser.me/api/portraits/women/56.jpg',
        },
      ];
    } else if (userType == 'Officer') {
      return [
        {
          'name': 'Vikram Singh',
          'email': 'vikram.singh@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '10 Jan 2022',
          'location': 'North District',
          'lastActive': '30 minutes ago',
          'image': 'https://randomuser.me/api/portraits/men/22.jpg',
        },
        {
          'name': 'Kavita Sharma',
          'email': 'kavita.sharma@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '15 Feb 2022',
          'location': 'South District',
          'lastActive': '2 hours ago',
          'image': 'https://randomuser.me/api/portraits/women/26.jpg',
        },
      ];
    } else if (userType == 'Admin') {
      return [
        {
          'name': 'Rajiv Khanna',
          'email': 'rajiv.khanna@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '1 Jan 2022',
          'location': 'Central Office',
          'lastActive': '5 minutes ago',
          'image': 'https://randomuser.me/api/portraits/men/11.jpg',
        },
        {
          'name': 'Sanjay Gupta',
          'email': 'sanjay.gupta@example.com',
          'status': 'Active',
          'verified': true,
          'joined': '5 Jan 2022',
          'location': 'IT Department',
          'lastActive': '1 hour ago',
          'image': 'https://randomuser.me/api/portraits/men/19.jpg',
        },
      ];
    }
    
    return [];
  }
}
