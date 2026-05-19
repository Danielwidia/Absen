import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/biometric_service.dart';
import '../services/location_service.dart';
import '../services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final BiometricService _biometricService = BiometricService();
  final LocationService _locationService = LocationService();
  final AttendanceService _attendanceService = AttendanceService();

  bool _isLoading = false;
  String _statusMessage = 'Siap untuk melakukan absensi';

  Future<void> _processAttendance(String type) async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Memverifikasi Biometrik...';
    });

    // 1. Biometric Check
    final isAuthenticated = await _biometricService.authenticate();
    if (!isAuthenticated) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Gagal Verifikasi Biometrik';
      });
      return;
    }

    // 2. Location Check
    setState(() => _statusMessage = 'Mendapatkan Lokasi GPS...');
    final position = await _locationService.getCurrentLocation();
    if (position == null) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Gagal mendapatkan lokasi GPS';
      });
      return;
    }

    // 3. Submit to Google Sheets
    setState(() => _statusMessage = 'Mengirim data ke server...');
    final user = context.read<AuthProvider>().user!;
    final success = await _attendanceService.submitAttendance(
      name: user.fullName,
      role: user.role.toString().split('.').last,
      status: type,
      lat: position.latitude.toString(),
      lng: position.longitude.toString(),
    );

    setState(() {
      _isLoading = false;
      _statusMessage = success ? 'Absensi $type Berhasil!' : 'Gagal mengirim absensi';
    });

    if (success) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Absensi Presensi')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 20),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    _buildAttendanceButton(
                      'ABSEN MASUK',
                      Icons.login,
                      Colors.green,
                      () => _processAttendance('Masuk'),
                    ),
                    const SizedBox(height: 15),
                    _buildAttendanceButton(
                      'ABSEN PULANG',
                      Icons.logout,
                      Colors.red,
                      () => _processAttendance('Pulang'),
                    ),
                    const SizedBox(height: 15),
                    _buildAttendanceButton(
                      'IZIN / SAKIT',
                      Icons.assignment_late,
                      Colors.orange,
                      () => _processAttendance('Izin'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
