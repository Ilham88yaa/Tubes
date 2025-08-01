import '../models/konsultasi_model.dart';

class KonsultasiService {
  static Future<List<Konsultasi>> fetchKonsultasi() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi delay
    return [
      Konsultasi(
        namaPasien: 'Hilal',
        namaDokter: 'dr. Rina',
        tanggal: '2025-07-26',
        jam: '14:30',
        keluhan: 'Ruam Merah di Kulit',
      ),
      Konsultasi(
        namaPasien: 'Hikmaldi',
        namaDokter: 'drg. Budi',
        tanggal: '2025-07-27',
        jam: '09:00',
        keluhan: 'Nyeri Gigi',
      ),
    ];
  }
}
