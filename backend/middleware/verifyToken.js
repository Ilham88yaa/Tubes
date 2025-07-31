const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) return res.status(401).json({ message: 'Token tidak ditemukan' });

  try {
    const decoded = jwt.verify(token, 'SECRET_KEY'); // ganti SECRET_KEY sesuai env
    req.user = decoded; // Tambahkan data user ke req
    next();
  } catch (err) {
    return res.status(403).json({ message: 'Token tidak valid' });
  }
};
