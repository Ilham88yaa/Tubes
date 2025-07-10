const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

// Skema User
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
    required: [true, 'Umur wajib diisi'],
    min: [0, 'Umur tidak valid'],
  },
}, {
  timestamps: true, // otomatis menambahkan createdAt dan updatedAt
});

// 🔐 Hash password sebelum menyimpan user
userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next(); // jika password tidak berubah, lanjutkan
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (err) {
    next(err); // lempar error ke middleware
  }
});

// 🔐 Method untuk membandingkan password saat login
userSchema.methods.comparePassword = function (inputPassword) {
  return bcrypt.compare(inputPassword, this.password);
};

// Export model
module.exports = mongoose.model('User', userSchema);
