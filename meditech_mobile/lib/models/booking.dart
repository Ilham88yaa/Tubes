class Booking {
  final String nama;
  final String dokter;
  final String tanggal;
  final String jam;

  Booking({
    required this.nama,
    required this.dokter,
    required this.tanggal,
    required this.jam,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    nama: json['nama'],
    dokter: json['dokter'],
    tanggal: json['tanggal'],
    jam: json['jam'],
  );

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'dokter': dokter,
    'tanggal': tanggal,
    'jam': jam,
  };
}
