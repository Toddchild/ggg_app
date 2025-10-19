// lib/customer/booking_page.dart
import 'package:flutter/material.dart';
import 'models.dart';

enum TimeWindow { morning, afternoon }

extension on TimeWindow {
  String get label => this == TimeWindow.morning ? '8:00–12:00' : '12:00–6:00';
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key, required this.service});
  final Service service;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  late DateTime _selectedDate; // defaults to tomorrow
  TimeWindow? _window;

  @override
  void initState() {
    super.initState();
    _selectedDate = _tomorrow(DateTime.now());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  // Midnight "tomorrow" in local time.
  DateTime _tomorrow(DateTime now) =>
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

  String _formatDate(DateTime d) =>
      '${_monthName(d.month)} ${d.day}, ${d.year}';

  String _monthName(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[m - 1];
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = _tomorrow(now);
    final last =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 180));

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(first) ? first : _selectedDate,
      firstDate: first, // disables today and earlier
      lastDate: last,
      helpText: 'Select pickup date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(),
          child: child!,
        );
      },
    );

    if (!mounted) return;
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    // Extra guard: no bookings before tomorrow even if something slips through.
    final minDate = _tomorrow(DateTime.now());
    if (_selectedDate.isBefore(minDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pickup cannot be before tomorrow.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_window == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a pickup window')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingSuccessPage(
          name: _nameCtrl.text.trim(),
          date: _selectedDate,
          window: _window!,
          service: widget.service,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;

    return Scaffold(
      appBar: AppBar(title: const Text('New Booking')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Service summary
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(s.description,
                          maxLines: 3, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Text(
                          '${s.minutes} min • \$${s.price.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name + date + window
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Your name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter your name'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Date picker (tomorrow or later)
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Pickup date',
                      border: OutlineInputBorder(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(_formatDate(_selectedDate))),
                            TextButton.icon(
                              onPressed: _pickDate,
                              icon: const Icon(Icons.calendar_month_outlined),
                              label: const Text('Change'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bookings cannot be made for today. Earliest pickup is tomorrow.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Window picker: 8–12 or 12–6
                  Text('Pickup window',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _WindowChip(
                        label: TimeWindow.morning.label,
                        selected: _window == TimeWindow.morning,
                        onTap: () =>
                            setState(() => _window = TimeWindow.morning),
                      ),
                      _WindowChip(
                        label: TimeWindow.afternoon.label,
                        selected: _window == TimeWindow.afternoon,
                        onTap: () =>
                            setState(() => _window = TimeWindow.afternoon),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Confirm booking'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowChip extends StatelessWidget {
  const _WindowChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({
    super.key,
    required this.name,
    required this.date,
    required this.window,
    required this.service,
  });

  final String name;
  final DateTime date;
  final TimeWindow window;
  final Service service;

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmed')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle,
                    size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text('Thanks, $name!', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Your booking for "${service.name}" is set.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Pickup: ${_formatDate(date)} • ${window.label}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
