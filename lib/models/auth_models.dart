class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class SignupRequest {
  final String email;
  final String password;

  SignupRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class UserResponse {
  final String id;
  final String email;
  final String accessToken;

  UserResponse({
    required this.id,
    required this.email,
    required this.accessToken,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      email: json['email'],
      accessToken: json['access_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'access_token': accessToken};
  }
}

class User {
  final String id;
  final String email;

  User({required this.id, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email};
  }
}
