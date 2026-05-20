import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import 'settings_screen.dart';
import 'summary_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.groups.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Water Tracker')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No groups yet. Create one to get started!'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAddGroupDialog(context, provider),
                    child: const Text('Create Group'),
                  ),
                ],
              ),
            ),
          );
        }

        final currentGroup = provider.currentGroup;
        if (currentGroup == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                DropdownButton<int>(
                  value: currentGroup.id,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: provider.groups.map((Group group) {
                    return DropdownMenuItem<int>(
                      value: group.id,
                      child: Text(group.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      provider.setCurrentGroup(newValue);
                    }
                  },
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bar_chart),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SummaryScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                },
              ),
            ],
          ),
          body: provider.currentMembers.isEmpty
              ? _buildEmptyMembersView(context, provider)
              : _buildDashboardContent(context, provider),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddMemberDialog(context, provider),
            child: const Icon(Icons.person_add),
          ),
        );
      },
    );
  }

  Widget _buildEmptyMembersView(BuildContext context, AppProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('No members in this group.'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showAddMemberDialog(context, provider),
            child: const Text('Add Member'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, AppProvider provider) {
    final turnMember = provider.currentTurnMember!;
    final debt = provider.getCurrentTurnDebt();

    return Column(
      children: [
        const SizedBox(height: 20),
        // Active Payer Widget
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text('Current Turn', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  turnMember.name,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                if (debt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'You owe a turn because someone paid for you earlier!',
                    style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => provider.markPaid(),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Mark as Paid', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _showPayOnBehalfDialog(context, provider),
                  child: const Text('Someone else paying?'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Rotation List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: provider.currentMembers.length,
            itemBuilder: (context, index) {
              final member = provider.currentMembers[index];
              final isTurn = member.id == turnMember.id;

              // Find last payment date for this member
              Payment? lastPayment;
              for (final payment in provider.currentPayments) {
                if (payment.memberId == member.id) {
                  lastPayment = payment;
                  break;
                }
              }
              String lastPaidStr = lastPayment != null
                  ? DateFormat('MMM d, yyyy').format(DateTime.fromMillisecondsSinceEpoch(lastPayment.timestamp))
                  : 'Never';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isTurn ? Theme.of(context).colorScheme.primary : Colors.grey,
                  child: Icon(Icons.person, color: isTurn ? Theme.of(context).colorScheme.onPrimary : Colors.white),
                ),
                title: Text(member.name, style: TextStyle(fontWeight: isTurn ? FontWeight.bold : FontWeight.normal)),
                subtitle: Text('Last paid: $lastPaidStr'),
                trailing: isTurn
                    ? const Chip(label: Text('Current', style: TextStyle(fontSize: 12)))
                    : const SizedBox.shrink(),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showAddGroupDialog(BuildContext context, AppProvider provider) async {
    String name = '';
    String amountStr = '10.0';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Group Name'),
                onChanged: (val) => name = val,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Water Bottle Cost'),
                keyboardType: TextInputType.number,
                onChanged: (val) => amountStr = val,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && double.tryParse(amountStr) != null) {
                  provider.addGroup(name, double.parse(amountStr));
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddMemberDialog(BuildContext context, AppProvider provider) async {
    String name = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Member'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Member Name'),
            onChanged: (val) => name = val,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  provider.addMember(name);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPayOnBehalfDialog(BuildContext context, AppProvider provider) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Who is paying?'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.currentMembers.length,
              itemBuilder: (context, index) {
                final member = provider.currentMembers[index];
                if (member.id == provider.currentTurnMember!.id) return const SizedBox.shrink(); // Hide the unavailable person
                return ListTile(
                  title: Text(member.name),
                  onTap: () {
                    provider.markPaidOnBehalf(member);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
