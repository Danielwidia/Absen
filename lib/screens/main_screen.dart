import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user_model.dart';
import 'login_screen.dart';
import 'attendance_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      _showLogoutDialog();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const LoginScreen();

    final List<Widget> pages = [
      HomeContent(user: user),
      ProfileContent(user: user),
      const SizedBox(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.logout_rounded), label: 'Logout'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final UserModel user;
  const HomeContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final greeting = context.read<AuthProvider>().getGreeting();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Menu Utama',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate(_getMenuItems(context, user.role)),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  List<Widget> _getMenuItems(BuildContext context, UserRole role) {
    switch (role) {
      case UserRole.student:
        return [
          _buildMenuCard(context, 'Absensi', Icons.fingerprint_rounded, Colors.blue, const AttendanceScreen()),
          _buildMenuCard(context, 'Jadwal Kelas', Icons.calendar_today_rounded, Colors.orange, null),
          _buildMenuCard(context, 'Jadwal Piket', Icons.cleaning_services_rounded, Colors.green, null),
          _buildMenuCard(context, 'Struktur Kelas', Icons.account_tree_rounded, Colors.purple, null),
          _buildMenuCard(context, 'Soal Online', Icons.quiz_rounded, Colors.red, null),
          _buildMenuCard(context, 'Jurnal Kelas', Icons.book_rounded, Colors.teal, null),
        ];
      case UserRole.teacher:
        return [
          _buildMenuCard(context, 'Absensi', Icons.fingerprint_rounded, Colors.blue, const AttendanceScreen()),
          _buildMenuCard(context, 'Jadwal Global', Icons.public_rounded, Colors.indigo, null),
          _buildMenuCard(context, 'Jadwal Mengajar', Icons.menu_book_rounded, Colors.orange, null),
          _buildMenuCard(context, 'Manageman Soal', Icons.edit_note_rounded, Colors.red, null),
          _buildMenuCard(context, 'Jurnal Guru', Icons.history_edu_rounded, Colors.teal, null),
          _buildMenuCard(context, 'AI Soal', Icons.auto_awesome_rounded, Colors.amber, null),
          _buildMenuCard(context, 'Penilaian', Icons.grade_rounded, Colors.green, null),
          _buildMenuCard(context, 'Materi', Icons.library_books_rounded, Colors.brown, null),
        ];
      case UserRole.staff:
        return [
          _buildMenuCard(context, 'Absensi', Icons.fingerprint_rounded, Colors.blue, const AttendanceScreen()),
          _buildMenuCard(context, 'Tugas Harian', Icons.assignment_turned_in_rounded, Colors.orange, null),
          _buildMenuCard(context, 'Laporan Kerja', Icons.description_rounded, Colors.teal, null),
          _buildMenuCard(context, 'Inventaris', Icons.inventory_2_rounded, Colors.indigo, null),
          _buildMenuCard(context, 'Pengumuman', Icons.campaign_rounded, Colors.red, null),
        ];
      case UserRole.admin:
        return [
          _buildMenuCard(context, 'Kelola Absensi', Icons.assignment_rounded, Colors.blue, null),
          _buildMenuCard(context, 'Kelola Jadwal', Icons.event_note_rounded, Colors.orange, null),
          _buildMenuCard(context, 'Akun Guru', Icons.supervisor_account_rounded, Colors.indigo, null),
          _buildMenuCard(context, 'Akun Siswa', Icons.people_rounded, Colors.teal, null),
          _buildMenuCard(context, 'Bank Soal', Icons.storage_rounded, Colors.red, null),
          _buildMenuCard(context, 'Jadwal Ujian', Icons.timer_rounded, Colors.purple, null),
        ];
    }
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, Widget? destination) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (destination != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fitur $title segera hadir!')),
              );
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final UserModel user;
  const ProfileContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(Icons.person, size: 60, color: Theme.of(context).primaryColor),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _buildProfileTile(Icons.person_outline, 'Nama Lengkap', user.fullName),
            _buildProfileTile(Icons.badge_outlined, 'Username', user.username),
            _buildProfileTile(Icons.lock_person_outlined, 'Role', user.role.toString().split('.').last.toUpperCase()),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('EDIT DATA DIRI', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
