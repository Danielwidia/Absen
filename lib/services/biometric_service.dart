import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  // Gunakan late agar tidak langsung diinisialisasi di Web untuk menghindari crash
  late final LocalAuthentication auth;

  BiometricService() {
    if (!kIsWeb) {
      auth = LocalAuthentication();
    }
  }

  Future<bool> authenticate() async {
    // Di Web, local_auth tidak didukung secara native, kembalikan true untuk simulasi
    if (kIsWeb) {
      debugPrint('Biometric authentication is not supported on Web. Simulating success...');
      return true;
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
      );
    } catch (e) {
      debugPrint('Error during biometric auth: $e');
      return false;
    }
  }
}
