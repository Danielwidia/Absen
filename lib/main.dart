import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:managemant_sekolah/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://yakhhfclrtlnecsotjsn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlha2hoZmNscnRsbmVjc290anNuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxNjMwMDYsImV4cCI6MjA5NDczOTAwNn0.Bm2LvepavgTmCQIce1XJPaTCq6PLX2m2HmdYbvBgLqY',
  );

  // 2. Inisialisasi SharedPreferences
  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint("Gagal memuat SharedPreferences: $e");
  }

  runApp(
    MultiProvider(
      providers: [
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
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith(
          bodyMedium: const TextStyle(fontFamily: 'sans-serif'),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
