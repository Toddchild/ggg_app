import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/job.dart';
import '../widgets/job_list_item.dart';

// --- FIX: Define the global environment constant here ---
const _appId = String.fromEnvironment('APP_ID', defaultValue: 'default_app');
// ------------------------------------------------------

class JobBoardScreen extends StatefulWidget {
  const JobBoardScreen({super.key});

  @override
  State<JobBoardScreen> createState() => _JobBoardScreenState();
}

class _JobBoardScreenState extends State<JobBoardScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _jobNameController = TextEditingController();

  // Get the current user ID for creating the job document
  String get _userId => _auth.currentUser?.uid ?? 'anonymous_user';
  String get _userName => _auth.currentUser?.email ?? 'Anonymous';
  // State to hold the user's current GeoPoint
  GeoPoint _currentLocation = const GeoPoint(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    // Simulate getting location on init (for demonstration purposes)
    _fetchCurrentLocation();
  }

  void _fetchCurrentLocation() {
    // In a real app, this would use a location package (e.g., geolocator).
    // For now, we use a fixed, slightly randomized point.
    setState(() {
      _currentLocation = GeoPoint(
        34.05 +
            (0.5 - 1.0 * (DateTime.now().microsecond / 1000000)), // Example lat
        -118.24 +
            (0.5 - 1.0 * (DateTime.now().microsecond / 1000000)), // Example lon
      );
    });
  }

  void _addJob() async {
    final jobName = _jobNameController.text.trim();
    if (jobName.isEmpty) return;

    final newJob = Job(
      id: '', // ID will be set by Firestore
      name: jobName,
      isCompleted: false,
      userId: _userId,
      userName: _userName,
      createdAt: DateTime.now(),
      location: _currentLocation,
      title: '',
      status: '',
      address: '',
      city: '',
      notes: '',
      price: 0.0,
    );

    try {
      // Use the now-defined __app_id to construct the path
      await _firestore
          .collection('artifacts/$_appId/public/data/jobs')
          .add(newJob.toMap());

      _jobNameController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job posted successfully!')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error adding job: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to post job. Check console.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Job Board'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildAddJobInput(context),
          Expanded(
            // StreamBuilder listens for real-time updates from Firestore
            child: StreamBuilder<QuerySnapshot>(
              // Use the now-defined __app_id to construct the path
              stream: _firestore
                  .collection('artifacts/$_appId/public/data/jobs')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No jobs posted yet. Be the first!'));
                }

                // Map QuerySnapshot documents to a list of Job objects
                final jobs = snapshot.data!.docs.map((doc) {
                  return Job.fromMap(
                      doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                // Simple sorting: sort by creation date (newest first)
                jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                return ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return JobListItem(
                        job: job,
                        firestore: _firestore,
                        currentUserId: _userId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddJobInput(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post a New Job/Task',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _jobNameController,
              decoration: InputDecoration(
                labelText: 'Job Title / Description',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _addJob,
                ),
              ),
              onSubmitted: (_) => _addJob(),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Location: Lat ${_currentLocation.latitude.toStringAsFixed(2)}, Lon ${_currentLocation.longitude.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
