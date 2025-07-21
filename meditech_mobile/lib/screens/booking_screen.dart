import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/booking.dart';
import 'riwayat_booking_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _namaPasienController = TextEditingController();
  String? _selectedDokter;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _dokterList = [
    'Dokter Umum - dr. Indah',
    'Spesialis Kulit - dr. Rina',
    'Spesialis Gigi - drg. Budi',
  ];

  final List<Booking> _bookingHistory = [];

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _konfirmasiBooking() async {
    if (_namaPasienController.text.isEmpty ||
        _selectedDokter == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon lengkapi semua data.')),
      );
      return;
    }

    final String formattedDate =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';
    final String formattedTime = _selectedTime!.format(context);

    final Map<String, dynamic> dataBooking = {
      'nama': _namaPasienController.text,
      'dokter': _selectedDokter,
      'tanggal': formattedDate,
      'jam': formattedTime,
    };

    try {
      final response = await http.post(
        Uri.parse('http://172.16.0.2:5001/booking'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataBooking),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newBooking = Booking(
          nama: _namaPasienController.text,
          dokter: _selectedDokter!,
          tanggal: formattedDate,
          jam: formattedTime,
        );

        setState(() {
          _bookingHistory.add(newBooking);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booking berhasil: ${newBooking.nama} - ${newBooking.dokter} pada ${newBooking.tanggal} jam ${newBooking.jam}',
            ),
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      RiwayatBookingScreen(bookingList: _bookingHistory),
            ),
          );
        });
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ??
            'Gagal mengirim booking ke server.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMsg)));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat mengirim booking.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Konsultasi'),
        backgroundColor: Colors.deepPurple[300],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nama Pasien'),
            TextField(
              controller: _namaPasienController,
              decoration: const InputDecoration(hintText: 'Masukkan nama'),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Dokter'),
            DropdownButtonFormField<String>(
              value: _selectedDokter,
              items:
                  _dokterList
                      .map(
                        (dokter) => DropdownMenuItem(
                          value: dokter,
                          child: Text(dokter),
                        ),
                      )
                      .toList(),
              onChanged: (value) => setState(() => _selectedDokter = value),
              decoration: const InputDecoration(hintText: 'Pilih dokter'),
            ),
            const SizedBox(height: 16),
            const Text('Pilih Tanggal'),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? '-'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: const Text('Pilih Tanggal'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Pilih Jam'),
            Row(
              children: [
                Text(
                  _selectedTime == null ? '-' : _selectedTime!.format(context),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectTime,
                  child: const Text('Pilih Jam'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _konfirmasiBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Konfirmasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
