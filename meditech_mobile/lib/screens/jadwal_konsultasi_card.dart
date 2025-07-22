import 'package:flutter/material.dart';
import '../models/konsultasi_model.dart';

class JadwalKonsultasiCard extends StatelessWidget {
  final Konsultasi konsultasi;

  const JadwalKonsultasiCard({super.key, required this.konsultasi});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pasien: ${konsultasi.namaPasien}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Dokter: ${konsultasi.namaDokter}"),
            Text("Tanggal: ${konsultasi.tanggal}"),
            Text("Jam: ${konsultasi.jam}"),
            const SizedBox(height: 8),
            Text("Keluhan: ${konsultasi.keluhan}"),
          ],
        ),
      ),
    );
  }
}
