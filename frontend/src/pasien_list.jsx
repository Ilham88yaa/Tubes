import React, { useEffect, useState } from 'react';
import { getAllPasien } from '../services/pasien_services';

function PasienList() {
  const [pasien, setPasien] = useState([]);

  useEffect(() => {
    const fetchPasien = async () => {
      try {
        const data = await getAllPasien();
        setPasien(data);
      } catch (err) {
        console.error('Gagal mengambil data pasien:', err);
      }
    };

    fetchPasien();
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
}

export default PasienList;
