class User {
  final int idusr;
  final String nameusr;
  final String codeusr;
  final bool rol;

  User({required this.idusr, required this.nameusr, required this.codeusr, required this.rol});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idusr: json['idusr'],
      nameusr: json['nameusr'],
      codeusr: json['codeusr'],
      rol: json['rol'],
    );
  }
}
