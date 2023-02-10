class UserModel {
  String? fullName;
  String? email;
  String? password;
  bool isValid;

  UserModel({
    this.fullName,
    this.email,
    this.password,
    this.isValid = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      fullName: data['full_name'],
      email: data['email'],
      password: data['password'],
      isValid: data['is_valid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'password': password,
      'is_valid': isValid,
    };
  }
}
