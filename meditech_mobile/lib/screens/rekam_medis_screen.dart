import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pasien.dart';
import '../models/medical_record.dart';
import '../services/rekam_medis_service.dart';

class RekamMedisScreen extends StatefulWidget {
  final Pasien currentPasien;

  const RekamMedisScreen({super.key, required this.currentPasien});

  @override
  State<RekamMedisScreen> createState() => _RekamMedisScreenState();
}

class _RekamMedisScreenState extends State<RekamMedisScreen> {
  List<MedicalRecord> records = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    try {
      final data = await RekamMedisService.fetchRekamMedisByPasienId(
        widget.currentPasien.id ?? '',
      );
      setState(() {
        records = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekam Medis')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(record.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record.description),
                          const SizedBox(height: 4),
                          Text(
                            'Tanggal: ${DateFormat('dd-MM-yyyy').format(record.date)}',
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
