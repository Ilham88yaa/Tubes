const Booking = require('../models/booking');

exports.createBooking = async (req, res) => {
  try {
    const { nama, dokter, tanggal, jam } = req.body;

    const newBooking = new Booking({ nama, dokter, tanggal, jam });
    await newBooking.save();

    console.log('[BOOKING] Booking berhasil disimpan:', newBooking);
    res.status(201).json({ message: 'Booking berhasil disimpan', data: newBooking });
  } catch (error) {
    console.error('[BOOKING] Error:', error.message);
    res.status(500).json({ error: 'Terjadi kesalahan saat menyimpan booking' });
  }
};

exports.getAllBookings = async (req, res) => {
  try {
    const bookings = await Booking.find();
    res.status(200).json({ data: bookings });
  } catch (error) {
    res.status(500).json({ error: 'Gagal mengambil data booking' });
  }
};
