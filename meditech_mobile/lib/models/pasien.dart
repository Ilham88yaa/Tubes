import 'medical_record.dart';

class Pasien {
  final String? id;
  final String nama;
  final String? email;
  final int? umur;
  final List<MedicalRecord> medicalRecords; // ✅ strongly typed list

  Pasien({
    this.id,
    required this.nama,
    this.email,
    required this.umur,
    this.medicalRecords = const [], // ✅ default empty list
  });

  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      id: json['_id'] ?? json['id'],
      nama: json['nama'] ?? '',
      email: json['email'],
      umur:
          json['umur'] is int
              ? json['umur']
              : int.tryParse(json['umur'].toString()),
      medicalRecords:
          (json['medicalRecords'] as List<dynamic>?)
              ?.map((record) => MedicalRecord.fromJson(record))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'umur': umur,
      'medicalRecords': medicalRecords.map((e) => e.toJson()).toList(),
    };
  }
}
