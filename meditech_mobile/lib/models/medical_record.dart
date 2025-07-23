// meditech_mobile/lib/models/medical_record.dart
// Tidak perlu import 'package:flutter/material.dart'; atau 'dart:convert'; jika tidak digunakan langsung di file ini

class MedicalRecord {
  final String id;          // Tambahkan ini untuk _id dari MongoDB
  final String pasienId;    // Tambahkan ini
  final DateTime tanggal;   // ✅ Sesuai dengan nama field di MongoDB
  final String keluhan;     // ✅ Sesuai dengan nama field di MongoDB
  final String diagnosa;    // ✅ Sesuai dengan nama field di MongoDB
  final String tindakan;    // ✅ Sesuai dengan nama field di MongoDB
  final String dokter;      // ✅ Sesuai dengan nama field di MongoDB
  // Anda bisa menambahkan createdAt dan updatedAt jika ingin menampilkannya

  MedicalRecord({
    required this.id,
    required this.pasienId,
    required this.tanggal,
    required this.keluhan,
    required this.diagnosa,
    required this.tindakan,
    required this.dokter,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['_id'] as String, // Mengambil _id dari MongoDB
      pasienId: json['pasienId'] as String, // Mengambil pasienId
      tanggal: DateTime.parse(json['tanggal'] as String), // Parsing 'tanggal' dari MongoDB
      keluhan: json['keluhan'] as String, // Mengambil 'keluhan'
      diagnosa: json['diagnosa'] as String, // Mengambil 'diagnosa'
      tindakan: json['tindakan'] as String, // Mengambil 'tindakan'
      dokter: json['dokter'] as String, // Mengambil 'dokter'
    );
  }

  // Opsional: untuk debugging atau jika Anda perlu mengirim objek ini kembali ke backend
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pasienId': pasienId,
      'tanggal': tanggal.toIso8601String(),
      'keluhan': keluhan,
      'diagnosa': diagnosa,
      'tindakan': tindakan,
      'dokter': dokter,
    };
  }
}