// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../models/pasien.dart';

class ProfileScreen extends StatelessWidget {
  final Pasien currentPasien;

  const ProfileScreen({super.key, required this.currentPasien});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentPasien.nama,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentPasien.email ?? '',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to edit profile
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Menu Items
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSectionHeader('Informasi Personal'),
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Data Pribadi',
                    subtitle: 'Kelola informasi personal Anda',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.medical_information_outlined,
                    title: 'Riwayat Kesehatan',
                    subtitle: 'Lihat riwayat medis lengkap',
                    onTap: () {
                      Navigator.pushNamed(context, '/medical-history');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.family_restroom,
                    title: 'Keluarga',
                    subtitle: 'Kelola profil keluarga',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildSectionHeader('Kesehatan'),
                  _buildMenuItem(
                    icon: Icons.favorite_outline,
                    title: 'Kesehatan Saya',
                    subtitle: 'Monitor kondisi kesehatan',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Jadwal Konsultasi',
                    subtitle: 'Kelola jadwal konsultasi',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.medication_outlined,
                    title: 'Obat & Suplemen',
                    subtitle: 'Kelola obat dan suplemen',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildSectionHeader('Pengaturan'),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifikasi',
                    subtitle: 'Pengaturan notifikasi',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.security_outlined,
                    title: 'Keamanan',
                    subtitle: 'Password dan keamanan akun',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.language_outlined,
                    title: 'Bahasa',
                    subtitle: 'Pilih bahasa aplikasi',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildSectionHeader('Bantuan & Dukungan'),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Pusat Bantuan',
                    subtitle: 'FAQ dan panduan penggunaan',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.contact_support_outlined,
                    title: 'Hubungi Kami',
                    subtitle: 'Kontak customer service',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.star_outline,
                    title: 'Beri Rating',
                    subtitle: 'Berikan rating untuk aplikasi',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    subtitle: 'Logout dari akun',
                    textColor: Colors.red,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // App Version
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Meditech App',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue[600],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (textColor == Colors.red ? Colors.red[50] : Colors.blue[50]),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: textColor ?? Colors.blue[600], size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
