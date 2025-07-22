import React, { useEffect, useState } from 'react';
import { getAllJadwal } from '../services/jadwal_service';
import { Typography, Paper, Box, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from '@mui/material';

export default function JadwalKonsultasi() {
  const [jadwal, setJadwal] = useState([]);

  useEffect(() => {
    getAllJadwal().then(data => setJadwal(data));
  }, []);

  return (
    <Paper sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>Jadwal Konsultasi</Typography>
      <TableContainer>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Nama Pasien</TableCell>
              <TableCell>Dokter</TableCell>
              <TableCell>Tanggal</TableCell>
              <TableCell>Jam</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {jadwal.map((row, idx) => (
              <TableRow key={idx}>
                <TableCell>{row.nama}</TableCell>
                <TableCell>{row.dokter}</TableCell>
                <TableCell>{new Date(row.tanggal).toLocaleDateString()}</TableCell>
                <TableCell>{row.jam}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Paper>
  );
}
// This component fetches and displays the consultation schedule in a table format.