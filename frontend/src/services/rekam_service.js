// src/services/rekam_services.js
import axios from 'axios';

const BASE_URL = 'http://localhost:5001/api/rekam_medis';

// GET semua rekam medis
export const getAllRekamMedis = async () => {
  const response = await axios.get(BASE_URL);
  return response.data.data;
};

// POST rekam medis baru
export const createRekamMedis = async (rekamData) => {
  const response = await axios.post(BASE_URL, rekamData);
  return response.data;
};
