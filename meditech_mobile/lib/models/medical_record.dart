// C:\TUGAS ULBI SEMESTER 4\Tubes\meditech_mobile\lib\models\medical_record.dart

class MedicalRecord {
  final String id;
  final String pasienId;
  final String namaPasien; // ✅ Tambahkan field ini
  final DateTime tanggal;
  final String keluhan;
  final String diagnosa;
  final String tindakan;
  final String dokter;
  // Tambahkan field lain yang ada di database Anda jika perlu (misal createdAt, updatedAt jika ditampilkan)

  MedicalRecord({
    required this.id,
    required this.pasienId,
    required this.namaPasien, // ✅ Tambahkan ke konstruktor
    required this.tanggal,
    required this.keluhan,
    required this.diagnosa,
    required this.tindakan,
    required this.dokter,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['_id'] as String,
      pasienId: json['pasienId'] as String,
      // ✅ Gunakan ?? '' untuk String agar aman dari null, dan parse nama_pasien
      namaPasien: json['nama_pasien'] as String? ?? '', // Ambil dari 'nama_pasien' di JSON
      // ✅ Pastikan parsing tanggal aman. Jika null, fallback ke tanggal default (misal DateTime.now())
      tanggal: DateTime.tryParse(json['tanggal'] as String? ?? '') ?? DateTime.now(),
      keluhan: json['keluhan'] as String? ?? '',
      diagnosa: json['diagnosa'] as String? ?? '',
      tindakan: json['tindakan'] as String? ?? '',
      dokter: json['dokter'] as String? ?? '',
    );
  }

  // Opsional: untuk debugging atau jika Anda perlu mengirim objek ini kembali ke backend
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pasienId': pasienId,
      'nama_pasien': namaPasien, // ✅ Tambahkan ke toJson
      'tanggal': tanggal.toIso8601String(),
      'keluhan': keluhan,
      'diagnosa': diagnosa,
      'tindakan': tindakan,
      'dokter': dokter,
    };
  }
}