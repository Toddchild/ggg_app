import 'package:ggg_app/booking_request.dart';
// lib/customer/review_confirmation_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Requires dependency in pubspec.yaml
import '../app_config.dart';

/// The final step in the booking process, displaying a summary and estimated price.
class ReviewConfirmationPage extends StatelessWidget {
  final BookingRequest request;
  const ReviewConfirmationPage({super.key, required this.request});

  // Calculate the total estimated price based on selected items
  double get _totalPrice {
    return request.items.fold(
        0.0, (sum, item) => sum + ((item.basePrice) * (item.quantity ?? 0)));
  }

  // Format the date for display
  String get _formattedDate {
    if (request.pickupDate == null || request.pickupTime == null) {
      return 'TBD';
    }
    final time = request.pickupTime!;
    final dateTime = request.pickupDate!
        .add(Duration(hours: time.hour, minutes: time.minute));

    // Example: Fri, Nov 15th at 9:00 AM
    return '${DateFormat('EEE, MMM d, yyyy').format(request.pickupDate!)} at ${DateFormat('h:mm a').format(dateTime)}';
  }

  get color => null;

  @override
  Widget build(BuildContext context) {
    // Currency formatter
    final currencyFormat =
        NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Confirm'),
        backgroundColor: AppConfig.primaryBrandColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Finalizing Your Booking',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: AppConfig.navyBlue),
              ),
              const SizedBox(height: 16),

              // --- Booking Details Card ---
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          context, 'Service Type', request.serviceType.name),
                      const Divider(),
                      _buildDetailRow(context, 'Date & Time', _formattedDate),
                      const Divider(),
                      _buildDetailRow(
                          context,
                          'Address',
                          (request.address?.isEmpty ?? true)
                              ? 'Not Provided'
                              : request.address!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Items Summary Card ---
              Text(
                'Items for Pickup (${request.items.length})',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: request.items
                        .map((item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item.quantity}x ${item.name}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  Text(currencyFormat.format(
                                      (item.basePrice) * (item.quantity ?? 0))),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- Price Summary ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConfig.lightBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppConfig.primaryBrandColor ?? Colors.transparent,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Total Price:',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: AppConfig.navyBlue),
                    ),
                    Text(
                      currencyFormat.format(_totalPrice),
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppConfig.brandGreen,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: AppConfig.navyBlue)),
        ],
      ),
    );
  }
}
