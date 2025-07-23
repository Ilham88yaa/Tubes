const mongoose = require('mongoose');

const rekamMedisSchema = new mongoose.Schema({
  pasienId: { // Field untuk ID pasien
    type: mongoose.Schema.Types.ObjectId, // Tipe ObjectId untuk referensi ke user
    ref: 'User', // Merujuk ke model 'User'
    required: true // Wajib diisi
  },
  nama_pasien: { // Nama pasien (disimpan sebagai string untuk kemudahan display)
    type: String,
    required: true
  },
  keluhan: { // Keluhan pasien
    type: String,
    required: true
  },
  diagnosa: { // Diagnosa dokter
    type: String,
    required: true
  },
  tindakan: { // Tindakan yang diberikan
    type: String,
    required: true
  },
  tanggal: { // Tanggal konsultasi/rekam medis
    type: Date,
    default: Date.now // Default ke tanggal saat ini
  },
  dokter: { // Nama dokter yang menangani
    type: String,
    required: true // Ubah ke false jika nama dokter boleh kosong
  }
}, { // ✅ INI ADALAH OBJEK OPSI KEDUA DARI new mongoose.Schema()
  timestamps: true // Otomatis menambahkan createdAt dan updatedAt
});

module.exports = mongoose.model('RekamMedis', rekamMedisSchema);