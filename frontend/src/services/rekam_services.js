import axios from 'axios';

const BASE_URL = 'http://localhost:5001/api'; // Atur sesuai IP backend kamu

// POST untuk input rekam medis baru
export async function createRekamMedis(data) {
  try {
    const response = await axios.post(`${BASE_URL}/rekam-medis`, data);
    return response.data;
  } catch (error) {
    console.error('Gagal menyimpan rekam medis:', error);
    throw error;
  }
}

// GET semua data rekam medis
export async function getAllRekamMedis() {
  try {
    const response = await axios.get(`${BASE_URL}/rekam-medis`);
    return response.data;
  } catch (error) {
    console.error('Gagal mengambil data rekam medis:', error);
    throw error;
  }
}
