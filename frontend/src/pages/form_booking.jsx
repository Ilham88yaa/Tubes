import React, { useState } from 'react';
import { createJadwal } from '../services/jadwal_service';
import { Box, Paper, TextField, Button, Typography } from '@mui/material';

export default function FormBooking() {
  const [form, setForm] = useState({
    nama: '',
    dokter: '',
    tanggal: '',
    jam: ''
  });

  const handleChange = (e) => {
    setForm({
      ...form,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await createJadwal(form);
      alert('Booking berhasil disimpan');
      setForm({ nama: '', dokter: '', tanggal: '', jam: '' });
    } catch (err) {
      console.error(err);
      alert('Gagal menyimpan booking');
    }
  };

  return (
    <Paper sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>Form Booking Konsultasi</Typography>
      <Box component="form" onSubmit={handleSubmit} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
        <TextField label="Nama Pasien" name="nama" value={form.nama} onChange={handleChange} required />
        <TextField label="Dokter" name="dokter" value={form.dokter} onChange={handleChange} required />
        <TextField label="Tanggal" type="date" name="tanggal" value={form.tanggal} onChange={handleChange} InputLabelProps={{ shrink: true }} required />
        <TextField label="Jam" type="time" name="jam" value={form.jam} onChange={handleChange} InputLabelProps={{ shrink: true }} required />
        <Button type="submit" variant="contained">Booking</Button>
      </Box>
    </Paper>
  );
}
