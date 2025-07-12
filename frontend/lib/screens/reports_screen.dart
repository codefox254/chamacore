import 'package:flutter/material.dart';
import 'package:frontend/screens/settings_screen.dart';

class ReportsScreen extends StatefulWidget {
  final String? initialReportType;
  final String? memberId;

  const ReportsScreen({
    super.key,
    this.initialReportType,
    this.memberId,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late String _selectedReportType;
  DateTimeRange? _dateRange;
  final List<Map<String, dynamic>> _reportData = [];

  @override
  void initState() {
    super.initState();
    _selectedReportType = widget.initialReportType ?? 'savings';
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    // TODO: Replace with API call
    setState(() {
      _reportData.clear();
      if (_selectedReportType == 'savings') {
        _reportData.addAll([
          {'month': 'June 2023', 'total': 125000.0, 'members': 42},
          {'month': 'May 2023', 'total': 118500.0, 'members': 40},
        ]);
      } else {
        _reportData.addAll([
          {'loanId': 'LN-2023-045', 'member': 'John Mwangi', 'amount': 75000.0, 'status': 'active'},
          {'loanId': 'LN-2023-044', 'member': 'Mary Wambui', 'amount': 50000.0, 'status': 'repaid'},
        ]);
      }
    });
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
      _loadReportData();
    }
  }

  void _exportReport() {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report exported successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SACCO Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
            tooltip: 'Report Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedReportType,
                    items: const [
                      DropdownMenuItem(
                        value: 'savings',
                        child: Text('Savings Report'),
                      ),
                      DropdownMenuItem(
                        value: 'loan_portfolio',
                        child: Text('Loan Portfolio'),
                      ),
                      DropdownMenuItem(
                        value: 'members',
                        child: Text('Member List'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedReportType = value!);
                      _loadReportData();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDateRange,
                  tooltip: 'Select Date Range',
                ),
              ],
            ),
          ),
          if (_dateRange != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '${_dateRange!.start.toLocal().toString().split(' ')[0]} to '
                '${_dateRange!.end.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _reportData.length,
              itemBuilder: (context, index) {
                final item = _reportData[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      _selectedReportType == 'savings'
                          ? item['month']
                          : '${item['member']} (${item['loanId']})',
                    ),
                    subtitle: Text(
                      _selectedReportType == 'savings'
                          ? 'KES ${item['total'].toStringAsFixed(2)} • ${item['members']} members'
                          : 'KES ${item['amount'].toStringAsFixed(2)} • ${item['status']}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _exportReport,
              icon: const Icon(Icons.file_download),
              label: const Text('EXPORT REPORT'),
            ),
          ),
        ],
      ),
    );
  }
}