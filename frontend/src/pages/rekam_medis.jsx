
import React, { useEffect, useState } from 'react';
import { Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow } from '@mui/material';
import { getAllRekamMedis } from '../services/rekam_services';

export default function RekamMedis() {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const result = await getAllRekamMedis();
        setData(result);
      } catch (err) {
        setError('Gagal memuat data rekam medis');
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  return (
    <Paper sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>Rekam Medis</Typography>
      {loading ? (
        <Typography>Loading...</Typography>
      ) : error ? (
        <Typography color="error">{error}</Typography>
      ) : (
        <TableContainer>
          <Table>
            <TableHead>
              <TableRow>
                <TableCell>Nama Pasien</TableCell>
                <TableCell>Diagnosa</TableCell>
                <TableCell>Tindakan</TableCell>
                <TableCell>Tanggal</TableCell>
              </TableRow>
            </TableHead>
            <TableBody>
              {data.map((row, idx) => (
                <TableRow key={row._id || idx}>
                  <TableCell>{row.nama}</TableCell>
                  <TableCell>{row.diagnosa}</TableCell>
                  <TableCell>{row.tindakan}</TableCell>
                  <TableCell>{row.tanggal ? new Date(row.tanggal).toLocaleDateString() : ''}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
      )}
    </Paper>
  );
}
