import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managemant_sekolah/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';

void main() async {
  // 1. Pastikan Binding diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences? prefs;
  try {
    // 2. Coba ambil instance SharedPreferences
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint("Gagal memuat SharedPreferences: $e");
    // Lanjutkan aplikasi meskipun prefs gagal (opsional)
  }

  runApp(
    MultiProvider(
      providers: [
        // Inject prefs (bisa null jika gagal)
        ChangeNotifierProvider(create: (_) => AuthProvider(prefs: prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sekolah Kristen Dorkas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A),
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFD4AF37),
        ),
        useMaterial3: true,
        // Gunakan fallback jika Google Fonts gagal dimuat (masalah koneksi/CORS)
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith(
          bodyMedium: const TextStyle(fontFamily: 'sans-serif'),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
