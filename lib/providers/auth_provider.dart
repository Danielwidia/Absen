import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

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
