// src/services/user_service.js
import axios from 'axios';

// Ganti URL sesuai dengan alamat backend-mu
const BASE_URL = 'http://localhost:5001/api/user'; 

// ✅ Ambil semua user
export const getAllUser = async () => {
  try {
    const response = await axios.get(BASE_URL); // GET /api/user
    return response.data;
  } catch (error) {
    console.error('[getAllUser] Error:', error);
    return [];
  }
};

// ✅ Tambah user baru (tidak dipakai di admin tapi bisa untuk testing)
export const createUser = async (data) => {
  try {
    const response = await axios.post(`${BASE_URL}/register`, data); // POST /api/user/register
    return response.data;
  } catch (error) {
    console.error('[createUser] Error:', error);
    throw error;
  }
};

// ✅ Update user berdasarkan ID
export const updateUser = async (id, data) => {
  try {
    const response = await axios.put(`${BASE_URL}/${id}`, data); // PUT /api/user/:id
    return response.data;
  } catch (error) {
    console.error('[updateUser] Error:', error);
    throw error;
  }
};

// ✅ Hapus user berdasarkan ID
export const deleteUser = async (id) => {
  try {
    const response = await axios.delete(`${BASE_URL}/${id}`); // DELETE /api/user/:id
    return response.data;
  } catch (error) {
    console.error('[deleteUser] Error:', error);
    throw error;
  }
};
