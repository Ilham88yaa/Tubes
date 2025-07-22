const User = require('../models/user');
const jwt = require('jsonwebtoken');

// =====================
// 🔐 REGISTER
// =====================
exports.register = async (req, res) => {
  try {
    const { nama, email, password, umur, tanggal_lahir, alamat, no_hp, role } = req.body;
    console.log('[REGISTER] Data masuk:', { nama, email, role });

    // Validasi field wajib
    if (!nama || !email || !password) {
      return res.status(400).json({ error: 'Nama, email, dan password wajib diisi' });
    }

    // Cek email
    const existing = await User.findOne({ email });
    if (existing) {
      console.warn('[REGISTER] Email sudah terdaftar:', email);
      return res.status(400).json({ error: 'Email sudah terdaftar' });
    }

    // Buat user baru
    const newUser = new User({
      nama,
      email,
      password,
      umur,
      tanggal_lahir,
      alamat,
      no_hp,
      role: role || 'pasien', // default: pasien
    });

    await newUser.save();
    console.log('[REGISTER] User berhasil disimpan:', newUser);

    res.status(201).json({ message: 'Registrasi berhasil' });
  } catch (err) {
    console.error('[REGISTER] Gagal registrasi:', err.message);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
};

// =====================
// 🔑 LOGIN
// =====================
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log('[LOGIN] Data masuk:', { email });

    const user = await User.findOne({ email });
    if (!user) {
      console.warn('[LOGIN] User tidak ditemukan:', email);
      return res.status(404).json({ error: 'User tidak ditemukan' });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      console.warn('[LOGIN] Password salah:', email);
      return res.status(400).json({ error: 'Password salah' });
    }

    const token = jwt.sign({ id: user._id, role: user.role }, 'SECRET_KEY', {
      expiresIn: '1d',
    });

    console.log('[LOGIN] Login sukses:', user._id);

    res.status(200).json({
      success: true,
      token,
      user: {
        _id: user._id,
        nama: user.nama,
        email: user.email,
        umur: user.umur,
        role: user.role,
      },
    });
  } catch (err) {
    console.error('[LOGIN] Gagal login:', err.message);
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
};

// =====================
// 📋 GET SEMUA PASIEN
// =====================
exports.getAllPasien = async (req, res) => {
  try {
    const pasienList = await User.find({ role: 'pasien' });
    res.json(pasienList);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// =====================
// 📝 UPDATE USER
// =====================
exports.updateUser = async (req, res) => {
  try {
    const updated = await User.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updated) return res.status(404).json({ message: 'User tidak ditemukan' });
    res.json(updated);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// =====================
// ❌ DELETE USER
// =====================
exports.deleteUser = async (req, res) => {
  try {
    const deleted = await User.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: 'User tidak ditemukan' });
    res.json({ message: 'User berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
