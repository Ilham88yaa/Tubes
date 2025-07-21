// lib/screens/jadwal_konsultasi_screen.dart

import 'package:flutter/material.dart';
import '../models/konsultasi_model.dart';
import '../services/konsultasi_service.dart';
import 'jadwal_konsultasi_card.dart';

class JadwalKonsultasiScreen extends StatefulWidget {
  const JadwalKonsultasiScreen({super.key});

  @override
  State<JadwalKonsultasiScreen> createState() => _JadwalKonsultasiScreenState();
}

class _JadwalKonsultasiScreenState extends State<JadwalKonsultasiScreen> {
  late Future<List<Konsultasi>> _futureKonsultasi;

  @override
  void initState() {
    super.initState();
    _futureKonsultasi = KonsultasiService.fetchKonsultasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Konsultasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<List<Konsultasi>>(
        future: _futureKonsultasi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada jadwal konsultasi.'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return JadwalKonsultasiCard(konsultasi: data[index]);
            },
          );
        },
      ),
    );
  }
}
