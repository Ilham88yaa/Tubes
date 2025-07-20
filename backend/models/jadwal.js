const mongoose = require('mongoose');

const jadwalSchema = new mongoose.Schema({
  dokter: String,
  spesialis: String,  // ubah dari 'nama'
  tanggal: String,
  waktu: String       // ubah dari 'jam'
});

module.exports = mongoose.model('Jadwal', jadwalSchema);
