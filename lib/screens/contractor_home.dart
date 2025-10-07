import 'package:flutter/material.dart';
import '../models/job.dart';
import '../data/mock_jobs.dart';
import 'job_detail.dart';

class ContractorHome extends StatefulWidget {
  const ContractorHome({super.key});

  @override
  State<ContractorHome> createState() => _ContractorHomeState();
}

class _ContractorHomeState extends State<ContractorHome> {
  // DEMO is hard-locked ON to eliminate any network (no more 404s).
  final bool _useDemo = true;

  List<Job> _open = const [];
  List<Job> _mine = const [];

  @override
  void initState() {
    super.initState();
    _loadDemo();
  }

  void _loadDemo() {
    // Pull everything from local mock data. No API calls.
    setState(() {
      _mine = List<Job>.from(MockJobs.mine);
      _open = List<Job>.from(MockJobs.open);
    });

    // Let’s also show a toast the first time / on refresh.
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('DEMO LIST — mock jobs loaded')),
      );
    }
  }

  void _openDetail(Job j) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobDetailScreen(job: j), // local-only detail
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor — DEMO (Local Only)'),
        actions: [
          // Pink "DEMO" badge so it's obvious
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.pink.shade100,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: Colors.pink.shade300),
            ),
            alignment: Alignment.center,
            child: const Text('DEMO', style: TextStyle(color: Colors.pink)),
          ),
          IconButton(
            tooltip: 'Reload demo jobs',
            onPressed: _loadDemo,
            icon: const Icon(Icons.refresh),
          ),
          // Flask icon shown but disabled (demo is locked ON)
          IconButton(
            tooltip: 'Demo is locked ON',
            onPressed: null,
            icon: const Icon(Icons.science),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: (_open.isEmpty && _mine.isEmpty)
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No demo jobs yet'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _loadDemo,
                      child: const Text('Load Demo Jobs'),
                    ),
                  ],
                ),
              )
            : ListView(
                children: [
                  if (_mine.isNotEmpty) ...[
                    const _SectionHeader('My Jobs'),
                    ..._mine.map(_buildTile),
                    const SizedBox(height: 20),
                  ],
                  if (_open.isNotEmpty) ...[
                    const _SectionHeader('Open Jobs'),
                    ..._open.map(_buildTile),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildTile(Job j) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(j.title ?? 'Job'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((j.address ?? '').isNotEmpty) Text(j.address),
            if ((j.city ?? '').isNotEmpty) Text(j.city!),
            if ((j.status ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Status: ${j.status}'),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _openDetail(j),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 4, 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
