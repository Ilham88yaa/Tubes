const express = require('express');
const router = express.Router();
const Konsultasi = require('../models/konsultasi');

// GET semua konsultasi
router.get('/', async (req, res) => {
  try {
    const data = await Konsultasi.find();
    res.json(data);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST tambah konsultasi
router.post('/', async (req, res) => {
  try {
    const { namaPasien, namaDokter, tanggal, jam, keluhan } = req.body;
    const konsultasiBaru = new Konsultasi({
      namaPasien, namaDokter, tanggal, jam, keluhan
    });
    await konsultasiBaru.save();
    res.status(201).json(konsultasiBaru);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
