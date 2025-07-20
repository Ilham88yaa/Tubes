const Jadwal = require('../models/jadwal');

// [POST] /jadwal
exports.createJadwal = async (req, res) => {
  try {
    const { dokter, spesialis, tanggal, waktu } = req.body; // Sesuaikan nama field

    const newJadwal = new Jadwal({ dokter, spesialis, tanggal, waktu });
    await newJadwal.save();

    console.log('[JADWAL] Jadwal berhasil disimpan:', newJadwal);
    res.status(201).json(newJadwal);
  } catch (error) {
    console.error('❌ Gagal menyimpan jadwal:', error);
    res.status(500).json({ message: 'Gagal menyimpan jadwal' });
  }
};

// [GET] /jadwal
exports.getAllJadwal = async (req, res) => {
  try {
    const jadwalList = await Jadwal.find().sort({ tanggal: 1 });
    res.status(200).json(jadwalList);
  } catch (error) {
    console.error('❌ Gagal mengambil jadwal:', error);
    res.status(500).json({ message: 'Gagal mengambil jadwal' });
  }
};
