import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  static const List<_Payout> _payouts = [
    _Payout(date: 'Jun 22', amount: 85.0, status: 'Paid'),
    _Payout(date: 'Jun 21', amount: 120.0, status: 'Paid'),
    _Payout(date: 'Jun 20', amount: 140.0, status: 'Processing'),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _payouts.fold<double>(0, (sum, item) => sum + item.amount);
    final paid = _payouts
        .where((item) => item.status == 'Paid')
        .fold<double>(0, (sum, item) => sum + item.amount);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Earnings & Payout History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Total',
                value: '\$${total.toStringAsFixed(0)}',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _SummaryCard(
                label: 'Paid Out',
                value: '\$${paid.toStringAsFixed(0)}',
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Recent Payouts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        ..._payouts.map(
          (item) => Card(
            child: ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: Text(item.date),
              subtitle: Text(item.status),
              trailing: Text('\$${item.amount.toStringAsFixed(0)}'),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Payout {
  final String date;
  final double amount;
  final String status;

  const _Payout({
    required this.date,
    required this.amount,
    required this.status,
  });
}
