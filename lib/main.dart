import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_screen.dart';
import './screens/auth/welcome_screen.dart';
import './blocs/authentication_bloc/authentication_bloc.dart';
import './blocs/sign_in_bloc/sign_in_bloc.dart';
import './simple_bloc_observer.dart';
import './src/sp_user_repository.dart';
import './src/user_repo.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MyApp(
      SharedPrefUserRepo(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(userRepository: userRepository),
        child: MaterialApp(
          title: 'SharedPreferences Auth',
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state.status == AuthenticationStatus.authenticated) {
                return BlocProvider(
                  create: (context) => SignInBloc(
                      userRepository:
                          context.read<AuthenticationBloc>().userRepository),
                  child: const HomeScreen(),
                );
              } else {
                return const WelcomeScreen();
              }
            },
          ),
        ));
  }
}
