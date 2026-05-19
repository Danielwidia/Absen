import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    if (!canAuthenticate) return false;

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Silahkan verifikasi identitas Anda untuk absensi',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Otentikasi Biometrik',
            biometricHint: 'Gunakan Wajah atau Sidik Jari',
          ),
          IOSAuthMessages(
            cancelButton: 'Batal',
          ),
        ],
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
