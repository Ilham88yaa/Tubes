// src/services/pasien_service.js

import axios from 'axios';

export const getAllPasien = async () => {
  try {
    const response = await axios.get('http://localhost:5000/api/pasien');
    return response.data;
  } catch (error) {
    console.error('❌ Gagal mengambil data pasien:', error);
    return [];
  }
};
