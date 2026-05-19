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
      id: map['id'],
      username: map['username'],
      fullName: map['full_name'],
      role: UserRole.values.firstWhere((e) => e.toString().split('.').last == map['role']),
      placeOfBirth: map['place_of_birth'],
      dateOfBirth: map['date_of_birth'] != null ? DateTime.parse(map['date_of_birth']) : null,
      address: map['address'],
      hasFaceRegistered: map['has_face_registered'] ?? false,
    );
  }
}
