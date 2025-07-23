// routes/adminRoutes.js
const express = require('express');
const router = express.Router();
const Admin = require('../models/admin');
const jwt = require('jsonwebtoken');

// Register Admin
router.post('/register', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password)
    return res.status(400).json({ message: 'Username dan password wajib diisi' });

  const existing = await Admin.findOne({ username });
  if (existing)
    return res.status(400).json({ message: 'Username sudah digunakan' });

  const admin = new Admin({ username, password });
  await admin.save();

  res.json({ success: true, message: 'Admin berhasil didaftarkan' });
});

// Login Admin
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  const admin = await Admin.findOne({ username });
  if (!admin || !(await admin.matchPassword(password)))
    return res.status(401).json({ message: 'Username atau password salah' });

  const token = jwt.sign({ id: admin._id, role: 'admin' }, 'SECRET_KEY', {
    expiresIn: '1d',
  });

  res.json({
    success: true,
    token,
    username: admin.username,
  });
});

module.exports = router;
