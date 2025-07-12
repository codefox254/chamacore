import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, dynamic> _settings = {
    'loan_interest_rate': 12.0,
    'max_loan_amount': 100000.0,
    'default_repayment_period': 6,
    'processing_fee_percentage': 5.0,
    'savings_types': ['Monthly', 'Voluntary', 'Emergency'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Loan Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildNumberSetting(
              'Interest Rate (%)',
              _settings['loan_interest_rate'],
              (value) => setState(() => _settings['loan_interest_rate'] = value),
            ),
            _buildNumberSetting(
              'Maximum Loan Amount (KES)',
              _settings['max_loan_amount'],
              (value) => setState(() => _settings['max_loan_amount'] = value),
            ),
            _buildNumberSetting(
              'Default Repayment Period (Months)',
              _settings['default_repayment_period'],
              (value) => setState(() => _settings['default_repayment_period'] = value),
            ),
            _buildNumberSetting(
              'Processing Fee (%)',
              _settings['processing_fee_percentage'],
              (value) => setState(() => _settings['processing_fee_percentage'] = value),
            ),
            
            const SizedBox(height: 24),
            const Text(
              'Savings Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Savings Types'),
                ..._settings['savings_types'].map<Widget>((type) => ListTile(
                  title: Text(type),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => setState(() => 
                        _settings['savings_types'].remove(type)),
                  ),
                )).toList(),
                TextButton(
                  onPressed: () => _addNewSavingsType(),
                  child: const Text('+ Add New Type'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('SAVE SETTINGS'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberSetting(String label, num value, Function(num) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(
            child: TextFormField(
              initialValue: value.toString(),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                final numValue = num.tryParse(text);
                if (numValue != null) onChanged(numValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addNewSavingsType() async {
    final newType = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Savings Type'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    
    if (newType != null && newType.isNotEmpty) {
      setState(() => _settings['savings_types'].add(newType));
    }
  }

  void _saveSettings() async {
    // TODO: Implement API call to save settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }
}