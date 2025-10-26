// lib/customer/booking/booking_time_page.dart
//
// Choose a date and a period (Morning or Afternoon). Instead of multiple
// 30-minute slots this page offers two blocks:
//  - Morning: 08:00 — 13:00
//  - Afternoon: 13:00 — 19:00
//
// Continue passes the selected block's start time to PickupDetailsPage.

import 'package:flutter/material.dart';
import '../models.dart';
import 'pickup_details_page.dart';

enum Period { morning, afternoon }

class BookingTimePage extends StatefulWidget {
  final Service service;
  const BookingTimePage({required this.service, super.key});

  @override
  State<BookingTimePage> createState() => _BookingTimePageState();
}

class _BookingTimePageState extends State<BookingTimePage> {
  // Start with earliest allowed booking day = tomorrow
  DateTime _selectedDay = _stripTime(DateTime.now()).add(const Duration(days: 1));
  Period? _selectedPeriod;

  static DateTime _stripTime(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _pickCalendarDay() async {
    final now = DateTime.now();
    final earliest = _stripTime(now).add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay.isBefore(earliest) ? earliest : _selectedDay,
      firstDate: earliest,
      lastDate: earliest.add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() {
        _selectedDay = _stripTime(picked);
        _selectedPeriod = null;
      });
    }
  }

  void _selectPeriod(Period p) {
    setState(() {
      _selectedPeriod = p;
    });
  }

  DateTime _scheduledStartFor(Period p) {
    final startHour = p == Period.morning ? 8 : 13;
    return DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, startHour);
  }

  String _periodLabel(Period p) =>
      p == Period.morning ? 'Morning (08:00–13:00)' : 'Afternoon (13:00–19:00)';

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = _selectedPeriod;
    return Scaffold(
      appBar: AppBar(title: const Text('Choose date & time block')),
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
                    Text('Choose a date and a time block', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 12),

                // Period selector: two blocks only
                Wrap(
                  spacing: 12,
                  children: [
                    ChoiceChip(
                      label: Text(_periodLabel(Period.morning), textAlign: TextAlign.center),
                      selected: selectedPeriod == Period.morning,
                      onSelected: (_) => _selectPeriod(Period.morning),
                    ),
                    ChoiceChip(
                      label: Text(_periodLabel(Period.afternoon), textAlign: TextAlign.center),
                      selected: selectedPeriod == Period.afternoon,
                      onSelected: (_) => _selectPeriod(Period.afternoon),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Selected date: ${_selectedDay.year}-${_selectedDay.month.toString().padLeft(2, '0')}-${_selectedDay.day.toString().padLeft(2, '0')}'),
                      const SizedBox(height: 6),
                      Text('Selected block: ${selectedPeriod == null ? 'None' : _periodLabel(selectedPeriod)}'),
                      const SizedBox(height: 6),
                      const Text(
                        'Note: Your pickup will be scheduled within the selected block. '
                        'Contractors will receive the full block and will pick a specific time within it.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]),
                  ),
                ),

                const Spacer(),
                Row(
                  children: [
                    OutlinedButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Back')),
                    const Spacer(),
                    FilledButton(
                      onPressed: selectedPeriod == null
                          ? null
                          : () {
                              final dt = _scheduledStartFor(selectedPeriod);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PickupDetailsPage(service: widget.service, scheduledAt: dt),
                                ),
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
}
