/// lib/screens/job_detail.dart
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/job.dart';
import '../services/jobs_api.dart';
import '../services/ggg_api.dart';
import '../services/ggg_api_mock.dart';
import '../services/cred_store.dart';

class JobDetailScreen extends StatefulWidget {
  final Job job;
  final bool demoMode; // passed from Contractor screen (flask toggler)
  const JobDetailScreen({
    super.key,
    required this.job,
    this.demoMode = false,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late Job _job;
  JobsApi? _api;
  bool _busy = false;

  // If true, we’re in demo either because user turned it on, or because there
  // are no saved credentials (auto fallback to demo).
  late bool _useDemo;

  final List<Uint8List> _photos = [];

  @override
  void initState() {
    super.initState();
    _job = widget.job;
    _useDemo = widget.demoMode;

    // If demo explicitly ON -> use mock API immediately.
    if (_useDemo) {
      _api = GggApiMock();
    } else {
      // Try to load real creds; if missing, auto-fallback to demo.
      _loadApiWithAutoFallback();
    }
  }

  Future<void> _loadApiWithAutoFallback() async {
    final (u, p) = await CredStore().load();
    if (!mounted) return;

    if (u != null && p != null && u.isNotEmpty && p.isNotEmpty) {
      setState(() {
        _api = GggApi(user: u, pass: p);
        _useDemo = false;
      });
    } else {
      // No creds found — run in demo automatically so buttons still work
      setState(() {
        _api = GggApiMock();
        _useDemo = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No login found: using Demo for this job')),
      );
    }
  }

  // ----- Helpers -----
  String get _status => (_job.status ?? '').toLowerCase();
  bool get _canAccept => _status == 'open';
  bool get _canArrive => _status == 'accepted';
  bool get _canComplete => _status == 'arrived' && _photos.length >= 2;

  Future<void> _pickPhoto() async {
    final res = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
      withData: true,
    );
    if (res != null && res.files.isNotEmpty && res.files.first.bytes != null) {
      setState(() => _photos.add(res.files.first.bytes!));
    }
  }

  Future<void> _run(Future<Job> Function() fn) async {
    if (_api == null) {
      // With the auto-fallback this should rarely happen, but keep the guard.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not ready yet — please try again')),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final updated = await fn();
      if (mounted) setState(() => _job = updated);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _accept() async => _run(() => _api!.accept(_job.id));
  Future<void> _arrive() async => _run(() => _api!.arrive(_job.id));
  Future<void> _complete() async {
    if (_photos.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add 2 photos first.')),
      );
      return;
    }
    await _run(() => _api!.complete(_job.id));
  }
  Future<void> _cancel() async => _run(() => _api!.cancel(_job.id));
  Future<void> _escalate() async {
    final note = await showDialog<String?>(
      context: context,
      builder: (_) {
        final c = TextEditingController();
        return AlertDialog(
          title: const Text('Escalate'),
          content: TextField(
            controller: c,
            decoration: const InputDecoration(hintText: 'What happened?'),
            maxLines: 3,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, null), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('Send')),
          ],
        );
      },
    );
    if (note == null || note.isEmpty) return;
    await _run(() => _api!.escalate(_job.id, message: note));
  }

  // ----- UI -----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_job.title ?? 'Job ${_job.id}'),
        actions: [
          if (_useDemo)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.science, color: Colors.pink),
            ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_useDemo)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  border: Border.all(color: Colors.pink.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('JOB DETAIL — DEMO READY',
                    style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
              ),

            Row(
              children: [
                Chip(label: Text('Status: ${(_job.status ?? '').toUpperCase()}')),
                const SizedBox(width: 12),
                if (_useDemo)
                  const Chip(label: Text('DEMO'), backgroundColor: Color(0xffffe4ec)),
              ],
            ),
            const SizedBox(height: 8),
            if ((_job.address ?? '').isNotEmpty) Text(_job.address!),

            const SizedBox(height: 16),
            const Divider(),

            const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(_useDemo
                ? 'Example note for this demo job. This is only shown in demo mode.'
                : '—'),

            const SizedBox(height: 16),
            const Divider(),

            // Photos section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Photos (need 2)', style: Theme.of(context).textTheme.titleMedium),
                FilledButton.icon(
                  onPressed: _pickPhoto,
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Add photo'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_photos.isEmpty)
              const Text('No photos yet. Add two to enable Complete.'),
            if (_photos.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _photos
                    .asMap()
                    .entries
                    .map(
                      (e) => Stack(
                        children: [
                          Image.memory(
                            e.value,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: InkWell(
                              onTap: () => setState(() => _photos.removeAt(e.key)),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(Icons.close, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),

            const SizedBox(height: 24),

            // Action buttons
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: _busy || !_canAccept ? null : _accept,
                  child: const Text('Accept'),
                ),
                FilledButton(
                  onPressed: _busy || !_canArrive ? null : _arrive,
                  child: const Text('Arrive'),
                ),
                FilledButton(
                  onPressed: _busy || !_canComplete ? null : _complete,
                  child: const Text('Complete'),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : _cancel,
                  child: const Text('Cancel'),
                ),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _escalate,
                  icon: const Icon(Icons.report),
                  label: const Text('Escalate'),
                ),
              ],
            ),

            if (_busy) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}
