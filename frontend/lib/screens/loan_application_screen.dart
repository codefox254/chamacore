import 'package:flutter/material.dart';
import 'package:frontend/screens/loan_approval_screen.dart';
import 'package:frontend/screens/member_profile_screen.dart';

class LoanApplicationScreen extends StatefulWidget {
  final String? memberId;
  final String? memberName;
  final String? memberPhone;
  final double? memberSavings;

  const LoanApplicationScreen({
    super.key,
    this.memberId,
    this.memberName,
    this.memberPhone,
    this.memberSavings,
  });

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();

  String _loanType = 'development';
  int _repaymentPeriod = 6;
  List<String> _selectedGuarantors = [];
  double _maxEligibleAmount = 0.0;

  final List<Map<String, dynamic>> _loanTypes = [
    {'value': 'development', 'label': 'Business Development'},
    {'value': 'emergency', 'label': 'Emergency'},
    {'value': 'school', 'label': 'School Fees'},
    {'value': 'medical', 'label': 'Medical'},
  ];

  @override
  void initState() {
    super.initState();
    _calculateMaxEligibleAmount();
  }

  void _calculateMaxEligibleAmount() {
    // Example: Member can borrow up to 3x their savings balance
    final savings = widget.memberSavings ?? 0;
    setState(() => _maxEligibleAmount = savings * 3);
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loan application submitted successfully!')),
    );

    // Navigate based on user role (in real app, check user role)
    final isAdmin = false; // Should come from auth state
    
    if (isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoanApprovalScreen(),
        ),
      );
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _selectGuarantors() async {
    // TODO: Implement guarantor selection screen
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Guarantors'),
        content: const Text('Guarantor selection screen to be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ['MEM002', 'MEM003']), // Mock selection
            child: const Text('Mock Select'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, []),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selected != null) {
      setState(() => _selectedGuarantors = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Loan Application'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Applicant Information
              if (widget.memberId != null) ...[
                const Text(
                  'Applicant Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${widget.memberName}'),
                        Text('Member ID: ${widget.memberId}'),
                        if (widget.memberPhone != null)
                          Text('Phone: ${widget.memberPhone}'),
                        if (widget.memberSavings != null)
                          Text('Current Savings: KES ${widget.memberSavings!.toStringAsFixed(2)}'),
                        Text('Max Eligible: KES ${_maxEligibleAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Loan Details
              const Text(
                'Loan Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _loanType,
                decoration: const InputDecoration(
                  labelText: 'Loan Type',
                  border: OutlineInputBorder(),
                ),
                items: _loanTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['value'],
                    child: Text(type['label']),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _loanType = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Loan Amount (KES)',
                  border: OutlineInputBorder(),
                  prefixText: 'KES ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = double.tryParse(value) ?? 0;
                  if (amount <= 0) {
                    return 'Amount must be positive';
                  }
                  if (amount > _maxEligibleAmount) {
                    return 'Amount exceeds maximum eligible (KES ${_maxEligibleAmount.toStringAsFixed(2)})';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _repaymentPeriod,
                decoration: const InputDecoration(
                  labelText: 'Repayment Period',
                  border: OutlineInputBorder(),
                  suffixText: 'months',
                ),
                items: [3, 6, 9, 12, 24].map((period) {
                  return DropdownMenuItem<int>(
                    value: period,
                    child: Text('$period months'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _repaymentPeriod = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose of Loan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please describe the purpose';
                  }
                  return null;
                },
              ),

              // Guarantors Section
              const SizedBox(height: 24),
              const Text(
                'Guarantors',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_selectedGuarantors.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  children: _selectedGuarantors.map((id) => Chip(
                    label: Text(id),
                    onDeleted: () => setState(() => _selectedGuarantors.remove(id)),
                  )).toList(),
                ),
                const SizedBox(height: 8),
              ],
              ElevatedButton(
                onPressed: _selectGuarantors,
                child: const Text('SELECT GUARANTORS'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Minimum 1 guarantor required for loans above KES 50,000',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              // Terms and Conditions
              const SizedBox(height: 24),
              const Text(
                'Terms & Conditions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 5% processing fee will be deducted from savings\n'
                '• Late repayments attract 2% monthly penalty\n'
                '• Loan insurance is mandatory for amounts above KES 100,000',
                style: TextStyle(fontSize: 14),
              ),
              CheckboxListTile(
                title: const Text('I agree to the terms and conditions'),
                value: true, // Should be managed in state
                onChanged: (value) {
                  // TODO: Handle terms agreement
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              // Submit Button
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitApplication,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'SUBMIT APPLICATION',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }
}