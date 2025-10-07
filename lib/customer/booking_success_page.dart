import 'package:flutter/material.dart';

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({
    super.key,
    required this.customerName,
    required this.startsAt,
  });

  final String customerName;
  final DateTime startsAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);

    final dateStr = localizations.formatMediumDate(startsAt);
    final timeStr = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(startsAt),
      alwaysUse24HourFormat: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Booking confirmed')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 72, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Thank you, $customerName!',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your booking is set for $dateStr at $timeStr.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Back to Services'),
                      onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to booking'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
