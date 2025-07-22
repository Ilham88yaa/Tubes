const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller'); // ✅ konsisten pakai 1

// Cek route aktif
router.get('/test', (req, res) => {
  res.json({ success: true, message: 'Route /api/user/test aktif' });
});

// Register user
router.post('/register', userController.register);

// Login user
router.post('/login', userController.login);

// Get semua pasien
router.get('/pasien', userController.getAllPasien);

// Update user
router.put('/:id', userController.updateUser); // ✅ pastikan controller ini ada

// Hapus user
router.delete('/:id', userController.deleteUser); // ✅ pastikan controller ini ada

module.exports = router;
