import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/medical_record.dart';

class RekamMedisService {
  static const String baseUrl = 'http://172.16.0.2:5001/api/rekam';

  static Future<List<MedicalRecord>> fetchRekamMedisByPasienId(
    String pasienId,
  ) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pasien/$pasienId'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => MedicalRecord.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data rekam medis');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
