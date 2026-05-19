import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ... di dalam class AuthProvider
final _supabase = Supabase.instance.client;

Future<bool> login(String username, String password) async {
  try {
    // 1. Ambil data user berdasarkan username dari tabel Supabase
    final response = await _supabase
        .from('users') // Pastikan nama tabel sesuai di Supabase
        .select()
        .eq('username', username)
        .eq('password', password) // Catatan: Sebaiknya gunakan Auth Supabase, bukan simpan password plain
        .maybeSingle();

    if (response != null) {
      // 2. Map data dari Supabase ke UserModel
      _user = UserModel.fromMap(response);

      // Simpan status login jika perlu
      if (_rememberMe && prefs != null) {
        await prefs!.setString('saved_username', username);
      }

      notifyListeners();
      return true;
    }
    return false;
  } catch (e) {
    debugPrint('Login Error: $e');
    return false;
  }
}

// Tambahkan juga fungsi register yang dipanggil di RegisterScreen
Future<bool> register(UserModel user, String password) async {
  try {
    await _supabase.from('users').insert({
      'username': user.username,
      'password': password,
      'full_name': user.fullName,
      'role': user.role.toString().split('.').last,
      'place_of_birth': user.placeOfBirth,
      'date_of_birth': user.dateOfBirth?.toIso8601String(),
      'address': user.address,
      'has_face_registered': user.hasFaceRegistered,
    });
    return true;
  } catch (e) {
    debugPrint('Register Error: $e');
    return false;
  }
}

class AuthProvider with ChangeNotifier {
  final SharedPreferences? prefs;
  UserModel? _user;
  bool _rememberMe = false;

  UserModel? get user => _user;
  bool get rememberMe => _rememberMe;

  AuthProvider({this.prefs}) {
    _loadRememberMe();
  }

  void _loadRememberMe() {
    if (prefs != null) {
      _rememberMe = prefs!.getBool('remember_me') ?? false;
      notifyListeners();
    }
  }

  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    if (prefs != null) {
      await prefs!.setBool('remember_me', value);
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    // Simulasi Login
    if (username == 'ADM' && password == 'admin321') {
      _user = UserModel(
        id: 'admin_1',
        username: 'ADM',
        fullName: 'Administrator',
        role: UserRole.admin,
        hasFaceRegistered: true,
      );
      notifyListeners();
      return true;
    }

    if (username.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: 'user_123',
        username: username,
        fullName: 'User $username',
        role: UserRole.student,
        hasFaceRegistered: true,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}
