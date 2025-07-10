const Pasien = require('../models/pasien');

exports.getAllPasien = async (req, res) => {
  try {
    const semuaPasien = await Pasien.find();
    res.json(semuaPasien);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.createPasien = async (req, res) => {
  try {
    const newPasien = new Pasien(req.body);
    await newPasien.save();
    res.status(201).json(newPasien);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.updatePasien = async (req, res) => {
  try {
    const pasien = await Pasien.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(pasien);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

exports.deletePasien = async (req, res) => {
  try {
    await Pasien.findByIdAndDelete(req.params.id);
    res.json({ message: 'Pasien berhasil dihapus' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
