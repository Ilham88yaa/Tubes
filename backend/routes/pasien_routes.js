// routes/pasien_routes.js
const express = require('express');
const router = express.Router();
const {
  getAllPasien,
  createPasien,
  updatePasien,
  deletePasien
} = require('../controllers/pasien_controller');

router.get('/', getAllPasien);
router.post('/', createPasien);
router.put('/:id', updatePasien);     // <-- update
router.delete('/:id', deletePasien);  // <-- delete

module.exports = router;
