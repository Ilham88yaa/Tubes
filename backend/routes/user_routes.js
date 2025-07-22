const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller'); // ✅ konsisten import controller

// =====================
// 🌐 TEST ROUTE
// =====================
router.get('/test', (req, res) => {
  res.json({ success: true, message: 'Route /api/user/test aktif' });
});

// =====================
// 🔐 REGISTER
// =====================
router.post('/register', userController.register);

// =====================
// 🔑 LOGIN
// =====================
router.post('/login', userController.login);

// =====================
// 📋 GET all users by role
router.get('/pasien', userController.getAllPasien);
router.get('/dokter', userController.getAllDokter);
router.get('/admin', userController.getAllAdmin);

// =====================
// 📝 UPDATE USER
// =====================
router.put('/:id', userController.updateUser);

// =====================
// ❌ DELETE USER
// =====================
router.delete('/:id', userController.deleteUser);

module.exports = router;
