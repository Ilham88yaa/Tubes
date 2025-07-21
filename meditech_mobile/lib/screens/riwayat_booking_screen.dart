import 'package:flutter/material.dart';
import '../models/booking.dart';

class RiwayatBookingScreen extends StatelessWidget {
  final List<Booking> bookingList;

  const RiwayatBookingScreen({super.key, required this.bookingList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
        backgroundColor: Colors.deepPurple[300],
      ),
      body:
          bookingList.isEmpty
              ? const Center(child: Text('Belum ada riwayat booking.'))
              : ListView.builder(
                itemCount: bookingList.length,
                itemBuilder: (context, index) {
                  final booking = bookingList[index];
                  return Card(
                    color: Colors.deepPurple[50],
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Dokter: ${booking.dokter}'),
                          Text('Jadwal: ${booking.tanggal} jam ${booking.jam}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
