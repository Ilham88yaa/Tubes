import axios from 'axios';

const BASE_URL = 'http://localhost:5001/api'; // Ganti sesuai IP server jika pakai emulator atau jaringan lain

// GET semua rekam medis
export async function getAllRekamMedis() {
  try {
    const response = await axios.get(`${BASE_URL}/rekam-medis`);
    return response.data;
  } catch (error) {
    console.error('Gagal mengambil data rekam medis:', error);
    throw error;
  }
}

// POST booking konsultasi
export async function createJadwal(data) {
  try {
    const response = await axios.post(`${BASE_URL}/jadwal`, data);
    return response.data;
  } catch (error) {
    console.error('Gagal membuat jadwal konsultasi:', error);
    throw error;
  }
}

export async function getAllJadwal() {
  try {
    const response = await axios.get(`${BASE_URL}/jadwal`);
    return response.data;
  } catch (error) {
    console.error('Gagal mengambil data jadwal:', error);
    throw error;
  }
}