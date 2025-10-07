// lib/main_contractor.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'app_config.dart';
import 'models/job.dart';
import 'services/ggg_api.dart';

void main() {
  runApp(const ContractorApp());
}

class ContractorApp extends StatefulWidget {
  const ContractorApp({super.key});

  @override
  State<ContractorApp> createState() => _ContractorAppState();
}

class _ContractorAppState extends State<ContractorApp> {
  late final GggApi _api;
  bool _loading = false;
  String _error = '';
  List<Job> _jobs = const [];

  // SnackBars via a messenger key (avoids context lookup issues).
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Local photo counters so UI can show 📷 count even if Job model lacks `photos`.
  final Map<int, int> _localPhotoCount = <int, int>{};

  // Only show these statuses in the contractor list.
  static const Set<String> _visibleStatuses = {
    'open',
    'accepted',
    'arrived',
  };

  @override
  void initState() {
    super.initState();
    _api = GggApi(
      user: AppConfig.contractorUsername,
      pass: AppConfig.contractorAppPassword,
      baseUrl: AppConfig.baseUrl,
    );
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      // Fetch by buckets; we’ll still filter client-side just in case.
      final open = await _api.listJobs('open');
      final accepted = await _api.listJobs('accepted');
      final arrived = await _api.listJobs('arrived');

      final combined = <Job>[...open, ...accepted, ...arrived];
      final filtered = combined.where((j) {
        final s = j.status.toLowerCase();
        return _visibleStatuses.contains(s);
      }).toList();

      setState(() {
        _jobs = filtered;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _act(int id, String status) async {
    setState(() => _loading = true);
    try {
      switch (status) {
        case 'open':
          await _api.accept(id);
          break;
        case 'accepted':
          await _api.arrive(id);
          break;
        case 'arrived':
          // Completing may require at least 2 photos (server enforces this).
          await _api.complete(id);
          break;
        default:
          // completed/canceled/escalated → no action here
          break;
      }
      await _refresh();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickAndUpload(int jobId) async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
      if (res == null || res.files.isEmpty || res.files.first.bytes == null) {
        return; // user canceled
      }
      final bytes = res.files.first.bytes!.toList(); // List<int>
      setState(() => _loading = true);
      await _api.uploadPhoto(jobId, bytes);

      // Update local counter so UI reflects upload immediately.
      _localPhotoCount.update(jobId, (v) => v + 1, ifAbsent: () => 1);

      await _refresh();
      _messengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Photo uploaded')),
      );
    } catch (e) {
      _messengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GGG Contractor',
      scaffoldMessengerKey: _messengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GGG Contractor'),
          actions: [
            IconButton(
              onPressed: _loading ? null : _refresh,
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _error,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : _jobs.isEmpty
                    ? RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text('No jobs yet')),
                            SizedBox(height: 400),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _jobs.length,
                          itemBuilder: (context, index) {
                            final j = _jobs[index];

                            // Derive photo count from server or local fallback.
                            final int serverCount = (() {
                              try {
                                final dynamic d = j; // avoid static error if no field
                                final p = d.photos;
                                if (p is List) return p.length;
                              } catch (_) {}
                              return 0;
                            })();
                            final int count = serverCount > 0
                                ? serverCount
                                : (_localPhotoCount[j.id] ?? 0);

                            // Try to extract photo URLs from server model (if present).
                            final List<String> urls = (() {
                              try {
                                final dynamic d = j;
                                final p = d.photos;
                                if (p is List) {
                                  return p.whereType<String>().toList();
                                }
                              } catch (_) {}
                              return const <String>[];
                            })();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  onTap: _loading ? null : () => _act(j.id, j.status),
                                  // Leading thumbnail (first photo) with error fallback.
                                  leading: (urls.isNotEmpty)
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.network(
                                            urls.first,
                                            width: 56,
                                            height: 56,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.broken_image),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.photo_size_select_actual_outlined),
                                  title: Text(j.title),
                                  subtitle: Text(
                                    'Status: ${j.status}  •  #${j.id}'
                                    '${count > 0 ? '  •  📷 $count' : ''}',
                                  ),
                                  trailing: _buildActionFor(j),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                ),
                                if (urls.isNotEmpty)
                                  SizedBox(
                                    height: 72,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.only(
                                        left: 16, right: 16, bottom: 8),
                                      itemBuilder: (_, i) => ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          urls[i],
                                          width: 96,
                                          height: 72,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.broken_image),
                                        ),
                                      ),
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 8),
                                      itemCount: urls.length,
                                    ),
                                  ),
                                const Divider(height: 1),
                              ],
                            );
                          },
                        ),
                      ),
        floatingActionButton: FloatingActionButton(
          onPressed: _loading ? null : _refresh,
          child: const Icon(Icons.sync),
        ),
      ),
    );
  }

  Widget? _buildActionFor(Job j) {
    switch (j.status) {
      case 'open':
        return ElevatedButton(
          onPressed: _loading ? null : () => _act(j.id, j.status),
          child: const Text('Accept'),
        );
      case 'accepted':
        return ElevatedButton(
          onPressed: _loading ? null : () => _act(j.id, j.status),
          child: const Text('Arrive'),
        );
      case 'arrived':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Upload photo',
              onPressed: _loading ? null : () => _pickAndUpload(j.id),
              icon: const Icon(Icons.photo_camera),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _loading ? null : () => _act(j.id, j.status),
              child: const Text('Complete'),
            ),
          ],
        );
      default:
        return const SizedBox.shrink(); // completed/canceled/escalated
    }
  }
}
