import React, { useEffect, useState } from 'react';
import { DataGrid } from '@mui/x-data-grid';
import {
  Button,
  Snackbar,
  Typography,
  Box,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  TextField,
} from '@mui/material';
import { getAllUser, updateUser, deleteUser } from '../services/user_services';

export default function UserList() {
  const [users, setUsers] = useState([]);
  const [snackbarOpen, setSnackbarOpen] = useState(false);
  const [snackbarMsg, setSnackbarMsg] = useState('');
  const [openEdit, setOpenEdit] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);

  const fetchUsers = async () => {
    try {
      const role = localStorage.getItem('role');
      const email = localStorage.getItem('email');
      const data = await getAllUser();

      if (role === 'admin') {
        setUsers(data); // Admin melihat semua user
      } else {
        // Pasien hanya melihat datanya sendiri
        const user = data.find((u) => u.email === email);
        setUsers(user ? [user] : []);
      }
    } catch (err) {
      console.error('Gagal mengambil data user:', err);
    }
  };

  const handleDelete = async (id) => {
    if (window.confirm('Apakah Anda yakin ingin menghapus data user ini?')) {
      try {
        await deleteUser(id);
        setSnackbarMsg('User berhasil dihapus');
        setSnackbarOpen(true);
        fetchUsers();
      } catch (err) {
        console.error('Gagal menghapus:', err);
        setSnackbarMsg('Gagal menghapus user');
        setSnackbarOpen(true);
      }
    }
  };

  const handleEditClick = (user) => {
    setSelectedUser(user);
    setOpenEdit(true);
  };

  const handleEditChange = (e) => {
    setSelectedUser({ ...selectedUser, [e.target.name]: e.target.value });
  };

  const handleEditSubmit = async () => {
    try {
      await updateUser(selectedUser._id, selectedUser);
      setSnackbarMsg('Data user berhasil diupdate');
      setSnackbarOpen(true);
      setOpenEdit(false);
      fetchUsers();
    } catch (err) {
      console.error(err);
      setSnackbarMsg('Gagal mengupdate data user');
      setSnackbarOpen(true);
    }
  };

  const columns = [
    { field: '_id', headerName: 'ID', width: 150 },
    { field: 'nama', headerName: 'Nama', width: 150 },
    { field: 'email', headerName: 'Email', width: 200 },
    { field: 'role', headerName: 'Role', width: 120 },
    {
      field: 'actions',
      headerName: 'Aksi',
      width: 200,
      renderCell: (params) => (
        <>
          <Button
            variant="outlined"
            size="small"
            onClick={() => handleEditClick(params.row)}
            sx={{ mr: 1 }}
          >
            Edit
          </Button>
          <Button
            variant="contained"
            color="error"
            size="small"
            onClick={() => handleDelete(params.row._id)}
          >
            Hapus
          </Button>
        </>
      ),
    },
  ];

  useEffect(() => {
    fetchUsers();
  }, []);

  return (
    <Box p={3}>
      <Typography variant="h5" gutterBottom>
        Daftar User
      </Typography>
      <Box height={450}>
        <DataGrid
          rows={users}
          columns={columns}
          pageSize={5}
          getRowId={(row) => row._id}
        />
      </Box>

      <Snackbar
        open={snackbarOpen}
        autoHideDuration={3000}
        onClose={() => setSnackbarOpen(false)}
        message={snackbarMsg}
      />

      <Dialog open={openEdit} onClose={() => setOpenEdit(false)}>
        <DialogTitle>Edit User</DialogTitle>
        <DialogContent sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 1 }}>
          <TextField
            label="Nama"
            name="nama"
            value={selectedUser?.nama || ''}
            onChange={handleEditChange}
          />
          <TextField
            label="Email"
            name="email"
            value={selectedUser?.email || ''}
            onChange={handleEditChange}
          />
          <TextField
            label="Umur"
            name="umur"
            type="number"
            value={selectedUser?.umur || ''}
            onChange={handleEditChange}
          />
          <TextField
            label="Role"
            name="role"
            value={selectedUser?.role || ''}
            onChange={handleEditChange}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenEdit(false)}>Batal</Button>
          <Button variant="contained" onClick={handleEditSubmit}>Simpan</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}
