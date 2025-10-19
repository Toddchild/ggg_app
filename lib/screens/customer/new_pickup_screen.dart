import 'package:flutter/material.dart';
// We use a mock library for image picker/API calls in this constrained environment
// In a real app, you would use 'package:image_picker/image_picker.dart' and 'package:http/http.dart'

// --- MOCK API AND IMAGE DATA ---
// Mocking a standard Base64 image payload (e.g., a pile of cardboard boxes)
const String _mockBase64Image =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII='; // A 1x1 transparent PNG

// This function simulates the network request to the Gemini API
Future<String?> analyzeImage(String base64ImageData) async {
  // 1. Define the system instruction and user query for multimodal analysis

  // 2. Define the Gemini API endpoint and structure
  // NOTE: The apiKey will be injected by the environment if it is empty.

  // 3. Construct the payload

  // 4. Simulate the API call (Mocking with a Future.delayed for latency)
  await Future.delayed(const Duration(seconds: 3)); // Simulate network latency

  // In a real app, you'd use a package like 'http' here:
  // final response = await http.post(
  //   Uri.parse('$apiUrl?key=$apiKey'),
  //   headers: {'Content-Type': 'application/json'},
  //   body: json.encode(payload),
  // );
  // final result = json.decode(response.body);
  // return result['candidates']?[0]?['content']?['parts']?[0]?['text'];

  // --- MOCK RESPONSE FOR DEMO ---
  if (base64ImageData.isNotEmpty) {
    return 'The image shows **Household Junk** consisting primarily of flattened cardboard boxes and small plastic packaging. The volume is estimated to be approximately **1/4 of a standard pickup truck load**. The items are easily manageable.';
  }
  return null;
}

// --- NEW PICKUP SCREEN IMPLEMENTATION ---

class NewPickupScreen extends StatefulWidget {
  const NewPickupScreen({super.key});

  @override
  State<NewPickupScreen> createState() => _NewPickupScreenState();
}

class _NewPickupScreenState extends State<NewPickupScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController =
      TextEditingController(text: '123 Main St, Anytown, USA (Mock)');

  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Mocks picking an image and immediately sends it for analysis.
  void _pickAndAnalyzeImage() async {
    setState(() {
      _isLoading = true;
      _descriptionController.text = 'Analyzing image...';
    });

    try {
      final analysisResult = await analyzeImage(_mockBase64Image);

      if (analysisResult != null) {
        // Update the description field with the AI's analysis
        _descriptionController.text = analysisResult;

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('AI Analysis Complete! Description updated.')),
        );
      } else {
        _descriptionController.text = '';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to analyze image.')),
        );
      }
    } catch (e) {
      _descriptionController.text = '';
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during analysis: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitPickup() {
    // In a real application, you would perform final validation here
    // and save the pickup request to Firestore.
    final description = _descriptionController.text;
    final location = _locationController.text;

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a description of the junk.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Pickup Submitted:\nLocation: $location\nDescription: $description'),
        duration: const Duration(seconds: 4),
      ),
    );
    // Clear form after submission
    _descriptionController.clear();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Schedule a New Pickup',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
          ),
          const SizedBox(height: 16),

          // 1. Image Selection and AI Analysis Button
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Step 1: Analyze Your Junk',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Take a picture and our AI will instantly categorize it and provide an estimate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickAndAnalyzeImage,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.camera_alt),
                    label: Text(_isLoading ? 'Analyzing...' : 'Snap & Analyze'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Location Field (Mocked)
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Pickup Location',
              prefixIcon: const Icon(Icons.location_on, color: Colors.green),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabled:
                  false, // Location is usually handled by GPS or map selection
            ),
          ),
          const SizedBox(height: 16),

          // 3. Description Field (Pre-filled by AI)
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Junk Description / AI Analysis',
              alignLabelWithHint: true,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Icon(Icons.description, color: Colors.green),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText:
                  'Describe the items, location, and any special instructions (pre-filled by AI after analysis).',
            ),
          ),
          const SizedBox(height: 30),

          // 4. Submission Button
          ElevatedButton(
            onPressed: _submitPickup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade800,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              textStyle:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Confirm Pickup Request'),
          ),
        ],
      ),
    );
  }
}
