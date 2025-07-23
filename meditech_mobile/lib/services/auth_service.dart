import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const String baseUrl = 'http://localhost:5001/api/user';

  /// Login Pasien
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'user': data['user'], 'token': data['token']};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat login',
        'error': e.toString(),
      };
    }
  }

  /// Register Pasien
  static Future<Map<String, dynamic>> register(
    String nama,
    String email,
    String password,
    int umur,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5001/api/user/register'), // ⬅️ di sini
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
          'umur': umur,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
        };
      } else {
        return {
          'success': false,
          'message': data['error'] ?? data['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      print('Register error: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat registrasi',
        'error': e.toString(),
      };
    }
  }
}
