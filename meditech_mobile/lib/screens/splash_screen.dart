import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pasien.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checkingLogin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString('pasien_id');
    final String? nama = prefs.getString('pasien_nama');
    final String? email = prefs.getString('pasien_email');
    final int? umur = prefs.getInt('pasien_umur'); // ✅ Ambil umur

    if (id != null && nama != null && umur != null) {
      // ✅ Pastikan umur disertakan
      final pasien = Pasien(id: id, nama: nama, email: email, umur: umur);
      Navigator.pushReplacementNamed(context, '/home', arguments: pasien);
    } else {
      setState(() {
        _checkingLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            _checkingLogin
                ? const CircularProgressIndicator()
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 80),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 63, 0, 117),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3,
                      ),
                      child: const Text(
                        'Mulai',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Sudah punya akun? Login',
                        style: TextStyle(
                          color: Color.fromARGB(255, 19, 15, 22),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
