// lib/screens/jadwal_konsultasi_card.dart

import 'package:flutter/material.dart';
import '../models/konsultasi_model.dart';

class JadwalKonsultasiCard extends StatelessWidget {
  final Konsultasi konsultasi;

  const JadwalKonsultasiCard({super.key, required this.konsultasi});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              konsultasi.dokter,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("Spesialis: ${konsultasi.spesialis}"),
            Text("Tanggal: ${konsultasi.tanggal}"),
            Text("Waktu: ${konsultasi.waktu}"),
          ],
        ),
      ),
    );
  }
}
