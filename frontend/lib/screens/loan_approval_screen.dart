import 'package:flutter/material.dart';
import 'package:frontend/screens/member_profile_screen.dart';
import 'package:frontend/screens/reports_screen.dart';
import 'package:frontend/screens/savings_screen.dart';

class LoanApprovalScreen extends StatefulWidget {
  const LoanApprovalScreen({super.key});

  @override
  State<LoanApprovalScreen> createState() => _LoanApprovalScreenState();
}

class _LoanApprovalScreenState extends State<LoanApprovalScreen> {
  List<Map<String, dynamic>> _pendingLoans = [];
  String _filterStatus = 'pending';

  @override
  void initState() {
    super.initState();
    _loadPendingLoans();
  }

  Future<void> _loadPendingLoans() async {
    // TODO: Replace with API call
    setState(() {
      _pendingLoans = [
        {
          'loanId': 'LN-2023-045',
          'memberId': 'MEM001',
          'memberName': 'John Mwangi',
          'amount': 75000.0,
          'requestDate': '01/06/2023',
          'purpose': 'Business Expansion',
          'status': 'pending',
          'guarantors': ['MEM002', 'MEM003']
        },
        // Add more loan applications
      ];
    });
  }

  void _viewMemberProfile(String memberId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberProfileScreen(memberId: memberId),
      ),
    );
  }

  Future<void> _updateLoanStatus(String loanId, String status) async {
    // TODO: Implement API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Loan $loanId $status')),
    );
    
    if (status == 'approved') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SavingsScreen(
            memberId: _pendingLoans.firstWhere((loan) => loan['loanId'] == loanId)['memberId'],
            initialAction: 'deduct',
            loanData: _pendingLoans.firstWhere((loan) => loan['loanId'] == loanId),
          ),
        ),
      );
    }
    
    _loadPendingLoans(); // Refresh list
  }

  void _generatePortfolioReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportsScreen(
          initialReportType: 'loan_portfolio',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Approvals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _generatePortfolioReport,
            tooltip: 'Loan Portfolio Report',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'pending', label: Text('Pending')),
                ButtonSegment(value: 'approved', label: Text('Approved')),
                ButtonSegment(value: 'rejected', label: Text('Rejected')),
              ],
              selected: {_filterStatus},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() => _filterStatus = newSelection.first);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _pendingLoans.length,
              itemBuilder: (context, index) {
                final loan = _pendingLoans[index];
                if (_filterStatus != 'all' && loan['status'] != _filterStatus) {
                  return Container();
                }
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      child: Text(loan['memberName'].substring(0, 1)),
                    ),
                    title: Text(loan['memberName']),
                    subtitle: Text('KES ${loan['amount'].toStringAsFixed(2)}'),
                    trailing: Chip(
                      label: Text(loan['status']),
                      backgroundColor: loan['status'] == 'approved'
                          ? Colors.green[100]
                          : loan['status'] == 'rejected'
                              ? Colors.red[100]
                              : Colors.amber[100],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Loan ID: ${loan['loanId']}'),
                            Text('Purpose: ${loan['purpose']}'),
                            Text('Request Date: ${loan['requestDate']}'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _viewMemberProfile(loan['memberId']),
                                  child: const Text('View Profile'),
                                ),
                                ElevatedButton(
                                  onPressed: () => _updateLoanStatus(loan['loanId'], 'approved'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('Approve'),
                                ),
                                ElevatedButton(
                                  onPressed: () => _updateLoanStatus(loan['loanId'], 'rejected'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Reject'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}