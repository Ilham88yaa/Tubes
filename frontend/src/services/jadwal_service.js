// src/services/jadwal_service.js
import axios from 'axios';

const BASE_URL = 'http://localhost:5001/api/jadwal';

export const getAllJadwal = async () => {
  const response = await axios.get(BASE_URL);
  return response.data.data;
};

export const createJadwal = async (jadwalData) => {
  const response = await axios.post(BASE_URL, jadwalData);
  return response.data;
};
