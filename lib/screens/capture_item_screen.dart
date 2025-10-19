// lib/screens/capture_item_screen.dart
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Data returned for each captured photo (with GPS+timestamp).
class PhotoEvidence {
  final String path;
  final double latitude;
  final double longitude;
  final DateTime takenAt;

  const PhotoEvidence({
    required this.path,
    required this.latitude,
    required this.longitude,
    required this.takenAt,
  });

  Map<String, dynamic> toJson() => {
        'path': path,
        'lat': latitude,
        'lng': longitude,
        'takenAt': takenAt.toIso8601String(),
      };
}

/// Push this screen and await a `List<PhotoEvidence>` result.
/// Example:
/// final photos = await Navigator.push<List<PhotoEvidence>>(
///   context,
///   MaterialPageRoute(builder: (_) => const CaptureItemScreen(itemName: 'Fridge')),
/// );
class CaptureItemScreen extends StatefulWidget {
  final String itemName;
  final int minPhotos;
  final int maxPhotos;

  const CaptureItemScreen({
    super.key,
    required this.itemName,
    this.minPhotos = 2,
    this.maxPhotos = 4,
  });

  @override
  State<CaptureItemScreen> createState() => _CaptureItemScreenState();
}

class _CaptureItemScreenState extends State<CaptureItemScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _initializing = true;
  bool _busy = false;

  final List<PhotoEvidence> _shots = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _boot();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cam = _controller;
    if (cam == null || !cam.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      cam.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _boot() async {
    try {
      setState(() => _initializing = true);

      // Permissions
      final camStatus = await Permission.camera.request();
      final locStatus = await Permission.locationWhenInUse.request();
      if (camStatus != PermissionStatus.granted ||
          locStatus != PermissionStatus.granted) {
        _snack('Camera/Location permission is required.');
        setState(() => _initializing = false);
        return;
      }

      // Location services on?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) _snack('Please enable Location Services.');

      await _initCamera();
    } catch (e) {
      _snack('Init error: $e');
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      final back = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () =>
            _cameras.isNotEmpty ? _cameras.first : (throw 'No camera'),
      );

      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      _controller = controller;
      await controller.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      _snack('Camera error: $e');
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (_shots.length >= widget.maxPhotos) {
      _snack('Max ${widget.maxPhotos} photos reached.');
      return;
    }

    setState(() => _busy = true);
    try {
      final x = await controller.takePicture();
      final pos = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.best,
      );

      _shots.add(
        PhotoEvidence(
          path: x.path,
          latitude: pos.latitude,
          longitude: pos.longitude,
          takenAt: DateTime.now(),
        ),
      );
      setState(() {});
    } catch (e) {
      _snack('Capture failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _removeAt(int i) {
    if (i < 0 || i >= _shots.length) return;
    setState(() => _shots.removeAt(i));
  }

  void _continue() {
    if (_shots.length < widget.minPhotos) return;
    Navigator.of(context).pop<List<PhotoEvidence>>(_shots);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final canContinue = _shots.length >= widget.minPhotos;
    final countLabel = '${_shots.length}/${widget.maxPhotos}';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview
            Positioned.fill(
              child: (controller != null && controller.value.isInitialized)
                  ? CameraPreview(controller)
                  : _initializing
                      ? const Center(child: CircularProgressIndicator())
                      : const Center(
                          child: Text(
                            'Camera not available',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
            ),

            // Tips
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header('Take photos of the item where it sits'),
                    _Tip('Show the whole item + surroundings'),
                    _Tip('Include access path if relevant'),
                    _Tip('Good lighting, steady hands'),
                    _Tip('GPS is attached automatically'),
                  ],
                ),
              ),
            ),

            // Bottom controls
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Thumbnails row + count
                    Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(_shots.length, (i) {
                                return _Thumb(
                                  index: i,
                                  path: _shots[i].path,
                                  onRemove: () => _removeAt(i),
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            countLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Shutter + Continue
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: GestureDetector(
                              onTap: _busy ? null : _capture,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 5),
                                ),
                                child: Center(
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 150),
                                    opacity: _busy ? 0.3 : 1,
                                    child: Container(
                                      width: 54,
                                      height: 54,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // ignore: deprecated_member_use
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  canContinue ? Colors.green : Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: canContinue ? _continue : null,
                            child: const Text(
                              'Continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Close
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(backgroundColor: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          height: 1.2,
        ),
      );
}

class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);
  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white70, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(text,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        ],
      );
}

class _Thumb extends StatelessWidget {
  final int index;
  final String path;
  final VoidCallback onRemove;
  const _Thumb(
      {required this.index, required this.path, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(path),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 80,
                color: Colors.white10,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.white54),
              ),
            ),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.close, size: 18, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                padding: const EdgeInsets.all(6),
              ),
              tooltip: 'Remove photo ${index + 1}',
            ),
          ),
        ],
      ),
    );
  }
}
