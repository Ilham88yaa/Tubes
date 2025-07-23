const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const AdminSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
});

const userSchema = new mongoose.Schema({
  nama: {
    type: String,
    required: [true, 'Nama wajib diisi'],
  },
  email: {
    type: String,
    required: [true, 'Email wajib diisi'],
    unique: true,
    lowercase: true,
    trim: true,
  },
  password: {
    type: String,
    required: [true, 'Password wajib diisi'],
    minlength: [6, 'Password minimal 6 karakter'],
  },
  umur: {
    type: Number,
    min: [0, 'Umur tidak valid'],
  },
  tanggal_lahir: Date,
  alamat: String,
  no_hp: String,
  role: {
    type: String,
    enum: ['pasien', 'dokter', 'admin'],
    default: 'pasien',
  },

  // HANYA digunakan kalau role === 'pasien'
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


}, { timestamps: true });

// 🔐 Hash password sebelum menyimpan
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (err) {
    return next(err);
  }
});

// 🔐 Method membandingkan password
userSchema.methods.comparePassword = function (inputPassword) {
  return bcrypt.compare(inputPassword, this.password);
};

module.exports = mongoose.model('User', userSchema);
