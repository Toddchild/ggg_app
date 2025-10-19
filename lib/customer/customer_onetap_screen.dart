// lib/customer/customer_onetap_screen.dart
import 'package:flutter/material.dart';
import 'package:ggg_app/app_config.dart';
import 'package:url_launcher/url_launcher.dart';
// Corrected import path

class CustomerOneTapScreen extends StatelessWidget {
  const CustomerOneTapScreen({super.key});

  Uri _checkoutUriFor(int productId, {int qty = 1}) {
    // Open checkout with the item added in the same URL.
    // Works on most Woo setups: /checkout/?add-to-cart=<id>&quantity=<qty>
    return Uri.parse(
      '${AppConfig.baseUrl}/checkout/?add-to-cart=$productId&quantity=$qty',
    );
  }

  Future<void> _openCheckout(BuildContext context, QuickItem item) async {
    final uri = _checkoutUriFor(item.productId);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open checkout for ${item.label}')),
      );
    }
  }

  Future<void> _openInstantQuote() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/instant-quote/');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use the logo URL from AppConfig instead of a text title
        title: Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 40),
            child: Image.network(
              AppConfig.logoUrl ?? '',
              fit: BoxFit.contain,
              // Fallback if the logo cannot be loaded
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Quick Pickup / Instant Quote',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                );
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // One-tap quick items
            Align(
              alignment: Alignment.centerLeft,
              child: Text('One-tap pickup', style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                itemCount: AppConfig.quickItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.9,
                ),
                itemBuilder: (context, i) {
                  final item = AppConfig.quickItems[i];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => _openCheckout(context, item),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item.icon, size: 28), // Uses the updated icons
                              const SizedBox(height: 8),
                              Text(item.label, textAlign: TextAlign.center),
                              const SizedBox(height: 6),
                              const Text('Tap → Checkout', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Instant Quote link
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _openInstantQuote,
              icon: const Icon(Icons.flash_on),
              label: const Text('Instant Quote (multi-item)'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
