// C:\TUGAS ULBI SEMESTER 4\Tubes\meditech_mobile\lib\services\rekam_medis_service.dart
import 'dart:convert'; // Untuk jsonEncode dan jsonDecode
import 'package:http/http.dart' as http; // Untuk HTTP requests
import '../models/medical_record.dart'; // Import model MedicalRecord Anda
// Anda mungkin perlu import package untuk menyimpan token, contoh:
// import 'package:shared_preferences/shared_preferences.dart';

class RekamMedisService {
  static const String baseUrl = 'http://localhost:5001/api/rekam_medis';

  // Helper function untuk mendapatkan token autentikasi (sesuaikan jika digunakan)
  // static Future<String?> _getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token');
  // }

  /// Mengambil daftar rekam medis berdasarkan ID pasien.
  static Future<List<MedicalRecord>> fetchRekamMedisByPasienId(
    String pasienId,
    // String? token, // Aktifkan jika backend memerlukan token
  ) async {
    try {
      // final authToken = token ?? await _getToken(); // Dapatkan token
      // if (authToken == null) {
      //   throw Exception('Token autentikasi tidak ditemukan.');
      // }

      final response = await http.get(
        Uri.parse('$baseUrl/user/$pasienId'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $authToken', // Aktifkan jika backend memerlukan token
        },
      );

      print('[RekamMedisService] Fetch Status Code: ${response.statusCode}');
      print('[RekamMedisService] Fetch Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => MedicalRecord.fromJson(json)).toList();
      } else {
        final errorBody = jsonDecode(response.body);
        print('Error from backend (fetch): ${errorBody['message'] ?? errorBody['error']}');
        throw Exception('Gagal mengambil data rekam medis: ${errorBody['message'] ?? errorBody['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('[RekamMedisService] Error fetching rekam medis: $e');
      throw Exception('Terjadi kesalahan koneksi saat mengambil rekam medis: ${e.toString()}');
    }
  }

  /// Menambah rekam medis baru ke database.
  static Future<Map<String, dynamic>> createRekamMedis({
    required String pasienId,
    required String nama_pasien,
    required DateTime tanggal,
    required String keluhan,
    required String diagnosa,
    required String tindakan,
    required String dokter,
    // String? token, // Aktifkan jika backend memerlukan token
  }) async {
    try {
      // final authToken = token ?? await _getToken(); // Dapatkan token
      // if (authToken == null) {
      //   throw Exception('Token autentikasi tidak ditemukan.');
      // }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer $authToken', // Aktifkan jika backend memerlukan token
        },
        body: jsonEncode({
          'pasienId': pasienId,
          'nama_pasien': nama_pasien,
          'tanggal': tanggal.toIso8601String(),
          'keluhan': keluhan,
          'diagnosa': diagnosa,
          'tindakan': tindakan,
          'dokter': dokter,
        }),
      );

      print('[RekamMedisService] Create Status Code: ${response.statusCode}');
      print('[RekamMedisService] Create Response Body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        return {'success': true, 'message': data['message'] ?? 'Rekam medis berhasil ditambahkan', 'record': data['record']};
      } else {
        return {'success': false, 'message': data['message'] ?? data['error'] ?? 'Gagal menambahkan rekam medis'};
      }
    } catch (e) {
      print('[RekamMedisService] Error creating rekam medis: $e');
      throw Exception('Terjadi kesalahan koneksi saat membuat rekam medis: ${e.toString()}');
    }
  }
}