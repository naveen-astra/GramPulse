import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FundAllocationScreen extends StatelessWidget {
  const FundAllocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fund Allocation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetOverview(),
            const SizedBox(height: 24),
            _buildAllocationChart(),
            const SizedBox(height: 24),
            _buildDepartmentAllocations(),
            const SizedBox(height: 24),
            _buildRecentTransactions(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement new allocation
        },
        icon: const Icon(Icons.add),
        label: const Text('New Allocation'),
      ),
    );
  }

  Widget _buildBudgetOverview() {
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
                  'Budget Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'FY 2025-26',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBudgetMetric(
                  title: 'Total Budget',
                  value: '₹ 12.8 Cr',
                  color: Colors.blue,
                ),
                _buildBudgetMetric(
                  title: 'Allocated',
                  value: '₹ 9.6 Cr',
                  color: Colors.green,
                ),
                _buildBudgetMetric(
                  title: 'Utilized',
                  value: '₹ 7.2 Cr',
                  color: Colors.orange,
                ),
                _buildBudgetMetric(
                  title: 'Remaining',
                  value: '₹ 3.2 Cr',
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Budget Utilization',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 7.2 / 12.8,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '56% Utilized',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  '44% Remaining',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetMetric({
    required String title,
    required String value,
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
            Icons.currency_rupee,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAllocationChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Department-wise Allocation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: 25,
                            title: '25%',
                            color: Colors.blue,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: 20,
                            title: '20%',
                            color: Colors.green,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: 18,
                            title: '18%',
                            color: Colors.orange,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: 15,
                            title: '15%',
                            color: Colors.purple,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: 12,
                            title: '12%',
                            color: Colors.red,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: 10,
                            title: '10%',
                            color: Colors.teal,
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildChartLegendItem(
                        color: Colors.blue,
                        label: 'Infrastructure',
                        percentage: '25%',
                      ),
                      const SizedBox(height: 8),
                      _buildChartLegendItem(
                        color: Colors.green,
                        label: 'Water Supply',
                        percentage: '20%',
                      ),
                      const SizedBox(height: 8),
                      _buildChartLegendItem(
                        color: Colors.orange,
                        label: 'Sanitation',
                        percentage: '18%',
                      ),
                      const SizedBox(height: 8),
                      _buildChartLegendItem(
                        color: Colors.purple,
                        label: 'Education',
                        percentage: '15%',
                      ),
                      const SizedBox(height: 8),
                      _buildChartLegendItem(
                        color: Colors.red,
                        label: 'Healthcare',
                        percentage: '12%',
                      ),
                      const SizedBox(height: 8),
                      _buildChartLegendItem(
                        color: Colors.teal,
                        label: 'Others',
                        percentage: '10%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Download report
                },
                icon: const Icon(Icons.download),
                label: const Text('Download Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegendItem({
    required Color color,
    required String label,
    required String percentage,
  }) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          percentage,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentAllocations() {
    final departments = [
      {
        'name': 'Infrastructure',
        'allocated': '₹ 2.4 Cr',
        'utilized': '₹ 1.8 Cr',
        'progress': 0.75,
      },
      {
        'name': 'Water Supply',
        'allocated': '₹ 1.92 Cr',
        'utilized': '₹ 1.35 Cr',
        'progress': 0.70,
      },
      {
        'name': 'Sanitation',
        'allocated': '₹ 1.73 Cr',
        'utilized': '₹ 1.21 Cr',
        'progress': 0.70,
      },
      {
        'name': 'Education',
        'allocated': '₹ 1.44 Cr',
        'utilized': '₹ 0.86 Cr',
        'progress': 0.60,
      },
      {
        'name': 'Healthcare',
        'allocated': '₹ 1.15 Cr',
        'utilized': '₹ 0.92 Cr',
        'progress': 0.80,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Department Allocations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: 'FY 2025-26',
              onChanged: (String? newValue) {
                // TODO: Handle dropdown change
              },
              underline: Container(),
              items: <String>['FY 2025-26', 'FY 2024-25', 'FY 2023-24']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...departments.map((dept) => _buildDepartmentAllocationItem(dept)).toList(),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              // TODO: View all departments
            },
            child: const Text('View All Departments'),
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentAllocationItem(Map<String, dynamic> dept) {
    final progress = dept['progress'] as double;
    Color progressColor;

    if (progress >= 0.8) {
      progressColor = Colors.red;
    } else if (progress >= 0.7) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dept['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // TODO: Show more options
                  },
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
                      dept['allocated'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Utilized',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      dept['utilized'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Utilization',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: progressColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  color: progressColor,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final transactions = [
      {
        'id': 'TRX-8754',
        'department': 'Infrastructure',
        'amount': '₹ 24,50,000',
        'date': 'Aug 22, 2025',
        'purpose': 'Road Repair Project - Phase 2',
        'status': 'Approved',
      },
      {
        'id': 'TRX-8745',
        'department': 'Water Supply',
        'amount': '₹ 18,75,000',
        'date': 'Aug 18, 2025',
        'purpose': 'Water Pipeline Extension',
        'status': 'Approved',
      },
      {
        'id': 'TRX-8732',
        'department': 'Education',
        'amount': '₹ 12,80,000',
        'date': 'Aug 15, 2025',
        'purpose': 'School Renovation Project',
        'status': 'Pending',
      },
      {
        'id': 'TRX-8726',
        'department': 'Healthcare',
        'amount': '₹ 8,45,000',
        'date': 'Aug 12, 2025',
        'purpose': 'Medical Equipment Purchase',
        'status': 'Rejected',
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
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: View all transactions
                  },
                  icon: const Icon(Icons.history),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Purpose')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: transactions.map((trx) {
                  return DataRow(
                    cells: [
                      DataCell(Text(
                        trx['id'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      DataCell(Text(trx['department'] as String)),
                      DataCell(Text(
                        trx['amount'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      DataCell(Text(trx['date'] as String)),
                      DataCell(Text(trx['purpose'] as String)),
                      DataCell(_getStatusChip(trx['status'] as String)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, size: 20),
                              onPressed: () {
                                // TODO: View transaction details
                              },
                              tooltip: 'View Details',
                            ),
                            IconButton(
                              icon: const Icon(Icons.description, size: 20),
                              onPressed: () {
                                // TODO: View receipt
                              },
                              tooltip: 'View Receipt',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStatusChip(String status) {
    Color chipColor;
    Color textColor = Colors.white;

    switch (status) {
      case 'Approved':
        chipColor = Colors.green;
        break;
      case 'Pending':
        chipColor = Colors.orange;
        break;
      case 'Rejected':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
