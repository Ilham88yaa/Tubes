const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

// Import route
const authRoutes = require('./routes/auth_routes');
const bookingRoutes = require('./routes/booking_routes');
const jadwalRoutes = require('./routes/jadwal_routes');
const rekamRoutes = require('./routes/rekam_routes');
const userRoutes = require('./routes/user_routes'); // ✅ Tambahan untuk user registration

dotenv.config();
const app = express();

// ✅ Middleware CORS yang lebih lengkap
app.use(cors({
  origin: (origin, callback) => {
  callback(null, true); // izinkan semua origin
},
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'x-auth-token'],
  credentials: true
}));

app.use(express.json({ limit: '10mb' })); // Untuk parsing JSON dari body request
app.use(express.urlencoded({ extended: true })); // Untuk parsing form data

// ✅ Logging untuk debug
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('Body:', JSON.stringify(req.body, null, 2));
  }
  next();
});

// ✅ Root route untuk cek API hidup
app.get('/', (req, res) => {
  res.json({
    message: '🎉 Meditech Backend API is running!',
    status: 'OK',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// ✅ Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    message: 'Server is running',
    database: mongoose.connection.readyState === 1 ? 'Connected' : 'Disconnected',
    timestamp: new Date().toISOString()
  });
});

// ✅ API Routes dengan prefix yang konsisten
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes); // ✅ Route untuk user registration & management
app.use('/api/booking', bookingRoutes); // ✅ Tambah prefix /api
app.use('/api/jadwal', jadwalRoutes); // ✅ Tambah prefix /api
app.use('/api/rekam_medis', rekamRoutes);

// ✅ Backward compatibility routes (untuk yang sudah ada)
app.use('/booking', bookingRoutes);
app.use('/jadwal', jadwalRoutes);

// ✅ Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  console.error('Stack:', err.stack);
  
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// ✅ Handle 404 untuk route yang tidak ditemukan
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} not found`,
    availableRoutes: [
      'GET /',
      'GET /api/health',
      'POST /api/user/register',
      'POST /api/user/login',
      'GET /api/user',
      'POST /api/user',
      'GET /api/booking',
      'POST /api/booking',
      'GET /api/jadwal',
      'POST /api/jadwal',
      'GET /api/rekam_medis',
      'POST /api/rekam_medis'
    ]
  });
});

// ✅ Koneksi ke MongoDB dengan better error handling
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => {
  console.log('✅ MongoDB Connected successfully');
  console.log(`📍 Database: ${mongoose.connection.name}`);
})
.catch((err) => {
  console.error('❌ MongoDB Connection Error:', err.message);
  process.exit(1);
});

// ✅ Handle MongoDB connection events
mongoose.connection.on('disconnected', () => {
  console.log('⚠️  MongoDB disconnected');
});

mongoose.connection.on('reconnected', () => {
  console.log('🔄 MongoDB reconnected');
});

// ✅ Graceful shutdown
process.on('SIGINT', async () => {
  console.log('\n🛑 Shutting down gracefully...');
  await mongoose.connection.close();
  console.log('✅ MongoDB connection closed');
  process.exit(0);
});

// ✅ Jalankan server
const PORT = process.env.PORT || 5001;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`🌐 Server accessible on all network interfaces`);
  console.log(`📱 Mobile access: http://[YOUR_IP]:${PORT}`);
  console.log(`🔍 API Documentation: http://localhost:${PORT}/api/health`);
  console.log('📡 Available endpoints:');
  console.log('   - POST /api/user/register (User registration)');
  console.log('   - POST /api/user/login (User login)');
  console.log('   - GET  /api/user (Get patients)');
  console.log('   - POST /api/user (Create patient)');
  console.log('   - GET  /api/booking (Get bookings)');
  console.log('   - POST /api/booking (Create booking)');
});