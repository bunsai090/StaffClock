class UserModel {
  final String id;
  final String name;
  final String email;
  final String? position;
  final String? photoUrl;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.position,
    this.photoUrl,
  });
  
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      position: map['position'],
      photoUrl: map['photoUrl'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'position': position,
      'photoUrl': photoUrl,
    };
  }
}

