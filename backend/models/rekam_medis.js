const mongoose = require('mongoose');

const rekamMedisSchema = new mongoose.Schema({
  pasienId: { // ✅ TAMBAHKAN FIELD INI
    type: mongoose.Schema.Types.ObjectId, // Tipe ObjectId untuk referensi ke user
    ref: 'User', // Menunjukkan bahwa ini merujuk ke model 'User'
    required: true // Wajib diisi
  },
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
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true // ✅ Opsional, bagus untuk createdAt dan updatedAt otomatis
});

module.exports = mongoose.model('RekamMedis', rekamMedisSchema);