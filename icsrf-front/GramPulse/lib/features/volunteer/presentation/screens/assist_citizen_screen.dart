import 'package:flutter/material.dart';

class AssistCitizenScreen extends StatelessWidget {
  const AssistCitizenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assist Citizens'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Help Citizens',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guide citizens through government schemes and services',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Assistance categories
            const Text(
              'How can you help?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _AssistanceCard(
                  title: 'Scheme Guidance',
                  description: 'Help citizens understand and apply for government schemes',
                  icon: Icons.assignment,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SchemeGuidanceScreen()),
                    );
                  },
                ),
                _AssistanceCard(
                  title: 'Document Help',
                  description: 'Assist with document verification and submission',
                  icon: Icons.description,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const DocumentHelpScreen()),
                    );
                  },
                ),
                _AssistanceCard(
                  title: 'SHG Support',
                  description: 'Guide Self-Help Groups in their activities',
                  icon: Icons.group,
                  color: Colors.purple,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SHGSupportScreen()),
                    );
                  },
                ),
                _AssistanceCard(
                  title: 'Training Sessions',
                  description: 'Organize and conduct awareness sessions',
                  icon: Icons.school,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TrainingSessionsScreen()),
                    );
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Recent assistance requests
            const Text(
              'Recent Assistance Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return _AssistanceRequestCard(
                  index: index,
                  onRespond: () {
                    // Handle respond to request
                  },
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Quick actions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
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
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Create assistance session
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('New Session'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // View all requests
                          },
                          icon: const Icon(Icons.list),
                          label: const Text('All Requests'),
                          style: OutlinedButton.styleFrom(
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
      ),
    );
  }
}

class _AssistanceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AssistanceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssistanceRequestCard extends StatelessWidget {
  final int index;
  final VoidCallback onRespond;

  const _AssistanceRequestCard({
    required this.index,
    required this.onRespond,
  });

