const express = require('express');
const router = express.Router();
<<<<<<< HEAD
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
=======
const userController = require('../controllers/user_controller');

// ✨ Auth routes
router.post('/register', userController.register);
>>>>>>> 3572669 (integrasi admin)
router.post('/login', userController.login);
router.post('/', userController.createUser);

<<<<<<< HEAD
// =====================
=======
>>>>>>> 3572669 (integrasi admin)
// 📋 GET all users by role
router.get('/pasien', userController.getAllPasien);
router.get('/dokter', userController.getAllDokter);
router.get('/admin', userController.getAllAdmin);

<<<<<<< HEAD
// =====================
// 📝 UPDATE USER
// =====================
router.put('/:id', userController.updateUser);

// =====================
// ❌ DELETE USER
// =====================
=======
// 📝 Update/Delete by ID
router.put('/:id', userController.updateUser);
>>>>>>> 3572669 (integrasi admin)
router.delete('/:id', userController.deleteUser);

module.exports = router;
