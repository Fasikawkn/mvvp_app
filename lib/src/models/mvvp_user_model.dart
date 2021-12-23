class MvvpUser {
  final int id;
  final String username;
  final String phone;

  MvvpUser({
    required this.id,
    required this.phone,
    required this.username,
  });

  factory MvvpUser.fromJson(Map<String, dynamic> json) {
    return MvvpUser(
      id: json['id'],
      phone: json['phone'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'username': username,
      'phone': phone,
    };
  }
}
