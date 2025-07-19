const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const pasienRoutes = require('./routes/pasien_routes');
const authRoutes = require('./routes/auth_routes');
require('dotenv').config();

const app = express();

// ✅ Middleware
app.use(cors()); // Izinkan akses dari semua origin
app.use(express.json()); // Parsing JSON body dari request

// ✅ Route root (opsional, untuk testing)
app.get('/', (req, res) => {
  res.send('🎉 Meditech Backend API is running!');
});

// ✅ API Routes
app.use('/api/pasien', pasienRoutes);
app.use('/api/auth', authRoutes);

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
