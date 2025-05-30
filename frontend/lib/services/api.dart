// lib/services/api.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000/';
  
  static final _client = http.Client();

  // GET method
  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {'Accept': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static dynamic _handleResponse(http.Response response) {
    print('API Response: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  static void close() => _client.close();
}

// API endpoints
Future<dynamic> getLocations() => ApiService.get('locations'); // Removed leading slash
Future<dynamic> getLocationById(String id) => ApiService.get('locations/$id');