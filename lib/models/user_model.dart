enum UserRole { admin, teacher, staff, student }

class UserModel {
  final String id;
  final String username;
  final String fullName;
  final UserRole role;
  final String? placeOfBirth;
  final DateTime? dateOfBirth;
  final String? address;
  final bool hasFaceRegistered;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.placeOfBirth,
    this.dateOfBirth,
    this.address,
    this.hasFaceRegistered = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'full_name': fullName,
      'role': role.toString().split('.').last,
      'place_of_birth': placeOfBirth,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'address': address,
      'has_face_registered': hasFaceRegistered,
    };
  }

factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    id: map['id'].toString(),
    username: map['username'],
    fullName: map['full_name'],
    // Tambahkan mapping jika nama di DB berbeda dengan nama di Enum
    role: UserRole.values.firstWhere(
      (e) {
        String roleInDb = map['role'].toString().toLowerCase();
        if (roleInDb == 'guru') roleInDb = 'teacher'; // Mapping manual
        return e.toString().split('.').last == roleInDb;
      },
      orElse: () => UserRole.student,
    ),
    // ... rest of fields
  );
}
