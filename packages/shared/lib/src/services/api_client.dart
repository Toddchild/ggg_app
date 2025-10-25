import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client;
  final Map<String, String> _defaultHeaders;

  ApiClient({
    String? baseUrl,
    http.Client? client,
    Map<String, String>? defaultHeaders,
  })  : baseUrl = baseUrl ?? AppConfig.instance.apiBaseUrl,
        _client = client ?? http.Client(),
        _defaultHeaders = defaultHeaders ?? {'Content-Type': 'application/json'};

  // GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await _client.get(
      uri,
      headers: _mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  // POST request
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await _client.post(
      uri,
      headers: _mergeHeaders(headers),
      body: body != null ? json.encode(body) : null,
    );
    return _handleResponse(response);
  }

  // PUT request
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await _client.put(
      uri,
      headers: _mergeHeaders(headers),
      body: body != null ? json.encode(body) : null,
    );
    return _handleResponse(response);
  }

  // DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await _client.delete(
      uri,
      headers: _mergeHeaders(headers),
    );
    return _handleResponse(response);
  }

  // PATCH request
  Future<dynamic> patch(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);
    final response = await _client.patch(
      uri,
      headers: _mergeHeaders(headers),
      body: body != null ? json.encode(body) : null,
    );
    return _handleResponse(response);
  }

  // Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final uri = Uri.parse('$baseUrl$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }
    return uri;
  }

  // Merge custom headers with default headers
  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {..._defaultHeaders, ...?headers};
  }

  // Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return null;
      }
      try {
        return json.decode(response.body);
      } catch (e) {
        return response.body;
      }
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }

  // Close the client
  void close() {
    _client.close();
  }
}

// Custom exception for API errors
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message)';
  }
}
