class User {
  String name;
  String email;
  bool isDarkMode;

  User({required this.name, required this.email, this.isDarkMode = false});

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'isDarkMode': isDarkMode,
  };

  factory User.fromMap(Map<String, dynamic> map) => User(
    name: map['name'],
    email: map['email'],
    isDarkMode: map['isDarkMode'] ?? false,
  );
}