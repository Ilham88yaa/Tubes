const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/booking_controller');

router.post('/', bookingController.createBooking);
router.get('/', bookingController.getAllBookings); // untuk melihat semua booking

module.exports = router;
