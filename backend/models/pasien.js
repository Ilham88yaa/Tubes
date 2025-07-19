// models/pasien.js

const mongoose = require('mongoose');

const pasienSchema = new mongoose.Schema({
  nama: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true, // agar tidak ada email ganda
  },
  password: {
    type: String,
    required: true,
  },
  umur: {
    type: Number,
    required: true,
  },
  appointments: [
    {
      date: String,
      doctor: String,
    }
  ],
  medicalRecords: [
    {
      title: String,
      description: String,
      date: String,
    }
  ]
});

module.exports = mongoose.model('Pasien', pasienSchema);
