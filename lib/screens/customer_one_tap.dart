import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ggg_app/app_config.dart';

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
      appBar: AppBar(title: const Text('Quick Pickup / Instant Quote')),
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
                              Icon(Icons.shopping_bag, size: 28),
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
