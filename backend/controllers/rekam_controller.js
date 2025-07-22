const RekamMedis = require('../models/rekam_medis');

exports.createRekamMedis = async (req, res) => {
  try {
    const rekam = new RekamMedis(req.body);
    await rekam.save();
    res.status(201).json(rekam);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

exports.getAllRekamMedis = async (req, res) => {
  try {
    const rekam = await RekamMedis.find();
    res.json(rekam);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.getByPasienId = async (req, res) => {
  try {
    const records = await RekamMedis.find({ pasienId: req.params.id });
    res.json(records);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
