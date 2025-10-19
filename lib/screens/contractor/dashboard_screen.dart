import 'package:flutter/material.dart';

// 1. Data Model for a Pickup Job
class PickupJob {
  final String id;
  final String location;
  final String description;
  final String estimatedVolume;
  final String type;
  final double payout;

  PickupJob({
    required this.id,
    required this.location,
    required this.description,
    required this.estimatedVolume,
    required this.type,
    required this.payout,
  });
}

// 2. Mock Data representing jobs created by customers (including AI-analyzed content)
final List<PickupJob> mockJobs = [
  PickupJob(
    id: 'JOB-001',
    location: '456 Oak Ln, Anytown',
    description:
        'The image shows Household Junk consisting primarily of flattened cardboard boxes and small plastic packaging. The volume is estimated to be approximately 1/4 of a standard pickup truck load. The items are easily manageable.',
    estimatedVolume: '1/4 Load',
    type: 'Household Junk',
    payout: 45.00,
  ),
  PickupJob(
    id: 'JOB-002',
    location: '901 Pine Dr, Anytown',
    description:
        'A large pile of tree branches, leaves, and a few broken fence segments. This is categorized as Yard Waste and requires gloves. Estimated volume is a Full Load.',
    estimatedVolume: 'Full Load',
    type: 'Yard Waste',
    payout: 120.00,
  ),
  PickupJob(
    id: 'JOB-003',
    location: '10 Industrial Pkwy, Anytown',
    description:
        'Demolition debris including dry wall pieces, broken cinder blocks, and two metal window frames. Categorized as Construction Debris. Estimated volume is 1/2 Load.',
    estimatedVolume: '1/2 Load',
    type: 'Construction Debris',
    payout: 85.00,
  ),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Available Pickup Routes'),
            floating: true,
            pinned: true,
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            elevation: 4,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Refreshed job listings.')),
                  );
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(12.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final job = mockJobs[index];
                  return JobCard(job: job);
                },
                childCount: mockJobs.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'End of available listings.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black45),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final PickupJob job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header Row: Job ID and Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job.id,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange.shade300,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    job.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),

            // Location
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Colors.deepOrange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    job.location,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Volume and Payout
            Row(
              children: [
                // Estimated Volume
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.inventory_2,
                    label: 'Volume: ${job.estimatedVolume}',
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(width: 12),
                // Payout
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.payments,
                    label: 'Payout: \$${job.payout.toStringAsFixed(2)}',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description (AI Analysis)
            Text(
              'AI Analysis:',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              job.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),

            // Action Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Job ${job.id} Accepted! Route started.')),
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Accept Job'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      {required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        // ignore: deprecated_member_use
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13, color: color, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
