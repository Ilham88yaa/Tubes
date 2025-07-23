import axios from 'axios';

const BASE_URL = 'http://localhost:5001/api/booking';

export const getAllBookings = async () => {
  const response = await axios.get(BASE_URL);
  return response.data;
};

export const createBooking = async (data) => {
  const response = await axios.post(BASE_URL, data);
  return response.data;
};
