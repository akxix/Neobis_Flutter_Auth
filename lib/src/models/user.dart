import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String email;
  final String password;

  const MyUser({
    required this.email,
    required this.password,
  });

  static const empty = MyUser(
    email: '',
    password: '',
  );

  MyUser copyWith({
    String? email,
    String? password,
  }) {
    return MyUser(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  MyUser.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

  @override
  List<Object?> get props => [email, password];
}