  @override
  Widget build(BuildContext context) {
    final requests = [
      {
        'name': 'Sunita Devi',
        'request': 'Need help applying for PM Awas Yojana',
        'time': '2 hours ago',
        'priority': 'High',
      },
      {
        'name': 'Ramesh Kumar',
        'request': 'Document verification for farmer loan',
        'time': '5 hours ago',
        'priority': 'Medium',
      },
      {
        'name': 'Mahila Samuh Group',
        'request': 'Training session on digital payments',
        'time': '1 day ago',
        'priority': 'Low',
      },
    ];

    final request = requests[index];
    Color priorityColor;
    switch (request['priority']) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request['name']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  request['priority']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: priorityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            request['request']!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request['time']!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              ElevatedButton(
                onPressed: onRespond,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Respond'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Comprehensive screens for volunteer assistance
class SchemeGuidanceScreen extends StatelessWidget {
  const SchemeGuidanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheme Guidance'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade600, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.assignment, color: Colors.white, size: 32),
                  const SizedBox(height: 12),
                  const Text(
                    'Government Schemes Guide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Help citizens understand and apply for schemes',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Popular Schemes
            const Text(
              'Popular Government Schemes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildSchemeCard(
              title: 'PM Awas Yojana',
              description: 'Housing for All - Financial assistance for housing',
              eligibility: 'Annual income below ₹18 lakhs',
              benefits: 'Interest subsidy up to ₹2.67 lakhs',
              icon: Icons.home,
              color: Colors.green,
            ),
            
            _buildSchemeCard(
              title: 'Jan Dhan Yojana',
              description: 'Financial inclusion through bank accounts',
              eligibility: 'All Indian citizens',
              benefits: 'Free bank account, RuPay debit card',
              icon: Icons.account_balance,
              color: Colors.orange,
            ),
            
            _buildSchemeCard(
              title: 'Ayushman Bharat',
              description: 'Healthcare coverage for poor families',
              eligibility: 'Socio-economic caste census eligible families',
              benefits: 'Health cover up to ₹5 lakhs per family',
              icon: Icons.local_hospital,
              color: Colors.red,
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showSchemeSearchDialog(context);
                          },
                          icon: const Icon(Icons.search),
                          label: const Text('Search Schemes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showApplicationGuideDialog(context);
                          },
                          icon: const Icon(Icons.help_outline),
                          label: const Text('How to Apply'),
                          style: OutlinedButton.styleFrom(
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
      ),
    );
  }

  Widget _buildSchemeCard({
    required String title,
    required String description,
    required String eligibility,
    required String benefits,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
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
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Eligibility: $eligibility',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Benefits: $benefits',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSchemeSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Schemes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter keywords or category',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Popular categories:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(label: Text('Housing')),
                Chip(label: Text('Healthcare')),
                Chip(label: Text('Education')),
                Chip(label: Text('Agriculture')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showApplicationGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Apply'),
        content: const Text(
          '1. Check eligibility criteria\n'
          '2. Gather required documents\n'
          '3. Visit nearest service center\n'
          '4. Fill application form\n'
          '5. Submit with documents\n'
          '6. Track application status',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class DocumentHelpScreen extends StatelessWidget {
  const DocumentHelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Help'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade600, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.description, color: Colors.white, size: 32),
                  const SizedBox(height: 12),
                  const Text(
                    'Document Verification & Help',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Assist citizens with document verification and submission',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Document Categories
            const Text(
              'Document Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _buildDocumentCategory(
                  title: 'Identity Proof',
                  documents: ['Aadhaar Card', 'PAN Card', 'Voter ID', 'Passport'],
                  icon: Icons.person,
                  color: Colors.blue,
                  context: context,
                ),
                _buildDocumentCategory(
                  title: 'Address Proof',
                  documents: ['Electricity Bill', 'Gas Bill', 'Bank Statement', 'Rent Agreement'],
                  icon: Icons.home,
                  color: Colors.green,
                  context: context,
                ),
                _buildDocumentCategory(
                  title: 'Income Proof',
                  documents: ['Salary Slip', 'ITR', 'Form 16', 'Bank Statement'],
                  icon: Icons.monetization_on,
                  color: Colors.amber,
                  context: context,
                ),
                _buildDocumentCategory(
                  title: 'Educational',
                  documents: ['10th Marksheet', '12th Marksheet', 'Degree Certificate', 'TC'],
                  icon: Icons.school,
                  color: Colors.purple,
                  context: context,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Verification Checklist
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Document Verification Checklist',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildChecklistItem('Check document authenticity'),
                  _buildChecklistItem('Verify personal details match'),
                  _buildChecklistItem('Ensure documents are not expired'),
                  _buildChecklistItem('Check photo clarity and quality'),
                  _buildChecklistItem('Verify official seals/signatures'),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showDocumentScanDialog(context);
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Scan Document'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showVerificationGuideDialog(context);
                          },
                          icon: const Icon(Icons.checklist),
                          label: const Text('Verification Guide'),
                          style: OutlinedButton.styleFrom(
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
      ),
    );
  }

  Widget _buildDocumentCategory({
    required String title,
    required List<String> documents,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        _showDocumentListDialog(context, title, documents);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${documents.length} documents',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  void _showDocumentListDialog(BuildContext context, String title, List<String> documents) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: documents.map((doc) => ListTile(
            leading: const Icon(Icons.description),
            title: Text(doc),
            dense: true,
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDocumentScanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document Scanner'),
        content: const Text(
          'This feature would integrate with camera to scan and verify documents.\n\n'
          'Features:\n'
          '• OCR text extraction\n'
          '• Document quality check\n'
          '• Real-time verification\n'
          '• Template matching',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVerificationGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Guide'),
        content: const Text(
          'Document Verification Steps:\n\n'
          '1. Check document format and layout\n'
          '2. Verify security features (watermarks, etc.)\n'
          '3. Cross-check personal details\n'
          '4. Validate expiry dates\n'
          '5. Confirm issuing authority\n'
          '6. Check for tampering signs',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class SHGSupportScreen extends StatelessWidget {
  const SHGSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SHG Support'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade600, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.group, color: Colors.white, size: 32),
                  const SizedBox(height: 12),
                  const Text(
                    'Self-Help Group Support',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Coordinate and support SHG activities in your community',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // SHG Activities
            const Text(
              'SHG Activities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildActivityCard(
              context: context,
              title: 'Group Formation',
              description: 'Help form new SHGs with 10-20 members',
              icon: Icons.group_add,
              color: Colors.blue,
              onTap: () => _showGroupFormationDialog(context),
            ),
            
            const SizedBox(height: 12),
            
            _buildActivityCard(
              context: context,
              title: 'Meeting Coordination',
              description: 'Schedule and organize weekly/monthly meetings',
              icon: Icons.event,
              color: Colors.green,
              onTap: () => _showMeetingDialog(context),
            ),
            
            const SizedBox(height: 12),
            
            _buildActivityCard(
              context: context,
              title: 'Financial Training',
              description: 'Provide training on savings and microfinance',
              icon: Icons.school,
              color: Colors.orange,
              onTap: () => _showTrainingDialog(context),
            ),
            
            const SizedBox(height: 12),
            
            _buildActivityCard(
              context: context,
              title: 'Loan Assistance',
              description: 'Help members access microfinance and bank loans',
              icon: Icons.monetization_on,
              color: Colors.amber,
              onTap: () => _showLoanDialog(context),
            ),
            
            const SizedBox(height: 24),
            
            // SHG Management Tools
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SHG Management Tools',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildToolButton(
                          context: context,
                          title: 'Member Registry',
                          icon: Icons.people,
                          onTap: () => _showMemberRegistryDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildToolButton(
                          context: context,
                          title: 'Savings Tracker',
                          icon: Icons.savings,
                          onTap: () => _showSavingsTrackerDialog(context),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildToolButton(
                          context: context,
                          title: 'Activity Log',
                          icon: Icons.history,
                          onTap: () => _showActivityLogDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildToolButton(
                          context: context,
                          title: 'Reports',
                          icon: Icons.analytics,
                          onTap: () => _showReportsDialog(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showNewSHGDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create New SHG'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showSHGDirectoryDialog(context);
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('SHG Directory'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildActivityCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.purple.shade600, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showGroupFormationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Group Formation'),
        content: const Text(
          'Steps to form a new SHG:\n\n'
          '1. Identify 10-20 interested women\n'
          '2. Conduct awareness meetings\n'
          '3. Form group with common interests\n'
          '4. Select group leader and secretary\n'
          '5. Open group savings account\n'
          '6. Register with local authorities',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMeetingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Meeting Coordination'),
        content: const Text(
          'Meeting Management:\n\n'
          '• Schedule regular meetings (weekly/monthly)\n'
          '• Prepare agenda in advance\n'
          '• Track attendance and participation\n'
          '• Record meeting minutes\n'
          '• Follow up on decisions made\n'
          '• Share updates with members',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTrainingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Financial Training'),
        content: const Text(
          'Training Topics:\n\n'
          '• Basic financial literacy\n'
          '• Savings and investment\n'
          '• Loan management\n'
          '• Record keeping\n'
          '• Business planning\n'
          '• Digital payment systems',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLoanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Loan Assistance'),
        content: const Text(
          'Loan Support Services:\n\n'
          '• Help prepare loan applications\n'
          '• Connect with banks and financial institutions\n'
          '• Assist with documentation\n'
          '• Monitor repayment schedules\n'
          '• Provide financial counseling\n'
          '• Link to government schemes',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMemberRegistryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Member Registry'),
        content: const Text(
          'This feature would manage:\n\n'
          '• Member profiles and contact details\n'
          '• Membership status and roles\n'
          '• Attendance tracking\n'
          '• Skills and capabilities\n'
          '• Individual savings records',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSavingsTrackerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Savings Tracker'),
        content: const Text(
          'Track group and individual savings:\n\n'
          '• Monthly savings contributions\n'
          '• Interest calculations\n'
          '• Withdrawal records\n'
          '• Total group corpus\n'
          '• Individual balances',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showActivityLogDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Log'),
        content: const Text(
          'Track all SHG activities:\n\n'
          '• Meeting records\n'
          '• Training sessions\n'
          '• Loan disbursements\n'
          '• Member activities\n'
          '• Financial transactions',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showReportsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reports'),
        content: const Text(
          'Generate comprehensive reports:\n\n'
          '• Monthly financial statements\n'
          '• Member activity reports\n'
          '• Loan performance analysis\n'
          '• Training effectiveness\n'
          '• Group progress summary',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNewSHGDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New SHG'),
        content: const Text(
          'This feature would help you:\n\n'
          '• Register a new Self-Help Group\n'
          '• Add founding members\n'
          '• Set up group structure\n'
          '• Configure savings rules\n'
          '• Create meeting schedule',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSHGDirectoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SHG Directory'),
        content: const Text(
          'Browse local SHGs:\n\n'
          '• View all registered SHGs\n'
          '• Contact information\n'
          '• Group activities and focus\n'
          '• Performance metrics\n'
          '• Collaboration opportunities',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class TrainingSessionsScreen extends StatelessWidget {
  const TrainingSessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Sessions'),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade600, Colors.teal.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.school, color: Colors.white, size: 32),
                  const SizedBox(height: 12),
                  const Text(
                    'Training & Awareness Sessions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Organize and conduct community training programs',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Upcoming Sessions
            const Text(
              'Upcoming Sessions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildSessionCard(
              context: context,
              title: 'Digital Literacy Training',
              date: 'Tomorrow, 10:00 AM',
              participants: '15 registered',
              type: 'Technology',
              color: Colors.blue,
            ),
            
            const SizedBox(height: 12),
            
            _buildSessionCard(
              context: context,
              title: 'Women Empowerment Workshop',
              date: 'March 25, 2:00 PM',
              participants: '20 registered',
              type: 'Social',
              color: Colors.pink,
            ),
            
            const SizedBox(height: 12),
            
            _buildSessionCard(
              context: context,
              title: 'Health & Hygiene Awareness',
              date: 'March 28, 11:00 AM',
              participants: '25 registered',
              type: 'Health',
              color: Colors.green,
            ),
            
            const SizedBox(height: 24),
            
            // Training Categories
            const Text(
              'Training Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
              children: [
                _buildCategoryCard(
                  context: context,
                  title: 'Digital Skills',
                  sessions: '12 sessions',
                  icon: Icons.computer,
                  color: Colors.blue,
                  topics: ['Basic Computer', 'Internet Usage', 'Digital Payments', 'Online Services'],
                ),
                _buildCategoryCard(
                  context: context,
                  title: 'Health & Wellness',
                  sessions: '8 sessions',
                  icon: Icons.health_and_safety,
                  color: Colors.green,
                  topics: ['Nutrition', 'Hygiene', 'First Aid', 'Mental Health'],
                ),
                _buildCategoryCard(
                  context: context,
                  title: 'Financial Literacy',
                  sessions: '10 sessions',
                  icon: Icons.account_balance,
                  color: Colors.orange,
                  topics: ['Banking', 'Savings', 'Insurance', 'Investments'],
                ),
                _buildCategoryCard(
                  context: context,
                  title: 'Skill Development',
                  sessions: '15 sessions',
                  icon: Icons.build,
                  color: Colors.purple,
                  topics: ['Tailoring', 'Handicrafts', 'Agriculture', 'Small Business'],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Session Management Tools
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Session Management',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildManagementButton(
                          context: context,
                          title: 'Schedule Session',
                          icon: Icons.add_circle,
                          onTap: () => _showScheduleSessionDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildManagementButton(
                          context: context,
                          title: 'Attendance',
                          icon: Icons.how_to_reg,
                          onTap: () => _showAttendanceDialog(context),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildManagementButton(
                          context: context,
                          title: 'Resources',
                          icon: Icons.library_books,
                          onTap: () => _showResourcesDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildManagementButton(
                          context: context,
                          title: 'Feedback',
                          icon: Icons.feedback,
                          onTap: () => _showFeedbackDialog(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showCreateSessionDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showSessionHistoryDialog(context);
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Session History'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildSessionCard({
    required BuildContext context,
    required String title,
    required String date,
    required String participants,
    required String type,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                date,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.people, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                participants,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String sessions,
    required IconData icon,
    required Color color,
    required List<String> topics,
  }) {
    return GestureDetector(
      onTap: () {
        _showTopicsDialog(context, title, topics);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sessions,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.teal.shade600, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showTopicsDialog(BuildContext context, String title, List<String> topics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: topics.map((topic) => ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green),
            title: Text(topic),
            dense: true,
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showScheduleSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Session'),
        content: const Text(
          'This feature would allow you to:\n\n'
          '• Set session date and time\n'
          '• Choose training category\n'
          '• Define target audience\n'
          '• Set participant limit\n'
          '• Add session description\n'
          '• Send invitations',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attendance Management'),
        content: const Text(
          'Track session attendance:\n\n'
          '• Mark participants present/absent\n'
          '• Generate attendance reports\n'
          '• Track individual participation\n'
          '• Send follow-up messages\n'
          '• Identify regular attendees',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showResourcesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Training Resources'),
        content: const Text(
          'Access training materials:\n\n'
          '• Presentation slides\n'
          '• Video tutorials\n'
          '• Handouts and worksheets\n'
          '• Assessment forms\n'
          '• Reference materials\n'
          '• Interactive tools',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Feedback'),
        content: const Text(
          'Collect and analyze feedback:\n\n'
          '• Session effectiveness ratings\n'
          '• Participant satisfaction\n'
          '• Suggestions for improvement\n'
          '• Content relevance feedback\n'
          '• Trainer performance review',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCreateSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Session'),
        content: const Text(
          'This would open a form to:\n\n'
          '• Select training category\n'
          '• Set session details\n'
          '• Choose venue and timing\n'
          '• Add session objectives\n'
          '• Prepare training materials\n'
          '• Invite participants',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSessionHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session History'),
        content: const Text(
          'View past training sessions:\n\n'
          '• Completed sessions list\n'
          '• Attendance records\n'
          '• Feedback summaries\n'
          '• Impact assessments\n'
          '• Success stories\n'
          '• Improvement areas',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
