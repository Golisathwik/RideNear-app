class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String age;
  final String imageUrl;

  const UserProfile({
    required this.id,
    this.name = 'John Doe',
    this.email = 'john.doe@example.com',
    this.phone = '+91 9876543210',
    this.age = '28',
    this.imageUrl = 'https://i.pravatar.cc/150?u=a042581f4e29026024d',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json, String id) {
    return UserProfile(
      id: id,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://i.pravatar.cc/150',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'imageUrl': imageUrl,
    };
  }
}
