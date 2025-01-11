class UserProfileEntities {
  final int ?id;
  final String? email;
  final String? name;
  final bool? is_active;
  final DateTime? last_login;

  UserProfileEntities(
      {required this.id,
      required this.email,
      required this.name,
      required this.is_active,
      required this.last_login});
}
