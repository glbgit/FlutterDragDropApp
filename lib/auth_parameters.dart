// Authentication parameters
class AuthParameters {
  const AuthParameters({
    required this.email,
    required this.password,
    this.displayName,
  });

  final String email;
  final String password;
  final String? displayName;

  bool confirmPassword(String confirmation) {
    return password == confirmation;
  }
}

