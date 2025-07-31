import React, { useState } from 'react';
import { Box, Paper, TextField, Button, Typography } from '@mui/material';
import { createRekamMedis } from '../services/rekam_services';

export default function FormRekamMedis() {
  const [form, setForm] = useState({
    nama: '',
    diagnosa: '',
    tindakan: '',
    tanggal: ''
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
      await createRekamMedis(form);
      alert('Rekam medis berhasil disimpan');
      setForm({ nama: '', diagnosa: '', tindakan: '', tanggal: '' });
    } catch (err) {
      console.error(err);
      alert('Gagal menyimpan rekam medis');
    }
  };

  return (
    <Paper sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>Form Rekam Medis</Typography>
      <Box component="form" onSubmit={handleSubmit} sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
        <TextField label="Nama Pasien" name="nama" value={form.nama} onChange={handleChange} required />
        <TextField label="Diagnosa" name="diagnosa" value={form.diagnosa} onChange={handleChange} required />
        <TextField label="Tindakan" name="tindakan" value={form.tindakan} onChange={handleChange} required />
        <TextField label="Tanggal" type="date" name="tanggal" value={form.tanggal} onChange={handleChange} InputLabelProps={{ shrink: true }} required />
        <Button type="submit" variant="contained">Simpan Rekam Medis</Button>
      </Box>
    </Paper>
  );
}
