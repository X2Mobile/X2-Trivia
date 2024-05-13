import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/components/buttons/action_button.dart';
import 'package:x2trivia/app/components/buttons/input_text_field.dart';
import 'package:x2trivia/app/screen/login/bloc/login_event.dart';
import 'package:x2trivia/app/screen/login/bloc/login_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/data/exceptions/login_exceptions.dart';

import '../../../../domain/repositories/user_repository.dart';
import '../../home/view/home_page.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (context) => const LoginPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const LoginPageView(),
    );
  }
}

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key});

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  late final LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = context.read<LoginBloc>();
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLogIn(String email, String password) {
    loginBloc.add(Login(email: email, password: password));
  }

  void _onRegister(String name, String email, String password) {
    loginBloc.add(Register(name: name, email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.of(context, rootNavigator: true).pushReplacement(HomePage.route(user: state.user.displayName));
          }
          if (state is LoginErrorState) {
            Fluttertoast.showToast(
              msg: state.exception.getMessage(context),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.strings.loginPage),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputTextField(
                    controller: _nameController,
                    label: context.strings.name,
                    hint: context.strings.name,
                    isPassword: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputTextField(
                    controller: _emailController,
                    label: context.strings.email,
                    hint: context.strings.email,
                    isPassword: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InputTextField(
                    controller: _passwordController,
                    label: context.strings.password,
                    hint: context.strings.password,
                    isPassword: true,
                  ),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (_, state) {
                    if (state is LoginLoadingState) {
                      return const LinearProgressIndicator(
                        value: null,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ActionButton(
                          onPressed: () =>
                              _onRegister(_nameController.text, _emailController.text, _passwordController.text),
                          text: context.strings.register,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ActionButton(
                          onPressed: () => _onLogIn(_emailController.text, _passwordController.text),
                          text: context.strings.login,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
