import 'dart:convert';
import 'package:http/http.dart' as http;

class PasienService {
  static const String baseUrl = 'http://172.16.0.2:5001/api';

  /// Login pasien (Auth)
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'user': data['user'],
          'message': data['message'] ?? 'Login berhasil',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login gagal'};
      }
    } catch (e) {
      print('Error login: $e');
      return {'success': false, 'message': 'Terjadi kesalahan saat login.'};
    }
  }

  /// Registrasi pasien baru
  static Future<Map<String, dynamic>> registerPasien({
    required String nama,
    required String email,
    required String password,
    required int umur,
  }) async {
    try {
      final now = DateTime.now();
      final tanggalLahir =
          DateTime(now.year - umur, now.month, now.day).toIso8601String();

      final response = await http.post(
        Uri.parse('$baseUrl/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
          'umur': umur, // ❗️Gunakan umur langsung, bukan tanggal lahir
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
        };
      }
    } catch (e) {
      print('Error saat register: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat registrasi.',
      };
    }
  }
}
