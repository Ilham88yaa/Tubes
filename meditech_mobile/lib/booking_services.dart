import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/booking.dart';

class BookingService {
  static const String _baseUrl = 'http://172.16.0.2:5001/booking';

  static Future<bool> createBooking(Booking booking) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nama': booking.nama,
          'dokter': booking.dokter,
          'tanggal': booking.tanggal,
          'jam': booking.jam,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Gagal booking: $e');
      return false;
    }
  }
}
