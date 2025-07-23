const RekamMedis = require('../models/rekam_medis');
const mongoose = require('mongoose'); // Import mongoose di sini

exports.createRekamMedis = async (req, res) => {
  try {
    const { pasienId, tanggal, keluhan, diagnosa, tindakan, dokter } = req.body;

    // ✅ Tambahkan logging untuk melihat data yang masuk dari frontend
    console.log('[REKAM_CONTROLLER] Menerima data untuk createRekamMedis:', req.body);

    // ✅ Lakukan validasi dasar untuk field wajib
    if (!pasienId || !tanggal || !keluhan || !diagnosa || !tindakan || !dokter) {
      console.warn('[REKAM_CONTROLLER] Validasi gagal: Field wajib tidak lengkap.');
      return res.status(400).json({ message: 'Semua field wajib (pasienId, tanggal, keluhan, diagnosa, tindakan, dokter) harus diisi.' });
    }

    // ✅ Validasi format pasienId (harus valid ObjectId jika di DB tipenya ObjectId)
    if (!mongoose.Types.ObjectId.isValid(pasienId)) {
        console.warn('[REKAM_CONTROLLER] Pasien ID tidak valid format ObjectId:', pasienId);
        return res.status(400).json({ message: 'ID pasien tidak valid.' });
    }

    // ✅ Konversi string tanggal dari frontend menjadi objek Date
    // Asumsi frontend mengirim tanggal dalam format ISO 8601 string (misal: "2025-07-22T10:30:00.000Z")
    let parsedTanggal;
    try {
      parsedTanggal = new Date(tanggal);
      if (isNaN(parsedTanggal.getTime())) { // Periksa apakah parsing menghasilkan tanggal yang valid
          throw new Error('Invalid date value');
      }
    } catch (dateErr) {
      console.warn('[REKAM_CONTROLLER] Gagal memparsing tanggal:', tanggal, dateErr.message);
      return res.status(400).json({ message: 'Format tanggal tidak valid.' });
    }

    // Buat instansi RekamMedis baru
    const rekam = new RekamMedis({
        pasienId: new mongoose.Types.ObjectId(pasienId), // Gunakan ObjectId yang sudah divalidasi
        tanggal: parsedTanggal, // Gunakan objek Date yang sudah diparse
        keluhan,
        diagnosa,
        tindakan,
        dokter
        // createdAt dan updatedAt akan dihandle oleh Mongoose jika diatur di skema
    });

    await rekam.save(); // Simpan dokumen ke MongoDB
    console.log('[REKAM_CONTROLLER] Rekam medis berhasil disimpan:', rekam);
    // ✅ Kirim respons sukses yang lebih informatif ke frontend
    res.status(201).json({ message: 'Rekam medis berhasil ditambahkan', record: rekam });

  } catch (err) {
    console.error('[REKAM_CONTROLLER] ERROR createRekamMedis:', err.message);
    console.error('[REKAM_CONTROLLER] ERROR Stack Trace:', err.stack); // Penting untuk debugging

    // ✅ Kirim pesan error yang lebih informatif ke frontend
    res.status(400).json({ message: err.message || 'Terjadi kesalahan saat menambahkan rekam medis.' });
  }
};

exports.getAllRekamMedis = async (req, res) => {
  try {
    const rekam = await RekamMedis.find();
    console.log('[REKAM_CONTROLLER] getAllRekamMedis: Ditemukan', rekam.length, 'rekam medis.');
    res.json(rekam);
  } catch (err) {
    console.error('[REKAM_CONTROLLER] ERROR getAllRekamMedis:', err.message);
    res.status(500).json({ message: err.message });
  }
};

exports.getByPasienId = async (req, res) => {
    try {
        const pasienIdFromParams = req.params.id;

        console.log(`[REKAM_CONTROLLER] Menerima permintaan getByPasienId untuk ID: ${pasienIdFromParams}`);

        if (!mongoose.Types.ObjectId.isValid(pasienIdFromParams)) {
            console.warn('[REKAM_CONTROLLER] ID pasien tidak valid format ObjectId:', pasienIdFromParams);
            return res.status(400).json({ message: 'ID pasien tidak valid.' });
        }
        const queryObjectId = new mongoose.Types.ObjectId(pasienIdFromParams);

        const records = await RekamMedis.find({ pasienId: queryObjectId });

        console.log(`[REKAM_CONTROLLER] Hasil query untuk ${pasienIdFromParams}: ${records.length} records ditemukan.`);
        console.log(`[REKAM_CONTROLLER] Data yang akan dikirim:`, records);

        res.json(records);
    } catch (err) {
        console.error('[REKAM_CONTROLLER] ERROR di getByPasienId:', err.message);
        console.error('[REKAM_CONTROLLER] ERROR Stack Trace:', err.stack);
        res.status(500).json({ message: err.message || 'Terjadi kesalahan server saat mengambil rekam medis' });
    }
};