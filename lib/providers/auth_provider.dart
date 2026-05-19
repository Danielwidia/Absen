import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _rememberMe = false;

  UserModel? get user => _user;
  bool get rememberMe => _rememberMe;

  AuthProvider() {
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('remember_me') ?? false;
    notifyListeners();
  }

  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', value);
    notifyListeners();
  }

  Future<bool> register(UserModel newUser, String password) async {
    // In a real app, save to Supabase
    // For now, simulate success
    _user = newUser;
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    // Default Admin
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

    // Mock logic for demo
    if (username.isNotEmpty && password.length >= 6) {
      _user = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
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
