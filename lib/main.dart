import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_alisons/blocs/home/home_bloc.dart';
import 'package:machine_test_alisons/blocs/category/category_bloc.dart';
import 'package:machine_test_alisons/blocs/cart/cart_bloc.dart';
import 'package:machine_test_alisons/blocs/profile/profile_bloc.dart';
import 'package:machine_test_alisons/screens/main_screen.dart';
import 'package:machine_test_alisons/screens/login_page.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(CheckAuthStatus())),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => CategoryBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Machine Test',
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated || state is AuthSkipped) {
              return const MainScreen();
            }
            if (state is Unauthenticated || state is AuthError) {
              return const LoginScreen();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
