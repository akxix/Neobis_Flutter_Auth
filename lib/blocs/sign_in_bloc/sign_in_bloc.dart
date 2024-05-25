import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../src/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignInInitial()) {
    on<SignIn>(signIn);
    on<SignOut>(signOut);
  }

  void signIn(
    SignIn event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInProcess());
    try {
      await _userRepository.signIn(event.email, event.password);
      emit(
        SignInSuccess(),
      );
    } catch (e) {
      print('Error during sign in: $e');
      emit(
        const SignInFailure(),
      );
    }
  }

  void signOut(SignOut event, Emitter<SignInState> emit) async {
    await _userRepository.signOut();
  }
}
