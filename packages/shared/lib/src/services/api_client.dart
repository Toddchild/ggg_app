import 'package:http/http.dart' as http;

// Minimal ApiClient stub so shared exports resolve.
// Replace with your real networking code.

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<http.Response> get(String path) {
    final uri = Uri.parse('$baseUrl$path');
    return http.get(uri);
  }

  Future<http.Response> post(String path, {Map<String, String>? headers, Object? body}) {
    final uri = Uri.parse('$baseUrl$path');
    return http.post(uri, headers: headers, body: body);
  }
}
