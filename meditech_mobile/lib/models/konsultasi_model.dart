// lib/models/konsultasi_model.dart

class Konsultasi {
  final String dokter;
  final String spesialis;
  final String tanggal;
  final String waktu;

  Konsultasi({
    required this.dokter,
    required this.spesialis,
    required this.tanggal,
    required this.waktu,
  });

  factory Konsultasi.fromJson(Map<String, dynamic> json) {
    return Konsultasi(
      dokter: json['dokter'] ?? '',
      spesialis: json['spesialis'] ?? '',
      tanggal: json['tanggal'] ?? '',
      waktu: json['waktu'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dokter': dokter,
      'spesialis': spesialis,
      'tanggal': tanggal,
      'waktu': waktu,
    };
  }
}
