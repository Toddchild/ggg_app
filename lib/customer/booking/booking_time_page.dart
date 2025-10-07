import 'package:flutter/material.dart';
import '../models.dart';

class BookingTimePage extends StatefulWidget {
  final Service service;
  const BookingTimePage({required this.service, super.key});

  @override
  State<BookingTimePage> createState() => _BookingTimePageState();
}

class _BookingTimePageState extends State<BookingTimePage> {
  DateTime _selectedDay = _stripTime(DateTime.now());
  DateTime? _selectedDateTime;

  static DateTime _stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  List<DateTime> _generateSlots(DateTime day) {
    // Demo hours: 9:00–17:00, every 30 minutes, next 14 days.
    final start = DateTime(day.year, day.month, day.day, 9);
    final end = DateTime(day.year, day.month, day.day, 17);
    final now = DateTime.now();

    final slots = <DateTime>[];
    for (var t = start; t.isBefore(end); t = t.add(const Duration(minutes: 30))) {
      // Simple “availability”: skip every 4th slot just to show some disabled ones.
      final isFakeBlocked = t.minute == 0 && t.hour % 2 == 1; // e.g., 11:00, 13:00, 15:00
      final isPast = t.isBefore(now);
      if (!isFakeBlocked && !isPast) slots.add(t);
    }
    return slots;
  }

  Future<void> _pickCalendarDay() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay.isBefore(_stripTime(now)) ? _stripTime(now) : _selectedDay,
      firstDate: _stripTime(now),
      lastDate: _stripTime(now.add(const Duration(days: 60))),
    );
    if (picked != null) {
      setState(() {
        _selectedDay = _stripTime(picked);
        _selectedDateTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final slots = _generateSlots(_selectedDay);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose date & time')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.service.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text('${widget.service.minutes} min • \$${widget.service.price.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: _pickCalendarDay,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('Select a date, then pick a time',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 16),
                if (slots.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No times available on this day. Try another date.'),
                    ),
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in slots)
                            ChoiceChip(
                              label: Text(_fmtTime(t)),
                              selected: _selectedDateTime == t,
                              onSelected: (_) => setState(() => _selectedDateTime = t),
                            ),
                        ],
                      ),
                    ),
                  ),
                const Spacer(),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Back'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: _selectedDateTime == null
                          ? null
                          : () {
                              // Next step placeholder (e.g., choose provider, confirm, etc.)
                              final dt = _selectedDateTime!;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Selected ${_fmtDate(dt)} @ ${_fmtTime(dt)}')),
                              );
                            },
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _fmtTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
    }
  static String _fmtDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
