import 'package:flutter/material.dart';
import '../models/konsultasi_model.dart';

class RiwayatKonsultasiScreen extends StatelessWidget {
  final List<Konsultasi> konsultasiList;

  const RiwayatKonsultasiScreen({Key? key, required this.konsultasiList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Riwayat Konsultasi',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue[400],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: konsultasiList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat konsultasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jadwal konsultasi Anda akan muncul di sini',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: konsultasiList.length,
              itemBuilder: (context, index) {
                final konsultasi = konsultasiList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule, color: Colors.blue[400]),
                            const SizedBox(width: 8),
                            Text(
                              konsultasi.namaPasien,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.medical_services, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('Dr. ${konsultasi.namaDokter}', style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(konsultasi.tanggal, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 16),
                            Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(konsultasi.jam, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.note_alt, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(konsultasi.keluhan, style: const TextStyle(fontSize: 13, color: Colors.black54))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
