const express = require('express');
const router = express.Router();
const Admin = require('../models/admin');
const jwt = require('jsonwebtoken');

// ✅ REGISTER ADMIN
router.post('/register', async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ message: 'Username dan password wajib diisi' });
    }

    const existingAdmin = await Admin.findOne({ username });
    if (existingAdmin) {
      return res.status(400).json({ message: 'Username sudah digunakan' });
    }

    const admin = new Admin({ username, password });
    await admin.save();

    res.json({ success: true, message: 'Admin berhasil didaftarkan' });
  } catch (error) {
    console.error('❌ Error register admin:', error);
    res.status(500).json({ message: 'Terjadi kesalahan saat registrasi' });
  }
});

// ✅ LOGIN ADMIN
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    const admin = await Admin.findOne({ username });

    if (!admin) {
      console.log('❌ Admin tidak ditemukan:', username);
      return res.status(401).json({ message: 'Username atau password salah' });
    }

    const isMatch = await admin.matchPassword(password);
    if (!isMatch) {
      console.log('❌ Password tidak cocok untuk:', username);
      return res.status(401).json({ message: 'Username atau password salah' });
    }

    const token = jwt.sign(
      { id: admin._id, role: 'admin' },
      'SECRET_KEY', // Ganti dengan process.env.JWT_SECRET di production
      { expiresIn: '1d' }
    );

    console.log('✅ Login berhasil untuk:', username);

    res.json({
      success: true,
      token,
      username: admin.username,
    });
  } catch (error) {
    console.error('❌ Error login admin:', error);
    res.status(500).json({ message: 'Terjadi kesalahan saat login' });
  }
});

module.exports = router;
