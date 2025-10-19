// lib/customer/address_item_selection_page.dart

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // New Import
// ignore: depend_on_referenced_packages
// Optional geocoding import removed to avoid missing package error.
// If you add `package:geocoding` to pubspec.yaml, replace this line with:
// import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart'; // New Import

import '../models/pickup_item.dart';
import '../app_config.dart';
import 'package:ggg_app/customer/review_confirmation_page.dart';

/// Collects the address and allows selection of items for the booking.
class AddressItemSelectionPage extends StatefulWidget {
  final BookingRequest request;
  const AddressItemSelectionPage({super.key, required this.request});

  @override
  State<AddressItemSelectionPage> createState() =>
      _AddressItemSelectionPageState();
}

class BookingRequest {
  final String? address;
  final List<PickupItem> items;
  final DateTime? pickupDate;
  final dynamic pickupTime; // adjust type (e.g. TimeOfDay) if you know it
  final dynamic serviceType; // adjust to the real enum/type if available
  final double? latitude;
  final double? longitude;

  BookingRequest({
    this.address,
    List<PickupItem>? items,
    this.pickupDate,
    this.pickupTime,
    this.serviceType,
    this.latitude,
    this.longitude,
  }) : items = items ?? <PickupItem>[];

  BookingRequest copyWith({
    String? address,
    List<PickupItem>? items,
    DateTime? pickupDate,
    dynamic pickupTime,
    dynamic serviceType,
    double? latitude,
    double? longitude,
  }) {
    return BookingRequest(
      address: address ?? this.address,
      items: items ?? List<PickupItem>.from(this.items),
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTime: pickupTime ?? this.pickupTime,
      serviceType: serviceType ?? this.serviceType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class _AddressItemSelectionPageState extends State<AddressItemSelectionPage> {
  late BookingRequest _request;
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLocating = false; // State for loading indicator

  @override
  void initState() {
    super.initState();
    _request = widget.request;
    _addressController.text = _request.address!;
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _toggleItem(PickupItem item) {
    setState(() {
      final index = _request.items.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        // Item is already selected, remove it
        final updatedItems = List<PickupItem>.from(_request.items);
        updatedItems.removeAt(index);
        _request = _request.copyWith(items: updatedItems, address: '');
      } else {
        // Item not selected, add it
        final updatedItems = List<PickupItem>.from(_request.items)..add(item);
        _request = _request.copyWith(items: updatedItems, address: '');
      }
    });
  }

  // --- NEW LOCATION LOGIC ---
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocating = true;
    });

    try {
      // 1. Check Permissions
      var permissionStatus = await Permission.location.request();
      if (!permissionStatus.isGranted) {
        throw Exception('Location permission denied.');
      }

      // 2. Get Coordinates
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Convert Coordinates to Address (Placemark)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Construct a full address string
        final address = [
          place.street,
          place.subLocality,
          place.locality, // City (e.g., Red Deer)
          place.administrativeArea, // Province/State (e.g., AB)
          place.postalCode,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        _addressController.text = address;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Address filled from current location.')),
        );
      } else {
        throw Exception('Could not determine address from location.');
      }
    } catch (e) {
      String errorMessage = 'Failed to get location.';
      // Check for specific denial exception
      if (e is Exception && e.toString().contains('denied')) {
        errorMessage = 'Location access denied. Please enable it in settings.';
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLocating = false;
      });
    }
  }
  // --- END NEW LOCATION LOGIC ---

  void _nextStep() {
    if (_formKey.currentState!.validate() && _request.items.isNotEmpty) {
      // 1. Finalize the request with address
      _request =
          _request.copyWith(address: _addressController.text.trim(), items: []);

      // 2. Navigate to Review Page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReviewConfirmationPage(request: _request),
        ),
      );
    } else if (_request.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address & Items'),
        backgroundColor: AppConfig.primaryBrandColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Where should we grab?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // --- Address Input ---
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Full Pickup Address',
                hintText: 'e.g., 123 Main St, Red Deer, AB',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: _isLocating
                    // Show loading spinner while locating
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    // Show location button when ready
                    : IconButton(
                        icon: const Icon(Icons.location_on),
                        onPressed:
                            _getCurrentLocation, // Call new location function
                      ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Address is required' : null,
            ),
            const SizedBox(height: 24),

            // --- Item Selection Grid ---
            Text(
              'What needs grabbing?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: DemoPickupItems.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8, // Make taller to fit price
              ),
              itemBuilder: (context, index) {
                final item = DemoPickupItems.items[index];
                final isSelected = _request.items.any((i) => i.id == item.id);
                final priceText =
                    '~ \$${item.basePrice.toStringAsFixed(0)}'; // show price without cents

                return InkWell(
                  onTap: () => _toggleItem(item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          // ignore: deprecated_member_use
                          ? AppConfig.primaryBrandColor?.withOpacity(0.8)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppConfig.navyBlue
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon,
                            size: 32,
                            color: isSelected
                                ? AppConfig.navyBlue
                                : Colors.grey.shade700),
                        const SizedBox(height: 8),
                        Text(item.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isSelected
                                  ? AppConfig.navyBlue
                                  : Colors.black87,
                            )),
                        Text(priceText,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? AppConfig.navyBlue.withOpacity(0.8)
                                  : Colors.grey.shade600,
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: _nextStep,
          icon: const Icon(Icons.arrow_forward),
          label: Text('Review Booking (${_request.items.length} items)'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConfig.brandGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }

  Future<List<Placemark>> placemarkFromCoordinates(
      double latitude, double longitude) async {
    // Return a non-null list immediately.
    // Replace with real reverse-geocoding later (using package:geocoding) if you add the dependency.
    final String street =
        'Lat: ${latitude.toStringAsFixed(5)}, Lon: ${longitude.toStringAsFixed(5)}';
    final Placemark p = Placemark(
      street: street,
      locality: null,
      postalCode: null,
      country: null,
    );
    return [p];
  }
}

class Placemark {
  final String? street;
  final String? locality;
  final String? postalCode;
  final String? country;

  const Placemark({
    this.street,
    this.locality,
    this.postalCode,
    this.country,
  });
  
  get subLocality => null;
  
  get administrativeArea => null;

  @override
  String toString() => street ?? '';
}

extension on Object {}

class DemoPickupItems {
  get subLocality => null;

  get locality => null;

  get administrativeArea => null;

  get postalCode => null;

  static get items => null;
}
