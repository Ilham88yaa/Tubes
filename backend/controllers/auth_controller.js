const User = require('../models/user');
const jwt = require('jsonwebtoken');

exports.register = async (req, res) => {
  try {
    const { nama, email, password, umur } = req.body;
    console.log('[REGISTER] Data diterima:', { nama, email, umur });

    const existing = await User.findOne({ email });
    if (existing) {
      console.warn('[REGISTER] Email sudah terdaftar:', email);
      return res.status(400).json({ error: 'Email sudah terdaftar' });
    }

    const newUser = new User({ nama, email, password, umur });
    await newUser.save();
    console.log('[REGISTER] User berhasil disimpan:', newUser);

    return res.status(201).json({ message: 'Registrasi berhasil' });
  } catch (err) {
    console.error('[REGISTER] Error saat registrasi:', err.message);
    return res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log('[LOGIN] Data masuk:', { email, password });

    const user = await User.findOne({ email });
    if (!user) {
      console.warn('[LOGIN] User tidak ditemukan:', email);
      return res.status(404).json({ error: 'User tidak ditemukan' });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      console.warn('[LOGIN] Password salah untuk:', email);
      return res.status(400).json({ error: 'Password salah' });
    }

    const token = jwt.sign({ id: user._id }, 'SECRET_KEY', { expiresIn: '1d' });
    console.log('[LOGIN] Login sukses untuk:', user._id);

    return res.json({ token, user });
  } catch (err) {
    console.error('[LOGIN] Error saat login:', err.message);
    return res.status(500).json({ error: 'Terjadi kesalahan server' });
  }
};
