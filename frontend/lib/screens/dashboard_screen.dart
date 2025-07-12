import 'package:flutter/material.dart';
import 'package:frontend/screens/members_screen.dart';
import 'package:frontend/screens/add_member_screen.dart';
import 'package:frontend/screens/loan_application_screen.dart';
import 'package:frontend/screens/loan_approval_screen.dart';
import 'package:frontend/screens/savings_screen.dart';
import 'package:frontend/screens/reports_screen.dart';
import 'package:frontend/screens/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data - replace with actual API calls
  final Map<String, dynamic> _dashboardData = {
    'totalMembers': 1248,
    'activeMembers': 1156,
    'inactiveMembers': 92,
    'totalSavings': 2450000.00,
    'monthlyContributions': 450000.00,
    'voluntarySavings': 340000.00,
    'pendingLoans': 23,
    'approvedLoans': 156,
    'activeLoans': 89,
    'defaultedLoans': 8,
    'totalLoanAmount': 5600000.00,
    'repaidAmount': 3400000.00,
    'overdueAmount': 120000.00,
    'newMembersThisMonth': 15,
    'loansApprovedThisMonth': 12,
    'savingsThisMonth': 450000.00,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrative Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToScreen(const SettingsScreen()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(),
              const SizedBox(height: 20),
              _buildMembershipOverview(),
              const SizedBox(height: 20),
              _buildFinancialOverview(),
              const SizedBox(height: 20),
              _buildLoanManagement(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              _buildRecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Members',
                _dashboardData['totalMembers'].toString(),
                Icons.people,
                Colors.blue,
                '+${_dashboardData['newMembersThisMonth']} this month',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Total Savings',
                'KES ${_formatCurrency(_dashboardData['totalSavings'])}',
                Icons.savings,
                Colors.green,
                '+KES ${_formatCurrency(_dashboardData['savingsThisMonth'])} this month',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Active Loans',
                _dashboardData['activeLoans'].toString(),
                Icons.account_balance_wallet,
                Colors.orange,
                'KES ${_formatCurrency(_dashboardData['totalLoanAmount'])} total',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Pending Approvals',
                _dashboardData['pendingLoans'].toString(),
                Icons.pending_actions,
                Colors.red,
                'Requires attention',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
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

  Widget _buildMembershipOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Membership Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToScreen(const MembersScreen()),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Active Members',
                    _dashboardData['activeMembers'].toString(),
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Inactive Members',
                    _dashboardData['inactiveMembers'].toString(),
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'New This Month',
                    _dashboardData['newMembersThisMonth'].toString(),
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _navigateToScreen(const AddMemberScreen()),
              icon: const Icon(Icons.person_add),
              label: const Text('Add New Member'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Financial Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _navigateToScreen(const SavingsScreen()),
                  child: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFinancialItem(
              'Monthly Contributions',
              'KES ${_formatCurrency(_dashboardData['monthlyContributions'])}',
              Icons.calendar_today,
              Colors.blue,
            ),
            _buildFinancialItem(
              'Voluntary Savings',
              'KES ${_formatCurrency(_dashboardData['voluntarySavings'])}',
              Icons.volunteer_activism,
              Colors.purple,
            ),
            _buildFinancialItem(
              'Total Savings',
              'KES ${_formatCurrency(_dashboardData['totalSavings'])}',
              Icons.savings,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialItem(String title, String amount, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanManagement() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loan Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildLoanStatCard(
                    'Pending',
                    _dashboardData['pendingLoans'].toString(),
                    Colors.orange,
                    () => _navigateToScreen(const LoanApprovalScreen()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLoanStatCard(
                    'Active',
                    _dashboardData['activeLoans'].toString(),
                    Colors.green,
                    () => _navigateToScreen(const ReportsScreen()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLoanStatCard(
                    'Defaulted',
                    _dashboardData['defaultedLoans'].toString(),
                    Colors.red,
                    () => _navigateToScreen(const ReportsScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToScreen(const LoanApplicationScreen()),
                    icon: const Icon(Icons.add),
                    label: const Text('New Loan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToScreen(const LoanApprovalScreen()),
                    icon: const Icon(Icons.check),
                    label: const Text('Approve Loans'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
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

  Widget _buildLoanStatCard(String title, String count, Color color, VoidCallback onTap) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildActionChip('Add Member', Icons.person_add, 
                    () => _navigateToScreen(const AddMemberScreen())),
                _buildActionChip('Apply Loan', Icons.request_quote, 
                    () => _navigateToScreen(const LoanApplicationScreen())),
                _buildActionChip('Add Savings', Icons.savings, 
                    () => _navigateToScreen(const SavingsScreen())),
                _buildActionChip('View Reports', Icons.assessment, 
                    () => _navigateToScreen(const ReportsScreen())),
                _buildActionChip('Settings', Icons.settings, 
                    () => _navigateToScreen(const SettingsScreen())),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(String label, IconData icon, VoidCallback onPressed) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onPressed,
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
  }

  Widget _buildRecentTransactions() {
    return Card(
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
                  onPressed: () => _navigateToScreen(const ReportsScreen()),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTransactionItem(
              'Loan Approved',
              'John Doe - KES 50,000',
              Icons.check_circle,
              Colors.green,
              '2 hours ago',
            ),
            _buildTransactionItem(
              'Savings Deposit',
              'Mary Jane - KES 15,000',
              Icons.savings,
              Colors.blue,
              '4 hours ago',
            ),
            _buildTransactionItem(
              'New Member',
              'Peter Smith joined',
              Icons.person_add,
              Colors.purple,
              '1 day ago',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String type, String details, IconData icon, Color color, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  details,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Future<void> _refreshData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh your data here
    });
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}