import 'models/pasien.dart';

final Map<String, dynamic> pasienJson = {
  "id": "1",
  "nama": "Ilham",
  "umur": 21,
  "medicalRecords": [
    {
      "title": "Pemeriksaan Flu",
      "description": "Demam dan pilek ringan",
      "date": "2025-07-03",
    },
    {
      "title": "Pemeriksaan Gigi",
      "description": "Sakit gigi dan diberi antibiotik",
      "date": "2025-07-04",
    },
  ],
  "appointments": [],
};

final Pasien dummyPasien = Pasien.fromJson(pasienJson);
