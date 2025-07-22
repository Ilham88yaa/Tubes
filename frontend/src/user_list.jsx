import axios from 'axios';

const API = 'http://localhost:5001/api/user';

export const getAllPasien = async () => {
  const res = await axios.get(API);
  return res.data;
};

export const updatePasien = async (id, data) => {
  const res = await axios.put(`${API}/${id}`, data);
  return res.data;
};

export const deletePasien = async (id) => {
  const res = await axios.delete(`${API}/${id}`);
  return res.data;
};
