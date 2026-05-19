import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../services/biometric_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedDate;
  UserRole _selectedRole = UserRole.student;
  bool _faceRegistered = false;
  bool _isLoading = false;

  final BiometricService _biometricService = BiometricService();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _registerFace() async {
    setState(() => _isLoading = true);
    // Simulate FaceID registration using local_auth
    final success = await _biometricService.authenticate();
    setState(() {
      _isLoading = false;
      _faceRegistered = success;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('FaceID Berhasil Didaftarkan!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mendaftarkan FaceID. Silahkan coba lagi.')),
      );
    }
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih Tanggal Lahir')));
      return;
    }
    if (!_faceRegistered) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silahkan daftarkan FaceID terlebih dahulu')));
      return;
    }

    setState(() => _isLoading = true);

    final newUser = UserModel(
      id: '', // Will be generated
      username: _usernameController.text,
      fullName: _fullNameController.text,
      role: _selectedRole,
      placeOfBirth: _placeOfBirthController.text,
      dateOfBirth: _selectedDate,
      address: _addressController.text,
      hasFaceRegistered: true,
    );

    final success = await context.read<AuthProvider>().register(newUser, _passwordController.text);

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi Berhasil! Silahkan Login.')));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_fullNameController, 'Nama Lengkap', Icons.person),
              const SizedBox(height: 15),
              _buildTextField(_usernameController, 'Username', Icons.badge),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildTextField(_placeOfBirthController, 'Tempat Lahir', Icons.location_city)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Tanggal Lahir',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: Text(
                          _selectedDate == null ? 'Pilih' : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildTextField(_passwordController, 'Password', Icons.lock, obscure: true),
              const SizedBox(height: 15),
              _buildTextField(_addressController, 'Alamat', Icons.home, maxLines: 2),
              const SizedBox(height: 15),
              const Text('Jenis Akun', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(value: UserRole.teacher, child: Text('Guru')),
                  DropdownMenuItem(value: UserRole.staff, child: Text('Karyawan')),
                  DropdownMenuItem(value: UserRole.student, child: Text('Siswa')),
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 30),
              const Text('Keamanan', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _registerFace,
                  icon: Icon(_faceRegistered ? Icons.check_circle : Icons.face, color: _faceRegistered ? Colors.green : primaryColor),
                  label: Text(_faceRegistered ? 'FaceID Terdaftar' : 'Daftarkan FaceID'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('DAFTAR SEKARANG', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
    );
  }
}
