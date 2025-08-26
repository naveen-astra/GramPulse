import 'package:flutter/material.dart';

class AdminFundAllocationScreen extends StatelessWidget {
  const AdminFundAllocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fund Allocation & Relief'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // TODO: Export fund allocation report
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh data
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetOverview(),
            const SizedBox(height: 24),
            _buildDepartmentAllocation(),
            const SizedBox(height: 24),
            _buildReliefFunds(),
            const SizedBox(height: 24),
            _buildRecentTransactions(),
            const SizedBox(height: 24),
            _buildFundRequestsApproval(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Create new fund allocation
        },
        icon: const Icon(Icons.add),
        label: const Text('New Allocation'),
      ),
    );
  }

  Widget _buildBudgetOverview() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget Overview FY 2025-26',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('Q2'),
                  backgroundColor: Colors.blue,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBudgetStat(
                  title: 'Total Budget',
                  amount: '₹ 12.6 Cr',
                  subtitle: 'Annual budget',
                  icon: Icons.account_balance,
                  color: Colors.blue,
                ),
                _buildBudgetStat(
                  title: 'Allocated',
                  amount: '₹ 7.8 Cr',
                  subtitle: '62% of total',
                  icon: Icons.assignment,
                  color: Colors.green,
                ),
                _buildBudgetStat(
                  title: 'Spent',
                  amount: '₹ 4.2 Cr',
                  subtitle: '54% of allocated',
                  icon: Icons.payment,
                  color: Colors.orange,
                ),
                _buildBudgetStat(
                  title: 'Remaining',
                  amount: '₹ 8.4 Cr',
                  subtitle: '38% of total',
                  icon: Icons.account_balance_wallet,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Placeholder for chart
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Budget Utilization Chart',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetStat({
    required String title,
    required String amount,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentAllocation() {
    final departments = [
      {
        'name': 'Water Supply',
        'allocation': '₹ 3.2 Cr',
        'spent': '₹ 1.6 Cr',
        'progress': 0.5,
        'color': Colors.blue,
      },
      {
        'name': 'Roads & Infrastructure',
        'allocation': '₹ 2.5 Cr',
        'spent': '₹ 1.3 Cr',
        'progress': 0.52,
        'color': Colors.orange,
      },
      {
        'name': 'Healthcare',
        'allocation': '₹ 2.1 Cr',
        'spent': '₹ 0.8 Cr',
        'progress': 0.38,
        'color': Colors.red,
      },
      {
        'name': 'Education',
        'allocation': '₹ 1.8 Cr',
        'spent': '₹ 0.6 Cr',
        'progress': 0.33,
        'color': Colors.green,
      },
      {
        'name': 'Sanitation',
        'allocation': '₹ 1.5 Cr',
        'spent': '₹ 0.4 Cr',
        'progress': 0.27,
        'color': Colors.brown,
      },
      {
        'name': 'Power & Electricity',
        'allocation': '₹ 1.5 Cr',
        'spent': '₹ 0.5 Cr',
        'progress': 0.33,
        'color': Colors.purple,
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Department-wise Allocation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigate to detailed view
                  },
                  child: const Text('Adjust Allocation'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...departments.map((dept) => _buildDepartmentItem(dept)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentItem(Map<String, dynamic> dept) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: dept['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dept['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                'Spent: ${dept['spent']} / ${dept['allocation']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: dept['progress'] as double,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(dept['color'] as Color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildReliefFunds() {
    final reliefFunds = [
      {
        'name': 'Flood Relief Fund',
        'allocation': '₹ 85 Lakh',
        'spent': '₹ 35 Lakh',
        'progress': 0.41,
        'status': 'Active',
        'color': Colors.blue,
      },
      {
        'name': 'Drought Relief Fund',
        'allocation': '₹ 65 Lakh',
        'spent': '₹ 40 Lakh',
        'progress': 0.62,
        'status': 'Active',
        'color': Colors.orange,
      },
      {
        'name': 'COVID-19 Emergency Fund',
        'allocation': '₹ 120 Lakh',
        'spent': '₹ 110 Lakh',
        'progress': 0.92,
        'status': 'Closing',
        'color': Colors.red,
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Relief Funds',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Create new relief fund
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Fund'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...reliefFunds.map((fund) => _buildReliefFundItem(fund)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReliefFundItem(Map<String, dynamic> fund) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (fund['color'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (fund['color'] as Color).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fund['name'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: fund['status'] == 'Active' ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  fund['status'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Allocated',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    fund['allocation'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spent',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    fund['spent'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remaining',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${((1 - (fund['progress'] as double)) * 100).toInt()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      // TODO: Edit fund
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.bar_chart, size: 20),
                    onPressed: () {
                      // TODO: View fund details
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: fund['progress'] as double,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(fund['color'] as Color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = [
      {
        'department': 'Water Supply',
        'purpose': 'Equipment Purchase',
        'amount': '₹ 28,50,000',
        'date': '22 Aug 2025',
        'status': 'Completed',
        'icon': Icons.shopping_cart,
      },
      {
        'department': 'Healthcare',
        'purpose': 'Medical Supplies',
        'amount': '₹ 15,75,000',
        'date': '18 Aug 2025',
        'status': 'Completed',
        'icon': Icons.medical_services,
      },
      {
        'department': 'Flood Relief Fund',
        'purpose': 'Emergency Aid',
        'amount': '₹ 12,00,000',
        'date': '15 Aug 2025',
        'status': 'Completed',
        'icon': Icons.home_work,
      },
      {
        'department': 'Roads & Infrastructure',
        'purpose': 'Road Repair Project',
        'amount': '₹ 32,40,000',
        'date': '10 Aug 2025',
        'status': 'Processing',
        'icon': Icons.architecture,
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all transactions
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...transactions.map((tx) => _buildTransactionItem(tx)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              tx['icon'] as IconData,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx['purpose'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${tx['department']} • ${tx['date']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx['amount'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: tx['status'] == 'Completed' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tx['status'] as String,
                  style: TextStyle(
                    color: tx['status'] == 'Completed' ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFundRequestsApproval() {
    final requests = [
      {
        'department': 'Healthcare',
        'purpose': 'COVID-19 Vaccination Drive',
        'amount': '₹ 45,00,000',
        'requestedBy': 'Dr. Rajesh Sharma',
        'priority': 'High',
        'submitted': '20 Aug 2025',
      },
      {
        'department': 'Education',
        'purpose': 'School Infrastructure Improvement',
        'amount': '₹ 38,50,000',
        'requestedBy': 'Anita Desai',
        'priority': 'Medium',
        'submitted': '18 Aug 2025',
      },
      {
        'department': 'Water Supply',
        'purpose': 'Water Testing Equipment',
        'amount': '₹ 12,75,000',
        'requestedBy': 'Suresh Kumar',
        'priority': 'Medium',
        'submitted': '15 Aug 2025',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pending Fund Requests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: View all requests
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...requests.map((req) => _buildRequestItem(req)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestItem(Map<String, dynamic> req) {
    Color priorityColor;
    switch (req['priority']) {
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    req['purpose'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${req['department']} • Submitted: ${req['submitted']}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: priorityColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.flag,
                      color: priorityColor,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${req['priority']} Priority',
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount Requested',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    req['amount'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Requested By',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    req['requestedBy'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  // TODO: View request details
                },
                child: const Text('View Details'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: Approve request
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Approve'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
