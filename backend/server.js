const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

// Import routes
const authRoutes = require('./routes/auth_routes');
const bookingRoutes = require('./routes/booking_routes');
const jadwalRoutes = require('./routes/jadwal_routes');
const rekamRoutes = require('./routes/rekam_routes');
const userRoutes = require('./routes/user_routes');
const konsultasiRoute = require('./routes/konsultasi');
const adminRoutes = require('./routes/admin_routes');

dotenv.config();
const app = express();

// Middleware CORS
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'x-auth-token'],
  credentials: true
}));

// Middleware untuk parsing body request
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Logger
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`);
  if (req.body && Object.keys(req.body).length > 0) {
    console.log('Body:', JSON.stringify(req.body, null, 2));
  }
  next();
});

// Root route
app.get('/', (req, res) => {
  res.json({
    message: '🎉 Meditech Backend API is running!',
    status: 'OK',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'Server is running',
    database: mongoose.connection.readyState === 1 ? 'Connected' : 'Disconnected',
    timestamp: new Date().toISOString()
  });
});

// Main routes
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/booking', bookingRoutes);
app.use('/api/jadwal', jadwalRoutes);
app.use('/api/rekam_medis', rekamRoutes);
app.use('/api/konsultasi', konsultasiRoute);
app.use('/api/admin', adminRoutes);

// Optional: backward compatibility
app.use('/booking', bookingRoutes);
app.use('/jadwal', jadwalRoutes);

// Error handler middleware
app.use((err, req, res, next) => {
  console.error('Error:', err.message);
  console.error('Stack:', err.stack);
  res.status(err.status || 500).json({
    success: false,
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} not found`,
    availableRoutes: [
      'GET /',
      'GET /api/health',
      'POST /api/user/register',
      'POST /api/user/login',
      'GET /api/user/pasien',
      'GET /api/user/dokter',
      'GET /api/user/admin',
      'POST /api/user',
      'PUT /api/user/:id',
      'DELETE /api/user/:id',
      'GET /api/booking',
      'POST /api/booking',
      'GET /api/jadwal',
      'POST /api/jadwal',
      'GET /api/rekam_medis',
      'POST /api/rekam_medis'
    ]
  });
});

// Connect MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => {
  console.log('✅ MongoDB Connected successfully');
  console.log(`📍 Database: ${mongoose.connection.name}`);
})
.catch((err) => {
  console.error('❌ MongoDB Connection Error:', err.message);
  process.exit(1);
});

mongoose.connection.on('disconnected', () => {
  console.log('⚠️  MongoDB disconnected');
});

mongoose.connection.on('reconnected', () => {
  console.log('🔄 MongoDB reconnected');
});

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('\n🛑 Shutting down gracefully...');
  await mongoose.connection.close();
  console.log('✅ MongoDB connection closed');
  process.exit(0);
});

// Jalankan server
const PORT = process.env.PORT || 5001;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`🌐 Server accessible on all network interfaces`);
  console.log(`📱 Mobile access: http://[YOUR_IP]:${PORT}`);
  console.log(`🔍 API Documentation: http://localhost:${PORT}/api/health`);
});
