// src/pages/PasienList.jsx
import React, { useEffect, useState } from 'react';
import { getAllPasien } from '../services/pasien_service';

const PasienList = () => {
  const [pasien, setPasien] = useState([]);

  useEffect(() => {
    getAllPasien().then(data => setPasien(data));
  }, []);

  return (
    <div>
      <h2>Daftar Pasien</h2>
      <ul>
        {pasien.map((p) => (
          <li key={p._id}>{p.nama} - {p.umur} tahun</li>
        ))}
      </ul>
    </div>
  );
};

export default PasienList;
