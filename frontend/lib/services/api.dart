import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _baseUrl = 'http://localhost:3000';

  static final _client = http.Client();
  static String? _accessToken; // เก็บ token ที่ได้จาก login

  // Set token (เรียกหลัง login สำเร็จ)
  static void setAccessToken(String token) {
    _accessToken = token;
  }

  // Clear token (เรียกตอน logout)
  static void clearAccessToken() {
    _accessToken = null;
  }

  // GET method
  static Future<dynamic> get(String endpoint) async {
    try {
      final headers = {
        'Accept': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

      final response = await _client.get(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST method
  static Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

      final response = await _client.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: headers,
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
Future<dynamic> register(Map<String, dynamic> userData) =>
    ApiService.post('register', userData);

Future<dynamic> login(Map<String, dynamic> credentials) async {
  final result = await ApiService.post('login', credentials);

  if (result != null && result['accessToken'] != null) {
    ApiService.setAccessToken(result['accessToken']);
    print('AccessToken: ${result['accessToken']}'); // เช็ค token
  } else {
    print('No access token received');
  }

  return result;
}

Future<dynamic> logout() async {
  final result = await ApiService.post('logout', {});
  ApiService.clearAccessToken(); // ล้าง token ตอน logout
  return result;
}
