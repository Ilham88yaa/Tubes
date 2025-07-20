const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const pasienRoutes = require('./routes/pasien_routes');
const authRoutes = require('./routes/auth_routes');
const bookingRoutes = require('./routes/booking_routes');
const jadwalRoutes = require('./routes/jadwal_routes');

dotenv.config();
const app = express();

// ✅ Middleware
app.use(cors({
  origin: '*', // Bisa diatur ke alamat frontend spesifik jika perlu
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type'],
}));
app.use(express.json()); // Untuk parsing JSON dari body request

// ✅ Logging permintaan masuk (untuk debug)
app.use((req, res, next) => {
  console.log(`[${req.method}] ${req.originalUrl}`);
  next();
});

// ✅ Route root (untuk tes)
app.get('/', (req, res) => {
  res.send('🎉 Meditech Backend API is running!');
});

// ✅ API Routes
app.use('/api/pasien', pasienRoutes);
app.use('/api/auth', authRoutes);
app.use('/booking', bookingRoutes);
app.use('/jadwal', jadwalRoutes);

// ✅ Koneksi MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('✅ MongoDB Connected'))
.catch((err) => console.error('❌ MongoDB Connection Error:', err));

// ✅ Jalankan Server
const PORT = process.env.PORT || 5001;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
