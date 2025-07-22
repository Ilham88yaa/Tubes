const mongoose = require('mongoose');

const konsultasiSchema = new mongoose.Schema({
  namaPasien: String,
  namaDokter: String,
  tanggal: String,
  jam: String,
  keluhan: String,
});

module.exports = mongoose.model('Konsultasi', konsultasiSchema);
