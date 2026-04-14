class UserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? image;
  final String? phone;
  final String? gender;
  final String? birthDate;
  final int? age;

  // Address
  final String? addressStreet;
  final String? addressCity;
  final String? addressState;
  final String? addressCountry;

  // Company
  final String? companyName;
  final String? companyDepartment;
  final String? companyTitle;

  // Extra
  final String? university;
  final String? role;

  const UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.image,
    this.phone,
    this.gender,
    this.birthDate,
    this.age,
    this.addressStreet,
    this.addressCity,
    this.addressState,
    this.addressCountry,
    this.companyName,
    this.companyDepartment,
    this.companyTitle,
    this.university,
    this.role,
  });

  String get fullName => '$firstName $lastName';

  String get fullAddress {
    final parts = [
      addressStreet,
      addressCity,
      addressState,
      addressCountry,
    ].where((e) => e != null && e.isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(', ') : '-';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>?;
    final company = json['company'] as Map<String, dynamic>?;
    // final companyAddress = company?['address'] as Map<String, dynamic>?;

    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      image: json['image'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      birthDate: json['birthDate'] as String?,
      age: json['age'] as int?,
      addressStreet: address?['address'] as String?,
      addressCity: address?['city'] as String?,
      addressState: address?['state'] as String?,
      addressCountry: address?['country'] as String?,
      companyName: company?['name'] as String?,
      companyDepartment: company?['department'] as String?,
      companyTitle: company?['title'] as String?,
      university: json['university'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'image': image,
    'phone': phone,
    'gender': gender,
    'birthDate': birthDate,
    'age': age,
    'addressStreet': addressStreet,
    'addressCity': addressCity,
    'addressState': addressState,
    'addressCountry': addressCountry,
    'companyName': companyName,
    'companyDepartment': companyDepartment,
    'companyTitle': companyTitle,
    'university': university,
    'role': role,
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
    String? birthDate,
    int? age,
    String? addressStreet,
    String? addressCity,
    String? addressState,
    String? addressCountry,
    String? companyName,
    String? companyDepartment,
    String? companyTitle,
    String? university,
    String? role,
  }) => UserModel(
    id: id ?? this.id,
    username: username ?? this.username,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    image: image ?? this.image,
    phone: phone ?? this.phone,
    gender: gender ?? this.gender,
    birthDate: birthDate ?? this.birthDate,
    age: age ?? this.age,
    addressStreet: addressStreet ?? this.addressStreet,
    addressCity: addressCity ?? this.addressCity,
    addressState: addressState ?? this.addressState,
    addressCountry: addressCountry ?? this.addressCountry,
    companyName: companyName ?? this.companyName,
    companyDepartment: companyDepartment ?? this.companyDepartment,
    companyTitle: companyTitle ?? this.companyTitle,
    university: university ?? this.university,
    role: role ?? this.role,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

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
