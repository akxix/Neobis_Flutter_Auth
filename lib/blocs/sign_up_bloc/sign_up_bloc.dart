import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../src/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpInitial()) {
    on<SignUpRequired>(_signUp);
  }

  void _signUp(SignUpRequired event, Emitter<SignUpState> emit) async {
    emit(SignUpProcess());
    try {
      await _userRepository.signUp(event.user, event.password);

      emit(SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure());
    }
  }
}
