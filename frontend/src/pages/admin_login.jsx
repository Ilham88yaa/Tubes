import React, { useState } from 'react';
import axios from 'axios';
import { Button, TextField, Typography, Snackbar, Alert } from '@mui/material';

export default function AdminLogin({ onLoginSuccess }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [snackbar, setSnackbar] = useState({ open: false, message: '', severity: 'info' });

  const handleLogin = async () => {
    try {
      const res = await axios.post('http://localhost:5001/api/admin/login', { username, password });
      localStorage.setItem('adminToken', res.data.token);
      setSnackbar({ open: true, message: 'Login berhasil', severity: 'success' });
      onLoginSuccess(); // callback untuk masuk ke dashboard
    } catch (err) {
      setSnackbar({ open: true, message: 'Login gagal', severity: 'error' });
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
