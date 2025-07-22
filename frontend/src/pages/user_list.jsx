import React, { useEffect, useState } from 'react';
import { getAllUser, updateUser, deleteUser } from '../services/user_service';
import {
  Typography, Paper, Table, TableBody, TableCell, TableContainer, TableHead, TableRow,
  Box, Button, TextField, Dialog, DialogActions, DialogContent, DialogTitle
} from '@mui/material';

const UserList = () => {
  const [users, setUsers] = useState([]);
  const [openEdit, setOpenEdit] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);

  const fetchData = () => {
    getAllUser().then(data => setUsers(data));
  };

  useEffect(() => {
    fetchData();
  }, []);

  const handleEditClick = (user) => {
    setSelectedUser(user);
    setOpenEdit(true);
  };

  const handleEditChange = (e) => {
    setSelectedUser({
      ...selectedUser,
      [e.target.name]: e.target.value
    });
  };

  const handleEditSubmit = async () => {
    try {
      await updateUser(selectedUser._id, selectedUser);
      setOpenEdit(false);
      fetchData();
      alert('Data user berhasil diupdate');
    } catch (err) {
      console.error(err);
      alert('Gagal mengupdate data user');
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Apakah Anda yakin ingin menghapus data user ini?')) {
      try {
        await deleteUser(id);
        fetchData();
        alert('Data user berhasil dihapus');
      } catch (err) {
        console.error(err);
        alert('Gagal menghapus data user');
      }
    }
  };

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h5" gutterBottom>Daftar User</Typography>

      <TableContainer component={Paper} elevation={3}>
        <Table>
          <TableHead sx={{ backgroundColor: '#1976d2' }}>
            <TableRow>
              <TableCell sx={{ color: '#fff' }}>Nama</TableCell>
              <TableCell sx={{ color: '#fff' }}>Email</TableCell>
              <TableCell sx={{ color: '#fff' }}>Umur</TableCell>
              <TableCell sx={{ color: '#fff' }}>Role</TableCell>
              <TableCell sx={{ color: '#fff' }}>Aksi</TableCell>
            </TableRow>
          </TableHead>

          <TableBody>
            {users.length > 0 ? (
              users.map((u) => (
                <TableRow key={u._id}>
                  <TableCell>{u.nama}</TableCell>
                  <TableCell>{u.email}</TableCell>
                  <TableCell>{u.umur}</TableCell>
                  <TableCell>{u.role}</TableCell>
                  <TableCell>
                    <Button variant="outlined" size="small" onClick={() => handleEditClick(u)}>Edit</Button>{' '}
                    <Button variant="contained" color="error" size="small" onClick={() => handleDelete(u._id)}>Delete</Button>
                  </TableCell>
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={5} align="center">Belum ada data user.</TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>

      {/* Modal Edit */}
      <Dialog open={openEdit} onClose={() => setOpenEdit(false)}>
        <DialogTitle>Edit User</DialogTitle>
        <DialogContent sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 1 }}>
          <TextField label="Nama" name="nama" value={selectedUser?.nama || ''} onChange={handleEditChange} />
          <TextField label="Email" name="email" value={selectedUser?.email || ''} onChange={handleEditChange} />
          <TextField label="Umur" name="umur" type="number" value={selectedUser?.umur || ''} onChange={handleEditChange} />
          <TextField label="Role" name="role" value={selectedUser?.role || ''} onChange={handleEditChange} />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenEdit(false)}>Batal</Button>
          <Button variant="contained" onClick={handleEditSubmit}>Simpan</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default UserList;
