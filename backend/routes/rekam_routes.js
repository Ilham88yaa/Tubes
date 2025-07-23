const express = require('express');
const router = express.Router();
const rekamController = require('../controllers/rekam_controller');

// [POST] Tambah rekam medis
router.post('/', rekamController.createRekamMedis);

// [GET] Ambil semua rekam medis (untuk admin atau keperluan lain)
router.get('/', rekamController.getAllRekamMedis);

// ✅ KOREKSI INI: Ubah '/pasien/:id' menjadi '/user/:id'
router.get('/user/:id', rekamController.getByPasienId); // Pastikan ini sesuai dengan panggilan Flutter

module.exports = router;