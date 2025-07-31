import React, { useEffect, useState } from 'react';
import { Box, Paper, TextField, Button, Typography } from '@mui/material';
import { createJadwal } from '../services/jadwal_services'; // ✅ gunakan file yang benar
import { getAllBookings } from '../services/booking_services'; // ✅ asumsi file ini memang ada

export default function FormBooking() {
  const [bookings, setBookings] = useState([]);

  useEffect(() => {
    fetchBookings();
  }, []);

  const fetchBookings = async () => {
    try {
      const data = await getAllBookings();
      setBookings(data);
    } catch (error) {
      console.error('Gagal ambil booking:', error);
    }
  };

  return (
    <div>
      <h2>Data Booking Konsultasi</h2>
      <table>
        <thead>
          <tr>
            <th>Nama</th>
            <th>Dokter</th>
            <th>Tanggal</th>
            <th>Jam</th>
          </tr>
        </thead>
        <tbody>
          {bookings.map((b, i) => (
            <tr key={i}>
              <td>{b.nama}</td>
              <td>{b.dokter}</td>
              <td>{b.tanggal}</td>
              <td>{b.jam}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
