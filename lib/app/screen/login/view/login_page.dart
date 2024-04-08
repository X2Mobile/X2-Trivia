import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/screen/login/bloc/login_event.dart';
import 'package:x2trivia/app/screen/login/bloc/login_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/data/exceptions/login_exceptions.dart';

import '../../../../domain/repositories/user_repository.dart';
import '../../home/view/home_page.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LoginBloc(
            userRepository: context.read<UserRepository>(),
          ),
          child: const LoginPageView(),
        ),
      );

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

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  fieldPadding() => const EdgeInsets.symmetric(vertical: 8.0);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is SuccessLoginState) {
            Navigator.of(context, rootNavigator: true).pushReplacement(HomePage.route(user: state.user!.displayName));
          }
          if (state is ErrorLoginState) {
            Fluttertoast.showToast(
              msg: state.exception!.getMessage(context),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: context.strings.name,
                          ),
                          controller: nameController),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: context.strings.email,
                          ),
                          controller: emailController),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: context.strings.password,
                          ),
                          controller: passwordController),
                    ],
                  ),
                ),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (_, state) {
                    if (state.loading == true) {
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
                        child: ElevatedButton(
                          onPressed: () => loginBloc.add(Register(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text)),
                          child: Text(context.strings.register),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () =>
                              loginBloc.add(Login(email: emailController.text, password: passwordController.text)),
                          child: Text(context.strings.login),
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
