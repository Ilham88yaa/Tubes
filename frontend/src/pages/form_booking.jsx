import React, { useEffect, useState } from 'react';
import { Box, Paper, Typography, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from '@mui/material';
import { getAllBookings } from '../services/booking_services'; // pastikan file dan ekspor sesuai

export default function FormBooking() {
  const [bookings, setBookings] = useState([]);

  useEffect(() => {
    fetchBookings();
  }, []);

  const fetchBookings = async () => {
    try {
      const data = await getAllBookings();
      console.log('Fetched bookings:', data); // 👈 Debug log
      if (Array.isArray(data)) {
        setBookings(data);
      } else {
        console.warn('Data booking bukan array:', data);
        setBookings([]);
      }
    } catch (error) {
      console.error('Gagal ambil booking:', error);
      setBookings([]); // fallback supaya map tidak error
    }
  };

  return (
    <Box sx={{ padding: 4 }}>
      <Typography variant="h5" gutterBottom>
        Data Booking Konsultasi
      </Typography>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow sx={{ backgroundColor: '#f0f4ff' }}>
              <TableCell><b>Nama</b></TableCell>
              <TableCell><b>Dokter</b></TableCell>
              <TableCell><b>Tanggal</b></TableCell>
              <TableCell><b>Jam</b></TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {bookings.length === 0 ? (
              <TableRow>
                <TableCell colSpan={4} align="center">
                  Tidak ada data booking.
                </TableCell>
              </TableRow>
            ) : (
              bookings.map((b, i) => (
                <TableRow key={i}>
                  <TableCell>{b.nama || '-'}</TableCell>
                  <TableCell>{b.dokter || '-'}</TableCell>
                  <TableCell>{b.tanggal || '-'}</TableCell>
                  <TableCell>{b.jam || '-'}</TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
}
