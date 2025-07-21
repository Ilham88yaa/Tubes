// lib/services/konsultasi_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/konsultasi_model.dart';

class KonsultasiService {
  static const String baseUrl = 'http://172.16.0.2:5001/api/konsultasi';

  static Future<List<Konsultasi>> fetchKonsultasi() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((json) => Konsultasi.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data konsultasi');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
