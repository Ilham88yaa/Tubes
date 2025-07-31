const express = require('express');
const router = express.Router();
const userController = require('../controllers/user_controller');

// =====================
// 🌐 TEST ROUTE
// =====================
router.get('/test', (req, res) => {
  res.json({ success: true, message: 'Route /api/user/test aktif' });
});

// =====================
// 🔐 REGISTER & LOGIN
// =====================
router.post('/register', userController.register);
router.post('/login', userController.login);


// =====================
// 📋 GET USER BY ROLE
// =====================
router.get('/pasien', userController.getAllPasien);
router.get('/dokter', userController.getAllDokter);
router.get('/admin', userController.getAllAdmin);

// =====================
// ✏️ UPDATE & DELETE USER
// =====================
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

module.exports = router;
