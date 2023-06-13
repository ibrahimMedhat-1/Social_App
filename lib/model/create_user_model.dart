class CreateUserModel {
  String? name;
  String? email;
  String? phone;
  String? profileImage;
  String? coverImage;
  String? bio;
  String? id;

  CreateUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.coverImage,
    required this.bio,
    required this.id,
  });

  CreateUserModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    email = json['email'];
    phone = json['phone'];
    profileImage = json['profileImage'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    id = json['id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'bio': bio,
      'id': id,
    };
  }
}
