const User = require('../models/user');
const jwt = require('jsonwebtoken');

// 🔐 REGISTER
exports.register = async (req, res) => {
  try {
    const { nama, email, password, umur, tanggal_lahir, alamat, no_hp, role } = req.body;

    if (!nama || !email || !password) {
      return res.status(400).json({ error: 'Nama, email, dan password wajib diisi' });
    }

    const existing = await User.findOne({ email });
    if (existing) {
      return res.status(400).json({ error: 'Email sudah terdaftar' });
    }

    const newUser = new User({
      nama, email, password, umur, tanggal_lahir, alamat, no_hp, role: role || 'pasien',
    });

    await newUser.save();

    res.status(201).json({ message: 'Registrasi berhasil' });
  } catch (err) {
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
};

// 🔑 LOGIN
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ error: 'User tidak ditemukan' });

    const isMatch = await user.comparePassword(password);
    if (!isMatch) return res.status(400).json({ error: 'Password salah' });

    const token = jwt.sign({ id: user._id, role: user.role }, 'SECRET_KEY', { expiresIn: '1d' });

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
    res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
};

// 📋 GET SEMUA PASIEN
exports.getAllPasien = async (req, res) => {
  try {
    const pasienList = await User.find({ role: 'pasien' });
    res.json(pasienList);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// 📝 UPDATE USER
exports.updateUser = async (req, res) => {
  try {
    const updated = await User.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!updated) return res.status(404).json({ message: 'User tidak ditemukan' });
    res.json(updated);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// ❌ DELETE USER
exports.deleteUser = async (req, res) => {
  try {
    const deleted = await User.findByIdAndDelete(req.params.id);
    if (!deleted) return res.status(404).json({ message: 'User tidak ditemukan' });
    res.json({ message: 'User berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// 🧑‍⚕️ GET DOKTER
exports.getAllDokter = async (req, res) => {
  try {
    const dokter = await User.find({ role: 'dokter' }).select('-password');
    res.json(dokter);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

// 👨‍💼 GET ADMIN
exports.getAllAdmin = async (req, res) => {
  try {
    const admin = await User.find({ role: 'admin' }).select('-password');
    res.json(admin);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
