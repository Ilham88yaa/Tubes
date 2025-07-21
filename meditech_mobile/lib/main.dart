import 'package:flutter/material.dart';
import 'models/pasien.dart';
import 'screens/splash_screen.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/rekam_medis_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/jadwal_konsultasi_screen.dart';

void main() {
  runApp(const MeditechApp());
}

class MeditechApp extends StatelessWidget {
  const MeditechApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => SplashScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/home':
            final pasien = settings.arguments as Pasien;
            return MaterialPageRoute(
              builder: (_) => HomeScreen(currentPasien: pasien),
            );
          case '/medical-history':
            final pasien = settings.arguments as Pasien;
            return MaterialPageRoute(
              builder: (_) => RekamMedisScreen(currentPasien: pasien),
            );
          case '/profile':
            final pasien = settings.arguments as Pasien;
            return MaterialPageRoute(
              builder: (_) => ProfileScreen(currentPasien: pasien),
            );
          case '/jadwal-konsultasi':
            return MaterialPageRoute(
              builder: (_) => const JadwalKonsultasiScreen(),
            );
          default:
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('404 - Page not found')),
                  ),
            );
        }
      },
    );
  }
}
