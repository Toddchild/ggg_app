// lib/screens/contractor_home.dart
import 'package:flutter/material.dart';
import 'package:ggg_app/screens/job_detail.dart';
import '../models/job.dart';
import '../services/api_service.dart' hide BuildContext;

class ContractorHome extends StatefulWidget {
  final ApiService apiService;
  const ContractorHome({required this.apiService, super.key});

  @override
  State<ContractorHome> createState() => _ContractorHomeState();
}

// Private widget to handle the list view for each tab
class _JobListView extends StatelessWidget {
  final ApiService apiService;
  final String status;
  final List<Job> jobs;
  final Function(bool) onRefreshNeeded;

  const _JobListView({
    required this.apiService,
    required this.status,
    required this.jobs,
    required this.onRefreshNeeded,
  });
  // Navigates to the detail page and handles the return value (needs refresh)
  Future<void> _navigateToDetail(BuildContext context, Job job) async {
    final bool? needsRefresh = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobDetailScreen(
          job: job,
        ),
      ),
    );

    // Pass the refresh signal back up to the parent `ContractorHome`
    // Pass the refresh signal back up to the parent `ContractorHome`
    if (needsRefresh == true) {
      onRefreshNeeded(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return Center(
        child: Text(
          'No ${status.toLowerCase()} jobs found.',
          style: TextStyle(color: Theme.of(context).colorScheme.outline),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: status == 'pending'
                  ? Colors.red.shade100
                  : status == 'inProgress'
                      ? Colors.amber.shade100
                      : Colors.green.shade100,
              child: Icon(
                status == 'pending'
                    ? Icons.assignment_outlined
                    : status == 'inProgress'
                        ? Icons.forklift
                        : Icons.check_circle_outline,
                color: status == 'pending'
                    ? Colors.red
                    : status == 'inProgress'
                        ? Colors.amber.shade700
                        : Colors.green.shade700,
              ),
            ),
            title: Text(
              job.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Job #${job.id} | ${job.pickupTime.toString().substring(0, 16)}',
            ),
            trailing: Text(
              job.status.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == 'pending'
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            onTap: () => _navigateToDetail(context, job),
          ),
        );
      },
    );
  }
}

class _ContractorHomeState extends State<ContractorHome> {
  // We fetch all relevant jobs once and then filter them based on the tab
  late Future<List<Job>> _jobsFuture;

  // Tab controller labels and the corresponding status filters
  final List<String> _tabs = ['Available', 'My Jobs', 'Completed'];
  final Map<String, List<String>> _statusMap = {
    'Available': ['pending'], // Jobs ready to be accepted
    'My Jobs': ['inProgress'], // Jobs accepted by the current contractor
    'Completed': ['completed'], // Jobs finished
  };

  @override
  void initState() {
    super.initState();
    _jobsFuture = _fetchJobs();
  }

  // Refetches jobs from the API (used on refresh and when returning from detail)
  Future<List<Job>> _fetchJobs() async {
    // In a real app, this would query a single endpoint for all contractor jobs,
    // but for demo simplicity, we query and combine status lists.
    final available = await widget.apiService.listJobs('pending');
    final inProgress = await widget.apiService.listJobs('inProgress');
    final completed = await widget.apiService.listJobs('completed');

    return [...available, ...inProgress, ...completed];
  }

  // Handles the explicit refresh request
  Future<void> _handleRefresh() async {
    setState(() {
      _jobsFuture = _fetchJobs();
    });
  }

  // Handles the refresh request from child widgets (JobDetailPage)
  void _handleRefreshNeeded(bool needsRefresh) {
    if (needsRefresh) {
      _handleRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contractor Dashboard'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _handleRefresh,
            ),
          ],
          bottom: TabBar(
            tabs: _tabs.map((name) => Tab(text: name)).toList(),
            indicatorColor: Theme.of(context).colorScheme.onPrimary,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: FutureBuilder<List<Job>>(
          future: _jobsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading jobs: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No jobs to display.'));
            }

            // Data loaded successfully, now build the tab views
            final allJobs = snapshot.data!;

            return TabBarView(
              children: _tabs.map((tabName) {
                final requiredStatuses = _statusMap[tabName]!;

                // Filter the jobs based on the required statuses for the current tab
                final filteredJobs = allJobs
                    .where((job) => requiredStatuses.contains(job.status))
                    .toList();

                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: _JobListView(
                    apiService: widget.apiService,
                    status: tabName,
                    jobs: filteredJobs,
                    onRefreshNeeded: _handleRefreshNeeded,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
