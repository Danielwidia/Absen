import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AttendanceService {
  // Replace with your Google Apps Script Web App URL
  static const String googleSheetUrl = 'https://script.google.com/macros/s/AKfycbwbiTqYpkE20FE8iTjoZ7mhNZNM1-YsUZfhqVrWeP_yn6Jw4vH5NTqi8IqWFjnYE2nm/exec';

  Future<bool> submitAttendance({
    required String name,
    required String role,
    required String status, // Masuk, Pulang, Izin
    required String lat,
    required String lng,
  }) async {
    try {
      // Menentukan nama sheet berdasarkan role untuk pemisahan laporan otomatis
      String sheetTarget = 'Karyawan'; // Default
      if (role.toLowerCase().contains('teacher') || role.toLowerCase() == 'guru') {
        sheetTarget = 'Guru';
      } else if (role.toLowerCase().contains('student') || role.toLowerCase() == 'siswa') {
        sheetTarget = 'Siswa';
      }

      final response = await http.post(
        Uri.parse(googleSheetUrl),
        body: {
          'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'nama': name,
          'role': role,
          'status': status,
          'lokasi': '$lat,$lng',
          'sheetName': sheetTarget, // Digunakan oleh Apps Script untuk memilih Sheet
        },
      );

      // Google Apps Script biasanya merespons dengan 302 (Redirect) atau 200 OK
      return response.statusCode == 302 || response.statusCode == 200;
    } catch (e) {
      print('Error submitting attendance: $e');
      return false;
    }
  }
}
