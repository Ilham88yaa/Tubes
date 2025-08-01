import axios from 'axios';

const BASE_URL = 'http://localhost:5001/api/booking';

export const getAllBookings = async () => {
  const res = await axios.get('http://localhost:5001/api/booking');
  return res.data;
};

export const createBooking = async (data) => {
  const response = await axios.post(BASE_URL, data);
  return response.data;
};
