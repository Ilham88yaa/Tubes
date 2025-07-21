import 'package:flutter/material.dart';
import '../models/pasien.dart';
import 'booking_screen.dart';
import 'rekam_medis_screen.dart';
import 'profile_screen.dart';
import 'jadwal_konsultasi_screen.dart';

class HomeScreen extends StatefulWidget {
  final Pasien currentPasien;

  const HomeScreen({super.key, required this.currentPasien});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _navigateTo(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    Widget destination;
    switch (index) {
      case 1:
        destination = RekamMedisScreen(currentPasien: widget.currentPasien);
        break;
      case 2:
        destination = ProfileScreen(currentPasien: widget.currentPasien);
        break;
      default:
        destination = HomeScreen(currentPasien: widget.currentPasien);
    }

    Navigator.of(context).pushReplacement(_fadeRoute(destination));
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(child: Icon(Icons.person)),
            const SizedBox(width: 8),
            Text(widget.currentPasien.nama),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Selamat datang di Meditech',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text('Kesehatan Anda adalah prioritas kami'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _menuCard(
                icon: Icons.schedule,
                label: 'Jadwal\nKonsultasi',
                color: Colors.blue[100]!,
                onTap: () {
                  Navigator.of(
                    context,
                  ).push(_fadeRoute(const JadwalKonsultasiScreen()));
                },
              ),
              _menuCard(
                icon: Icons.book_online,
                label: 'Booking',
                color: Colors.green[100]!,
                onTap: () {
                  Navigator.of(context).push(_fadeRoute(const BookingScreen()));
                },
              ),
              _menuCard(
                icon: Icons.medical_services,
                label: 'Rekam\nMedis',
                color: Colors.orange[100]!,
                onTap: () {
                  Navigator.of(context).push(
                    _fadeRoute(
                      RekamMedisScreen(currentPasien: widget.currentPasien),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _navigateTo,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Rekam Medis',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _menuCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.black87),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
