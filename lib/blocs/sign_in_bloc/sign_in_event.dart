part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends SignInEvent {
  final String email;
  final String password;

  const SignIn(this.email, this.password);
}

class SignOut extends SignInEvent {
  const SignOut();
}
