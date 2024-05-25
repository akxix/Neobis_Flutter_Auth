import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../src/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<MyUser?> _userSubscription;

  AuthenticationBloc({required this.userRepository})
      : super(
          const AuthenticationState.unknown(),
        ) {
    _userSubscription = userRepository.user.listen((MyUser? user) {
      add(
        AuthenticationUserChanged(user),
      );
    });

    on<AuthenticationUserChanged>(_authUserChanged);
  }

  void _authUserChanged(
      AuthenticationUserChanged event, Emitter<AuthenticationState> emit) {
    if (event.user != null) {
      emit(
        AuthenticationState.authenticated(event.user!),
      );
    } else {
      emit(
        const AuthenticationState.unauthenticated(),
      );
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
