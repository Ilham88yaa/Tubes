// src/pages/TambahPasien.jsx
import React, { useState } from 'react';
import { tambahPasien } from '../services/pasien_service';

const TambahPasien = () => {
  const [nama, setNama] = useState('');
  const [umur, setUmur] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    await tambahPasien({ nama, umur });
    alert('Pasien berhasil ditambahkan!');
    setNama('');
    setUmur('');
  };

  return (
    <form onSubmit={handleSubmit}>
      <h2>Tambah Pasien</h2>
      <input type="text" placeholder="Nama" value={nama} onChange={(e) => setNama(e.target.value)} />
      <input type="number" placeholder="Umur" value={umur} onChange={(e) => setUmur(e.target.value)} />
      <button type="submit">Tambah</button>
    </form>
  );
};

export default TambahPasien;
