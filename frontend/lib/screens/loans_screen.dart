import 'package:flutter/material.dart';
import 'package:frontend/screens/loan_application_screen.dart';
import 'package:frontend/screens/loan_approval_screen.dart';

class LoansScreen extends StatelessWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _showFilterOptions,
            tooltip: 'Filter Loans',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Actions Section
          _buildQuickActions(context),
          
          // Loan Summary Cards
          _buildLoanSummaryCards(),
          
          // Recent Activity Section
          Expanded(
            child: _buildLoanActivityList(),
          ),
        ],
      ),
    );
  }

  // 1. Quick Action Buttons
  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              context,
              icon: Icons.add_circle_outline,
              label: 'Apply Loan',
              onTap: () => _navigateToLoanApplication(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionCard(
              context,
              icon: Icons.verified_user,
              label: 'Approvals',
              onTap: () => _navigateToLoanApprovals(context),
            ),
          ),
        ],
      ),
    );
  }

  // Action Card Component
  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Loan Summary Visualization
  Widget _buildLoanSummaryCards() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          LoanSummaryCard(
            title: 'Active Loans',
            value: '24',
            color: Colors.green,
          ),
          LoanSummaryCard(
            title: 'Pending',
            value: '5',
            color: Colors.orange,
          ),
          LoanSummaryCard(
            title: 'Overdue',
            value: '3',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  // 3. Recent Loan Activity List
  Widget _buildLoanActivityList() {
    final loans = _mockLoanData();
    
    return ListView.builder(
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];
        return _buildLoanActivityTile(loan);
      },
    );
  }

  // Loan Activity Tile Component
  Widget _buildLoanActivityTile(Map<String, dynamic> loan) {
    Color statusColor;
    switch (loan['status']) {
      case 'active':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'overdue':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.credit_card),
        title: Text('${loan['member']} - KES ${loan['amount']}'),
        subtitle: Text('${loan['type']} • ${loan['date']}'),
        trailing: Chip(
          label: Text(loan['status']),
          backgroundColor: statusColor.withOpacity(0.2),
          labelStyle: TextStyle(color: statusColor),
        ),
        onTap: () {
          // TODO: Navigate to loan details
        },
      ),
    );
  }

  // Navigation Methods
  void _navigateToLoanApplication(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoanApplicationScreen(),
      ),
    );
  }

  void _navigateToLoanApprovals(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoanApprovalScreen(),
      ),
    );
  }

  void _showFilterOptions() {
    // TODO: Implement filter dialog
  }

  List<Map<String, dynamic>> _mockLoanData() => [
    {
      'id': 'LN-2023-045',
      'member': 'John Mwangi',
      'amount': 75000.0,
      'date': '01/06/2023',
      'status': 'active',
      'type': 'Business'
    },
    {
      'id': 'LN-2023-046',
      'member': 'Mary Wambui',
      'amount': 50000.0,
      'date': '05/06/2023',
      'status': 'pending',
      'type': 'Education'
    },
    {
      'id': 'LN-2023-047',
      'member': 'Peter Kamau',
      'amount': 30000.0,
      'date': '10/05/2023',
      'status': 'overdue',
      'type': 'Emergency'
    },
  ];
}

// Loan Summary Card Component (now public)
class LoanSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const LoanSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}