import 'package:flutter/material.dart';
import 'package:frontend/screens/member_profile_screen.dart';
import 'package:frontend/screens/reports_screen.dart';

class SavingsScreen extends StatefulWidget {
  final String? memberId;
  final String? initialAction;
  final Map<String, dynamic>? loanData;

  const SavingsScreen({
    super.key,
    this.memberId,
    this.initialAction,
    this.loanData,
  });

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _memberSearchController = TextEditingController();
  String _selectedType = 'monthly';
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _savingsHistory = [];
  String? _selectedMemberId;

  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.memberId != null) {
      _selectedMemberId = widget.memberId;
    }
    if (widget.initialAction == 'deduct' && widget.loanData != null) {
      _amountController.text = (widget.loanData!['amount'] * 0.05).toStringAsFixed(2);
    }
  }

  Future<void> _loadData() async {
    // TODO: Replace with API calls
    setState(() {
      _members = [
        {'id': 'MEM001', 'name': 'John Mwangi'},
        {'id': 'MEM002', 'name': 'Mary Wambui'},
      ];
      _savingsHistory = [
        {'date': '01/06/2023', 'amount': 5000.0, 'type': 'monthly', 'member': 'John Mwangi'},
        {'date': '01/05/2023', 'amount': 5000.0, 'type': 'monthly', 'member': 'Mary Wambui'},
      ];
    });
  }

  void _submitSavings() async {
    if (_selectedMemberId == null) return;
    
    // TODO: Implement API call
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Savings recorded successfully')),
    );
    
    if (widget.initialAction == 'deduct') {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      _amountController.clear();
      _loadData();
    }
  }

  void _generateReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportsScreen(
          initialReportType: 'savings',
          memberId: _selectedMemberId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _generateReport,
            tooltip: 'Generate Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.memberId == null) ...[
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _members
                      .where((member) => member['name']
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()))
                      .map((member) => member['id']);
                },
                onSelected: (String selection) {
                  setState(() => _selectedMemberId = selection);
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController controller,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Search Member',
                      prefixIcon: Icon(Icons.search),
                    ),
                  );
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options,
                ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        width: 250,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            final member = _members.firstWhere(
                                (m) => m['id'] == option);
                            return InkWell(
                              onTap: () => onSelected(option),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(member['name']),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
            
            if (_selectedMemberId != null) ...[
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(_members
                      .firstWhere((m) => m['id'] == _selectedMemberId)['name']),
                  trailing: IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemberProfileScreen(
                          memberId: _selectedMemberId!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.initialAction == 'deduct' 
                    ? 'Processing Fee (5%)' 
                    : 'Amount',
                prefixText: 'KES ',
              ),
            ),
            const SizedBox(height: 16),
            
            if (widget.initialAction != 'deduct') ...[
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: const [
                  DropdownMenuItem(value: 'monthly', child: Text('Monthly Contribution')),
                  DropdownMenuItem(value: 'voluntary', child: Text('Voluntary Savings')),
                  DropdownMenuItem(value: 'emergency', child: Text('Emergency Fund')),
                ],
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 24),
            ],
            
            ElevatedButton(
              onPressed: _selectedMemberId == null ? null : _submitSavings,
              child: Text(widget.initialAction == 'deduct' 
                  ? 'DEDUCT PROCESSING FEE' 
                  : 'RECORD SAVINGS'),
            ),
            
            const SizedBox(height: 32),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Recent Savings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ..._savingsHistory.map((saving) => ListTile(
              leading: const Icon(Icons.savings, color: Colors.green),
              title: Text('KES ${saving['amount'].toStringAsFixed(2)}'),
              subtitle: Text('${saving['type']} • ${saving['member']}'),
              trailing: Text(saving['date']),
            )),
          ],
        ),
      ),
    );
  }
}