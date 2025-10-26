// lib/screens/contractor_home.dart

import 'package:flutter/material.dart';
import 'package:ggg_app/screens/job_detail.dart';
import 'package:intl/intl.dart';
import '../models/job.dart';
import '../services/api_service.dart';

// This page serves as the contractor's main dashboard with tabbed views
// for Available, In Progress, and Completed jobs.

class ContractorHomePage extends StatefulWidget {
  const ContractorHomePage({super.key});

  @override
  State<ContractorHomePage> createState() => _ContractorHomePageState();
}

class _ContractorHomePageState extends State<ContractorHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();

  // State to manage loading the entire job list
  late Future<List<Job>> _jobsFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller for 3 tabs
    _tabController = TabController(length: 3, vsync: this);
    // Start fetching jobs immediately
    _jobsFuture = _apiService.fetchContractorJobs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Utility Functions ---

  // Re-fetches the jobs from the API
  void _refreshJobs() {
    setState(() {
      _jobsFuture = _apiService.fetchContractorJobs();
    });
  }

  // Handles navigation to the detail page and checks for required refresh
  Future<void> _navigateToDetail(Job job) async {
    // Navigates to the detail page and waits for a result (true if refresh needed)
    final needsRefresh = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobDetailScreen(job: job),
      ),
    );

    // If the result is 'true', refresh the list
    if (needsRefresh == true) {
      _refreshJobs();
    }
  }

  // Filters the entire job list based on the required status
  List<Job> _filterJobs(List<Job> allJobs, String status) {
    if (status == 'available') {
      // Available jobs are pending and not yet accepted by anyone (contractorId is null)
      return allJobs
          .where((j) => j.status == 'pending' && j.contractorId == null)
          .toList();
    }
    if (status == 'myJobs') {
      // My Jobs are those in progress and assigned to the current contractor
      final currentContractorId = _apiService.contractorId;
      return allJobs
          .where((j) =>
              j.status == 'inProgress' && j.contractorId == currentContractorId)
          .toList();
    }
    if (status == 'completed') {
      // Completed jobs
      final currentContractorId = _apiService.contractorId;
      return allJobs
          .where((j) =>
              j.status == 'completed' && j.contractorId == currentContractorId)
          .toList();
    }
    // Return an empty list if the status is unknown
    return [];
  }

  // Quick action handler for accepting a job directly from the list
  Future<void> _handleQuickAccept(Job job) async {
    setState(() {
      job.isAccepting = true;
    });

    try {
      await _apiService.updateJobStatus(job.id, 'inProgress');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Job #${job.id} Accepted! It\'s now in "My Jobs".')),
        );
      }
      // Force refresh the list to instantly move the job to the correct tab
      _refreshJobs();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accepting job: $e')),
        );
      }
      setState(() {
        job.isAccepting = false; // Reset loading state
      });
    }
  }

  // --- Widget Builders ---

  // Builds a list view for a specific job status
  Widget _buildJobList(List<Job> jobs, String statusKey) {
    if (jobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cleaning_services_outlined,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                statusKey == 'available'
                    ? 'No available jobs right now.'
                    : statusKey == 'myJobs'
                        ? 'No jobs in progress. Time to accept one!'
                        : 'No completed jobs this month.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _refreshJobs(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          final isAvailable = statusKey == 'available';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: InkWell(
              onTap: () => _navigateToDetail(job),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title & ID
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          job.title ?? 'Untitled Job',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isAvailable
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                        ),
                        Text(
                          '#${job.id}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pickup Details
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('EEE, MMM d, h:mm a')
                              .format(job.pickupTime),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        const Icon(Icons.monetization_on, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '\$${(job.price * 0.75).toStringAsFixed(2)}', // Contractor Pay
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.green.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Address
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            job.address ?? 'No address provided',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    if (isAvailable) ...[
                      const Divider(height: 24),
                      // --- Quick Accept Button (Micro-Step 15) ---
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: (job.isAccepting ?? false)
                              ? null
                              : () => _handleQuickAccept(job),
                          icon: (job.isAccepting ?? false)
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.directions_car_filled),
                          label: Text((job.isAccepting ?? false)
                              ? 'Accepting...'
                              : 'Quick Accept'),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'My Jobs'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: FutureBuilder<List<Job>>(
        future: _jobsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Failed to load jobs.',
                        style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    Text(snapshot.error.toString()),
                    const SizedBox(height: 16),
                    OutlinedButton(
                        onPressed: _refreshJobs,
                        child: const Text('Try Again')),
                  ],
                ),
              ),
            );
          }

          final allJobs = snapshot.data ?? [];

          // Use the TabBarView to display the filtered lists
          return TabBarView(
            controller: _tabController,
            children: [
              _buildJobList(_filterJobs(allJobs, 'available'), 'available'),
              _buildJobList(_filterJobs(allJobs, 'myJobs'), 'myJobs'),
              _buildJobList(_filterJobs(allJobs, 'completed'), 'completed'),
            ],
          );
        },
      ),
    );
  }
}
