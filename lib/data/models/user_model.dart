class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? image;
  final String? phone;
  final String? gender;

  const UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
    this.phone,
    this.gender,
  });

  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int,
    username: json['username'] as String? ?? '',
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    image: json['image'] as String?,
    phone: json['phone'] as String?,
    gender: json['gender'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'image': image,
    'phone': phone,
    'gender': gender,
  };

  UserModel copyWith({
    int? id,
    String? username,
    String? firstName,
    String? lastName,
    String? email,
    String? image,
    String? phone,
    String? gender,
  }) => UserModel(
    id: id ?? this.id,
    username: username ?? this.username,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    image: image ?? this.image,
    phone: phone ?? this.phone,
    gender: gender ?? this.gender,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// DummyJSON login response structure:
// { id, username, email, firstName, lastName, gender, image, accessToken, refreshToken }
class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    user: UserModel.fromJson(json),
  );
}
