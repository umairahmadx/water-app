import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import '../widgets/glass_card.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Note: Share package can be added later if needed,
              // for now we can just show a snackbar or implement basic text copy
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share functionality would go here.')));
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final group = provider.currentGroup;
          if (group == null) return const Center(child: Text('No group selected'));

          // Group payments by month
          final Map<String, List<Payment>> paymentsByMonth = {};

          // ⚡ Bolt: Cache DateFormat to avoid recreating it for every payment in the loop
          final dateFormat = DateFormat('MMMM yyyy');

          for (var p in provider.currentPayments) {
            final date = DateTime.fromMillisecondsSinceEpoch(p.timestamp);
            final monthStr = dateFormat.format(date);
            if (!paymentsByMonth.containsKey(monthStr)) {
              paymentsByMonth[monthStr] = [];
            }
            paymentsByMonth[monthStr]!.add(p);
          }

          if (paymentsByMonth.isEmpty) {
             return const Center(child: Text('No payments yet.'));
          }

          return ListView.builder(
            itemCount: paymentsByMonth.length,
            itemBuilder: (context, index) {
              final month = paymentsByMonth.keys.elementAt(index);
              final payments = paymentsByMonth[month]!;

              // Calculate totals per member for this month
              final Map<int, double> memberTotals = {};
              for (var p in payments) {
                memberTotals[p.memberId] = (memberTotals[p.memberId] ?? 0) + p.amount;
              }

              return GlassCard(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                backgroundOpacity: 0.1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(month, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Divider(),
                      ...provider.currentMembers.map((m) {
                        final total = memberTotals[m.id] ?? 0;
                        if (total == 0) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m.name, style: const TextStyle(fontSize: 16)),
                              Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }).toList(),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('\$${payments.map((p) => p.amount).fold(0.0, (a, b) => a + b).toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
