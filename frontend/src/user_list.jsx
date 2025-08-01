import axios from 'axios';

const API = 'http://localhost:5001/api/user';
const token = localStorage.getItem('adminToken');
const res = await axios.get('http://localhost:5001/api/user', {
  headers: { Authorization: `Bearer ${token}` }
});

export const getAllPasien = async () => {
  const token = localStorage.getItem("token");

  const res = await axios.get("http://localhost:5001/api/user/pasien", {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });

  return res.data;
};

export const updatePasien = async (id, data) => {
  const token = localStorage.getItem("token");

  const res = await axios.put(`${API}/${id}`, data, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });

  return res.data;
};

export const deletePasien = async (id) => {
  const token = localStorage.getItem("token");

  const res = await axios.delete(`${API}/${id}`, {
    headers: {
      Authorization: `Bearer ${token}`
    }
  });

  return res.data;
};
