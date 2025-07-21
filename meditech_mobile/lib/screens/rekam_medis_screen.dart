import 'package:flutter/material.dart';
import '../models/pasien.dart';

class RekamMedisScreen extends StatelessWidget {
  final Pasien currentPasien;

  const RekamMedisScreen({super.key, required this.currentPasien});

  @override
  Widget build(BuildContext context) {
    final records = currentPasien.medicalRecords;

    return Scaffold(
      appBar: AppBar(title: const Text('Rekam Medis')),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(record.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(record.description),
                  const SizedBox(height: 4),
                  Text(
                    'Tanggal: ${record.date}',
                    style: const TextStyle(fontSize: 12),
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
