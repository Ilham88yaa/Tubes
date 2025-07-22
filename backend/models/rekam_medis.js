const mongoose = require('mongoose');

const rekamMedisSchema = new mongoose.Schema({
  nama_pasien: {
    type: String,
    required: true
  },
  keluhan: {
    type: String,
    required: true
  },
  diagnosa: {
    type: String,
    required: true
  },
  tindakan: {
    type: String,
    required: true
  },
  tanggal: {
    type: String,
    required: true
  }
});

module.exports = mongoose.model('RekamMedis', rekamMedisSchema);
