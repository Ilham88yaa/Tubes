const Pasien = require('../models/pasien');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

// REGISTER
exports.register = async (req, res) => {
  try {
    const { nama, email, password, umur } = req.body;
    console.log('[REGISTER] Data diterima:', { nama, email, umur });

    // Cek jika email sudah terdaftar
    const existing = await Pasien.findOne({ email });
    if (existing) {
      console.warn('[REGISTER] Email sudah terdaftar:', email);
      return res.status(400).json({ error: 'Email sudah terdaftar' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Simpan data pasien
    const newPasien = new Pasien({
      nama,
      email,
      password: hashedPassword,
      umur,
    });

    await newPasien.save();
    console.log('[REGISTER] Pasien berhasil disimpan:', newPasien);

    return res.status(201).json({ message: 'Registrasi berhasil' });
  } catch (err) {
    console.error('[REGISTER] Error saat registrasi:', err.message);
    return res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
};

// LOGIN
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log('[LOGIN] Data masuk:', { email });

    // Cari pasien berdasarkan email
    const pasien = await Pasien.findOne({ email });
    if (!pasien) {
      console.warn('[LOGIN] Pasien tidak ditemukan:', email);
      return res.status(404).json({ error: 'Pasien tidak ditemukan' });
    }

    // Cek password
    const isMatch = await bcrypt.compare(password, pasien.password);
    if (!isMatch) {
      console.warn('[LOGIN] Password salah untuk:', email);
      return res.status(400).json({ error: 'Password salah' });
    }

    // Buat token JWT
    const token = jwt.sign({ id: pasien._id }, 'SECRET_KEY', {
      expiresIn: '1d',
    });

    console.log('[LOGIN] Login sukses untuk:', pasien._id);

    // Kirim token dan data pasien dalam struktur yang sesuai untuk Flutter
    return res.status(200).json({
      success: true,
      token,
      user: {
        _id: pasien._id,
        nama: pasien.nama,
        email: pasien.email,
        umur: pasien.umur,
      },
    });
  } catch (err) {
    console.error('[LOGIN] Error saat login:', err.message);
    return res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
};
