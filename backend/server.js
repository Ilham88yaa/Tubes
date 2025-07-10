const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const pasienRoutes = require('./routes/pasien_routes');
const authRoutes = require('./routes/auth_routes'); 
require('dotenv').config();

const app = express();

// ✅ CORS untuk semua origin (termasuk Flutter Web)
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type'],
}));

app.use(express.json());

// ✅ Routing
app.use('/api/pasien', pasienRoutes);
app.use('/api/auth', authRoutes);

// ✅ Koneksi MongoDB
mongoose.connect(process.env.MONGO_URI, {})
  .then(() => console.log('✅ MongoDB Connected'))
  .catch(err => console.error(err));

// ✅ Jalankan server di semua IP
const PORT = process.env.PORT || 5001;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
