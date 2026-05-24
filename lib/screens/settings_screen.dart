import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Settings')),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final group = provider.currentGroup;
          if (group == null) return const Center(child: Text('No group selected'));

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              GlassCard(
                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                backgroundOpacity: 0.1,
                child: ListTile(
                  title: const Text('Edit Group Details'),
                  subtitle: Text('Name: ${group.name} | Amount: \$${group.amount}'),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _showEditGroupDialog(context, provider, group),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Members', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...provider.currentMembers.map((m) => GlassCard(
                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                backgroundOpacity: 0.1,
                child: ListTile(
                  title: Text(m.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteMemberDialog(context, provider, m.id!),
                  ),
                ),
              )).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () => _showDeleteGroupDialog(context, provider, group.id!),
                child: const Text('Delete Group'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showEditGroupDialog(BuildContext context, AppProvider provider, Group group) async {
    String name = group.name;
    String amountStr = group.amount.toString();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Group Name'),
                initialValue: name,
                onChanged: (val) => name = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Water Bottle Cost'),
                keyboardType: TextInputType.number,
                initialValue: amountStr,
                onChanged: (val) => amountStr = val,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && double.tryParse(amountStr) != null) {
                  final updated = Group(id: group.id, name: name, amount: double.parse(amountStr), turnIndex: group.turnIndex);
                  provider.updateGroup(updated);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteMemberDialog(BuildContext context, AppProvider provider, int memberId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Member'),
          content: const Text('Are you sure you want to remove this member?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                provider.deleteMember(memberId);
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteGroupDialog(BuildContext context, AppProvider provider, int groupId) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Group'),
          content: const Text('Are you sure you want to delete this entire group? This action cannot be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                provider.deleteGroup(groupId);
                Navigator.pop(context);
                Navigator.pop(context); // Go back from settings screen
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
