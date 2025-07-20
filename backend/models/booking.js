const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
  nama: {
    type: String,
    required: true,
  },
  dokter: {
    type: String,
    required: true,
  },
  tanggal: {
    type: String,
    required: true,
  },
  jam: {
    type: String,
    required: true,
  }
});

module.exports = mongoose.model('Booking', bookingSchema);
