import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000';

  static final _client = http.Client();

  // GET method
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {'Accept': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST method
  static Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    print('API Response: ${response.statusCode} - ${response.body}');
    final responseBody = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseBody;
    } else if (response.statusCode == 404) {
      throw Exception('Endpoint not found: ${response.request?.url}');
    } else {
      throw Exception(
        'HTTP ${response.statusCode}: ${responseBody['message'] ?? response.body}',
      );
    }
  }

  static void close() => _client.close();
}

// API endpoints
Future<dynamic> getLocations() => ApiService.get('locations');
Future<dynamic> getLocationById(String id) => ApiService.get('locations/$id');
Future<dynamic> register(Map<String, dynamic> userData) => ApiService.post('register', userData);
Future<dynamic> login(Map<String, dynamic> credentials) => ApiService.post('login', credentials);
Future <dynamic> logout() => ApiService.post('logout', {});
