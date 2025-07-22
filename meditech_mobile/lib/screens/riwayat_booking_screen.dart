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
              ? const Center(
                child: Text(
                  'Belum ada riwayat booking.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Booking: ${bookingList.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: Color(0xFFEDE7F6)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Nama',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Dokter',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Tanggal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Jam',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ...bookingList.map(
                            (booking) => TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(booking.nama),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(booking.dokter),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(booking.tanggal),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(booking.jam),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
