import React, { useState } from 'react';
import axios from 'axios';
import { Button, TextField, Typography, Snackbar, Alert } from '@mui/material';
import { useNavigate } from 'react-router-dom'; // tambahkan ini

export default function AdminLogin({ onLoginSuccess }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'info' });
  const navigate = useNavigate(); // tambahkan ini

  const handleLogin = async () => {
    try {
      const res = await axios.post('http://localhost:5001/api/admin/login', { username, password }); // gunakan URL penuh agar pasti benar
      console.log('Login response:', res.data);

      if (res.data && res.data.token) {
        localStorage.setItem('adminToken', res.data.token);
        localStorage.setItem('role', 'admin'); // optional

        setSnackbar({ open: true, message: 'Login berhasil', severity: 'success' });

        // Navigasi ke dashboard setelah login sukses
        setTimeout(() => {
          if (onLoginSuccess) {
            onLoginSuccess(); // jika props dipakai
          } else {
            navigate('/'); // fallback langsung ke dashboard
          }
        }, 800);
      } else {
        throw new Error('Login tidak valid: token kosong');
      }
    } catch (err) {
      console.error('LOGIN ERROR:', err?.response?.data || err.message || err);

      setSnackbar({
        open: true,
        message: 'Login gagal: ' + (err?.response?.data?.message || err.message || 'Unknown error'),
        severity: 'error',
      });
    }
  };

  return (
    <div style={{ maxWidth: 400, margin: '80px auto', padding: 24, boxShadow: '0 4px 16px rgba(0,0,0,0.1)', borderRadius: 12 }}>
      <Typography variant="h5" gutterBottom>Login Admin</Typography>
      <TextField
        fullWidth label="Username" variant="outlined"
        value={username} onChange={(e) => setUsername(e.target.value)} margin="normal"
      />
      <TextField
        fullWidth label="Password" type="password" variant="outlined"
        value={password} onChange={(e) => setPassword(e.target.value)} margin="normal"
      />
      <Button variant="contained" color="primary" fullWidth sx={{ mt: 2 }} onClick={handleLogin}>
        Login
      </Button>

      <Snackbar open={snackbar.open} autoHideDuration={3000} onClose={() => setSnackbar({ ...snackbar, open: false })}>
        <Alert severity={snackbar.severity}>{snackbar.message}</Alert>
      </Snackbar>
    </div>
  );
}
