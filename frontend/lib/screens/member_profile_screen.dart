import 'package:flutter/material.dart';
import 'package:frontend/screens/loan_application_screen.dart';
import 'package:frontend/screens/savings_screen.dart';
import 'package:frontend/screens/members_screen.dart';

class MemberProfileScreen extends StatefulWidget {
  final String? memberId;

  const MemberProfileScreen({super.key, this.memberId});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  Map<String, dynamic>? _memberDetails;
  int _currentTabIndex = 0;
  late String _currentMemberId;

  @override
  void initState() {
    super.initState();
    _initializeMemberId();
    _loadMemberDetails();
  }

  void _initializeMemberId() {
    // Try to get memberId from widget parameter first
    if (widget.memberId != null) {
      _currentMemberId = widget.memberId!;
    } else {
      // If not provided, try to get from route arguments
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null && args['memberId'] != null) {
          _currentMemberId = args['memberId'];
          _loadMemberDetails();
        } else {
          // Fallback to default member ID
          _currentMemberId = 'MEM001';
          _loadMemberDetails();
        }
      });
    }
  }

  Future<void> _loadMemberDetails() async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    if (mounted) {
      setState(() {
        _memberDetails = {
          'id': _currentMemberId,
          'name': _currentMemberId == 'MEM001' ? 'John Mwangi' : 'Mary Wambui',
          'nationalId': '12345678',
          'phone': '+254712345678',
          'email': 'john.mwangi@example.com',
          'joinDate': '15/03/2022',
          'address': '123 Nairobi, Kenya',
          'nextOfKin': 'Ann Mwangi (+254723456789)',
          'totalSavings': 25000.0,
          'activeLoans': 1,
          'profilePhoto': 'assets/placeholder_avatar.png',
          'savingsHistory': [
            {'date': '01/06/2023', 'amount': 5000.0, 'type': 'Monthly'},
            {'date': '01/05/2023', 'amount': 5000.0, 'type': 'Monthly'},
            {'date': '15/04/2023', 'amount': 15000.0, 'type': 'Emergency'},
          ],
          'loanHistory': [
            {
              'loanId': 'LN-2023-001',
              'amount': 100000.0,
              'date': '10/04/2023',
              'status': 'Active',
              'balance': 45000.0
            }
          ],
        };
      });
    }
  }

  void _applyForLoan() {
    if (_memberDetails != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoanApplicationScreen(
            memberId: _currentMemberId,
            memberName: _memberDetails!['name'],
          ),
        ),
      );
    }
  }

  void _viewSavingsDetails() {
    setState(() => _currentTabIndex = 1);
  }

  void _addSavingsContribution() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavingsScreen(
          memberId: _currentMemberId,
          initialAction: 'add',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_memberDetails == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_memberDetails!['name']),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Implement edit functionality
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.info_outline), text: 'Details'),
              Tab(icon: Icon(Icons.savings), text: 'Savings'),
              Tab(icon: Icon(Icons.credit_card), text: 'Loans'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Details Tab
            _buildDetailsTab(),

            // Savings Tab
            _buildSavingsTab(),

            // Loans Tab
            _buildLoansTab(),
          ],
        ),
        floatingActionButton: _currentTabIndex == 1
            ? FloatingActionButton(
                onPressed: _addSavingsContribution,
                tooltip: 'Add Contribution',
                child: const Icon(Icons.add),
              )
            : _currentTabIndex == 0
                ? FloatingActionButton(
                    onPressed: _applyForLoan,
                    tooltip: 'Apply Loan',
                    child: const Icon(Icons.credit_score),
                  )
                : null,
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(_memberDetails!['profilePhoto']),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Personal Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _buildDetailItem('Member ID', _memberDetails!['id']),
          _buildDetailItem('National ID', _memberDetails!['nationalId']),
          _buildDetailItem('Phone', _memberDetails!['phone']),
          _buildDetailItem('Email', _memberDetails!['email']),
          _buildDetailItem('Join Date', _memberDetails!['joinDate']),
          
          const SizedBox(height: 20),
          const Text(
            'Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _buildDetailItem('Address', _memberDetails!['address']),
          _buildDetailItem('Next of Kin', _memberDetails!['nextOfKin']),
          
          const SizedBox(height: 20),
          const Text(
            'Financial Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _buildDetailItem('Total Savings', 'KES ${_memberDetails!['totalSavings'].toStringAsFixed(2)}'),
          _buildDetailItem('Active Loans', _memberDetails!['activeLoans'].toString()),
        ],
      ),
    );
  }

  Widget _buildSavingsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Total Savings Balance',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'KES ${_memberDetails!['totalSavings'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _memberDetails!['savingsHistory'].length,
            itemBuilder: (context, index) {
              final savings = _memberDetails!['savingsHistory'][index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ListTile(
                  leading: const Icon(Icons.savings, color: Colors.green),
                  title: Text('KES ${savings['amount'].toStringAsFixed(2)}'),
                  subtitle: Text(savings['type']),
                  trailing: Text(savings['date']),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoansTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _applyForLoan,
            child: const Text('APPLY FOR NEW LOAN'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _memberDetails!['loanHistory'].length,
            itemBuilder: (context, index) {
              final loan = _memberDetails!['loanHistory'][index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: ListTile(
                  leading: const Icon(Icons.credit_card, color: Colors.blue),
                  title: Text('Loan ${loan['loanId']}'),
                  subtitle: Text('KES ${loan['amount'].toStringAsFixed(2)}'),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(loan['status']),
                      Text('Balance: KES ${loan['balance'].toStringAsFixed(2)}'),
                    ],
                  ),
                  onTap: () {
                    // TODO: Navigate to loan details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}