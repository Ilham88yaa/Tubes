// src/services/user_service.js
import axios from 'axios';

const BASE_URL = 'http://localhost:5001/api/user'; // Sesuaikan dengan URL backend kamu

// Ambil semua data user
export const getAllUser = async () => {
  const response = await axios.get(BASE_URL);
  return response.data;
};

// Buat user baru
export const createUser = async (data) => {
  const response = await axios.post(BASE_URL, data);
  return response.data;
};

// Update data user berdasarkan ID
export const updateUser = async (id, data) => {
  const response = await axios.put(`${BASE_URL}/${id}`, data);
  return response.data;
};

// Hapus user berdasarkan ID
export const deleteUser = async (id) => {
  const response = await axios.delete(`${BASE_URL}/${id}`);
  return response.data;
};
