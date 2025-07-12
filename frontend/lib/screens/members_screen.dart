import 'package:flutter/material.dart';
import 'package:frontend/screens/add_member_screen.dart';
import 'package:frontend/screens/member_profile_screen.dart';
import 'package:frontend/screens/reports_screen.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _members = [];
  List<Map<String, dynamic>> _filteredMembers = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _searchController.addListener(_filterMembers);
  }

  void _loadMembers() {
    setState(() {
      _members = [
        {
          'id': 'MEM001',
          'name': 'John Mwangi',
          'phone': '+254712345678',
          'joinDate': '15/03/2022',
          'savings': 'KES 25,000'
        },
        {
          'id': 'MEM002',
          'name': 'Mary Wambui',
          'phone': '+254723456789',
          'joinDate': '22/06/2022',
          'savings': 'KES 42,500'
        },
      ];
      _filteredMembers = _members;
    });
  }

  void _filterMembers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _members.where((member) {
        return member['name'].toLowerCase().contains(query) ||
            member['id'].toLowerCase().contains(query) ||
            member['phone'].contains(query);
      }).toList();
    });
  }

  void _exportMembers() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReportsScreen()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Member list exported to reports')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportMembers,
            tooltip: 'Export Members',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, ID or phone...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterMembers();
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _filteredMembers.isEmpty
                ? const Center(
                    child: Text('No members found'),
                  )
                : ListView.builder(
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(member['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${member['id']}'),
                              Text('Phone: ${member['phone']}'),
                              Text('Joined: ${member['joinDate']}'),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                member['savings'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('Savings',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MemberProfileScreen(
                                  memberId: member['id']),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddMemberScreen(),
          ),
        ).then((_) {
          _loadMembers();
        }),
        tooltip: 'Add New Member',
        child: const Icon(Icons.person_add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}