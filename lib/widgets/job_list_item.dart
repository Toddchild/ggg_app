// lib/widgets/job_list_item.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job.dart';

// The global application ID is needed to build the Firestore path.
// It is read from the environment variables set by the platform.

class JobListItem extends StatelessWidget {
  final Job job;
  final FirebaseFirestore firestore;
  final String currentUserId;

  const JobListItem({
    super.key,
    required this.job,
    required this.firestore,
    required this.currentUserId,
  });

  // ignore: non_constant_identifier_names
  get _app_id => null;

  Future<void> _toggleJobCompletion(BuildContext context) async {
    // FIX: Using the global constant to construct the secure Firestore path.
    // The path structure is: /artifacts/{appId}/public/data/jobs/{docId}
    final docRef =
        firestore.collection('artifacts/$_app_id/public/data/jobs').doc(job.id);

    // Determine the new status
    final bool newStatus = !job.isCompleted;

    try {
      await docRef.update({
        'isCompleted': newStatus,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus ? 'Job marked as COMPLETED.' : 'Job reverted to PENDING.',
          ),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update job status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only the user who created the job can mark it as complete/incomplete.
    final bool isOwner = currentUserId == job.userId;

    // Use job.isCompleted to determine color and icon
    final Color iconColor =
        job.isCompleted ? Colors.green.shade600 : Colors.blue.shade600;
    final IconData icon = job.isCompleted ? Icons.check_circle : Icons.work;
    final String statusText = job.isCompleted ? 'COMPLETED' : 'PENDING';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(icon, size: 36, color: iconColor),
        title: Text(
          job.name,
          style: TextStyle(
            decoration: job.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $statusText', style: TextStyle(color: iconColor)),
            Text(
                'Posted by: ${job.userName} (${job.userId.substring(0, 8)}...)'),
            Text(
                'Location: Lat ${job.location.latitude.toStringAsFixed(2)}, Lon ${job.location.longitude.toStringAsFixed(2)}'),
            Text('Date: ${job.createdAt.toLocal().toString().split(' ')[0]}'),
          ],
        ),
        trailing: isOwner
            ? IconButton(
                tooltip:
                    job.isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                icon: Icon(job.isCompleted ? Icons.undo : Icons.done_all),
                color: job.isCompleted ? Colors.orange : Colors.green,
                onPressed: () => _toggleJobCompletion(context),
              )
            : null, // Only show button if the current user is the owner
        onTap: () {
          // Optional: Navigate to a detailed job view later
        },
      ),
    );
  }
}
