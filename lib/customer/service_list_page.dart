import 'package:flutter/material.dart';
import 'models.dart';
import 'service_view_page.dart';

class ServiceListPage extends StatelessWidget {
  const ServiceListPage({super.key});

  int _cols(double w) {
    if (w < 600) return 1;
    if (w < 900) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final cols = _cols(constraints.maxWidth);
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 4 / 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: demoServices.length,
            itemBuilder: (ctx, i) {
              final s = demoServices[i];
              return InkWell(
                onTap: () {
                  Navigator.of(ctx).push(
                    MaterialPageRoute(
                      builder: (_) => ServiceViewPage(service: s),
                    ),
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          s.name,
                          style: Theme.of(ctx).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Description
                        Expanded(
                          child: Text(
                            s.description,
                            style: Theme.of(ctx).textTheme.bodyMedium,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Minutes + Price
                        Text('${s.minutes} min • \$${s.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
