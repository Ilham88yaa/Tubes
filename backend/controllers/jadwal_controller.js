const Jadwal = require('../models/jadwal');

// [POST] /jadwal - Buat jadwal baru
exports.createJadwal = async (req, res) => {
  try {
    const {
      nama = '',           // opsional (dari versi 2)
      dokter,
      spesialis = '',      // opsional (dari versi 1)
      tanggal,
      waktu,               // versi 1
      jam                  // versi 2 (opsional)
    } = req.body;

    // Gunakan waktu || jam, tergantung yang dikirim
    const finalWaktu = waktu || jam || '';

    const newJadwal = new Jadwal({
      nama,
      dokter,
      spesialis,
      tanggal,
      waktu: finalWaktu
    });

    await newJadwal.save();

    console.log('[JADWAL] Jadwal berhasil disimpan:', newJadwal);
    res.status(201).json(newJadwal);
  } catch (error) {
    console.error('❌ Gagal menyimpan jadwal:', error);
    res.status(500).json({ message: 'Gagal menyimpan jadwal' });
  }
};

// [GET] /jadwal - Ambil semua jadwal
exports.getAllJadwal = async (req, res) => {
  try {
    const jadwalList = await Jadwal.find().sort({ tanggal: 1 });
    res.status(200).json(jadwalList);
  } catch (error) {
    console.error('❌ Gagal mengambil jadwal:', error);
    res.status(500).json({ message: 'Gagal mengambil jadwal' });
  }
};
