const express = require('express');
const router = express.Router();
const rekamController = require('../controllers/rekam_controller');

// [POST] Tambah rekam medis
router.post('/', rekamController.createRekamMedis);

// [GET] Ambil semua rekam medis
router.get('/', rekamController.getAllRekamMedis);
router.get('/pasien/:id', rekamController.getByPasienId);

module.exports = router;
