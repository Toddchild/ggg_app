import 'package:flutter/material.dart';
import 'models.dart';
import 'booking_page.dart';

class ServiceViewPage extends StatelessWidget {
  const ServiceViewPage({super.key, required this.service});
  final Service service;

  bool _hasText(String? s) => s != null && s.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String title       = service.name;
    final String description = service.description;
    final int minutes        = service.minutes;
    final double price       = service.price;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _HeaderPlaceholder(),
            const SizedBox(height: 16),

            Text(title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),

            Row(
              children: [
                _Pill(text: '$minutes min'),
                const SizedBox(width: 8),
                _Pill(text: '\$${price.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 16),

            if (_hasText(description))
              Text(description, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 24),

            FilledButton.icon(
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Book this service'),
              onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => BookingPage(service: service),
    ),
  );
},

            ),
          ],
        ),
      ),
    );
  }
}

/// Simple header block used when there is no image URL in the model.
class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.10),
            color.withOpacity(0.25),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.design_services_outlined, size: 56),
      ),
    );
  }
}

/// Little rounded label used for minutes/price chips.
class _Pill extends StatelessWidget {
  const _Pill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).colorScheme.primary.withOpacity(0.25);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

/// Fallback booking screen to avoid constructor/import mismatches.
/// Replace this with your real BookingPage and update the navigator call above.
class _BookingPageFallback extends StatelessWidget {
  const _BookingPageFallback({required this.service});
  final Service service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.bodyLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are booking: ${service.name}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Duration: ${service.minutes} min'),
              Text('Price: \$${service.price.toStringAsFixed(2)}'),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pretend booking confirmed ✅')),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
