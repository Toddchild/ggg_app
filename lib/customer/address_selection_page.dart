// lib/customer/address_selection_page.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking_details.dart';
// Assuming the next step is the final success/confirmation page
import 'booking_success_page.dart'; 

class AddressSelectionPage extends StatefulWidget {
  final BookingDetails details;

  const AddressSelectionPage({
    super.key,
    required this.details,
  });

  @override
  State<AddressSelectionPage> createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  final TextEditingController _addressController = TextEditingController();
  String _validationError = '';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final address = _addressController.text.trim();
    if (address.isEmpty || address.length < 10) {
      setState(() {
        _validationError = 'Please enter a full, valid street address.';
      });
      return;
    }

    // Clear error
    setState(() {
      _validationError = '';
    });

    // NOTE: We temporarily use pickupLocationLabel to store the address until 
    // the BookingDetails model is updated with a dedicated 'address' field.
    final finalDetails = widget.details.copyWith(
      pickupLocationLabel: address, 
    );
    
    // Navigate to the success/confirmation page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookingSuccessPage(
          details: finalDetails,
          customerName: '',
          startsAt: finalDetails.pickupDate,
        ),
      )
      
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final details = widget.details;
    final dateStr = DateFormat('EEE, MMM d, yyyy').format(details.pickupDate);
    final timeWindowStr = details.pickupWindow.label;
    
    return Card(
      elevation: 0,
      // ignore: deprecated_member_use
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Booking Summary', style: Theme.of(context).textTheme.titleSmall),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Service:'),
                Text(details.service.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Time:'),
                Text('$dateStr @ $timeWindowStr', style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Est. Price:', style: Theme.of(context).textTheme.titleMedium),
                Text('\$${details.finalFee.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3. Enter Pickup Address')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Summary Card
                _buildSummaryCard(context),
                
                const SizedBox(height: 32),

                // 2. Address Input
                Text('Where are we picking up the items?', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),

                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Street Address, City, Postal Code',
                    hintText: 'e.g., 123 Main St, Red Deer, T4N 5N9',
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    errorText: _validationError.isNotEmpty ? _validationError : null,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  keyboardType: TextInputType.streetAddress,
                  onChanged: (_) {
                    if (_validationError.isNotEmpty) {
                      setState(() {
                        _validationError = '';
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                
                // 3. Navigation Buttons
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      child: const Text('Back'),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: _handleContinue,
                      label: const Text('Review & Finalize Booking'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                      ),
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
