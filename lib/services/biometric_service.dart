import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
// Hapus import platform-specific yang menyebabkan error di Web

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    // Di Web, biometrik biasanya tidak didukung melalui local_auth secara langsung
    // atau membutuhkan konfigurasi HTTPS yang sangat ketat.
    if (kIsWeb) {
      debugPrint('Biometric authentication is not fully supported on Web. Skipping...');
      return true; // Berikan akses atau ganti dengan password check
    }

    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) return false;

      return await auth.authenticate(
        localizedReason: 'Silahkan verifikasi identitas Anda untuk absensi',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        // Gunakan pesan default yang aman untuk semua platform
      );
    } catch (e) {
      debugPrint('Error during biometric auth: $e');
      return false;
    }
  }
}
