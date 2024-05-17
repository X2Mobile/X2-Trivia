import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/screen/login/bloc/login_event.dart';
import 'package:x2trivia/app/screen/login/bloc/login_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/data/exceptions/login_exceptions.dart';

import '../../../../domain/repositories/user_repository.dart';
import '../../../../gen/assets.gen.dart';
import '../../home/view/home_page.dart';
import '../../register/view/register_page.dart';
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

  final _emailController = TextEditingController();
  // todo adauga un controller pentru field ul de password

  @override
  void initState() {
    super.initState();
    loginBloc = context.read<LoginBloc>();
  }

  //todo adauga event ul la bloc
  void _onLogIn(String email, String password) {}

  void _onObscureTextTap() => loginBloc.add(const LoginObscureText());

  //todo navigheaza la urmatorul ecran
  void _onCreateAccount() {}

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.of(context, rootNavigator: true).pushReplacement(HomePage.route(userDisplayName: state.user.displayName));
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
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          bottom: false,
          minimum: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              headerImage(),
              ...loginForm(),
              loginButton(),
              createAccount(),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerImage() => const Padding(
        padding: EdgeInsets.only(top: 120, bottom: 60),
        //todo adauga logo ul aplicatiei
        child: SizedBox.shrink(),
      );

  List<Widget> loginForm() => [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: context.strings.email,
            ),
          ),
        ),
        BlocBuilder<LoginBloc, LoginState>(
          builder: (_, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                //todo adauga un controller
                controller: null,
                //todo ascunde parola
                obscureText: false,
                decoration: InputDecoration(
                  //todo adauga un hint
                  //todo adauga un suffix icon acestui field
                ),
              ),
            );
          },
        ),
        BlocBuilder<LoginBloc, LoginState>(
          builder: (_, state) {
            if (state is LoginLoadingState) {
              return const LinearProgressIndicator(value: null);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ];

  //todo widget ul de create account
  Widget createAccount() => const SizedBox.shrink();

  Widget loginButton() => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FilledButton(
                //todo apeleaza metoda de login
                onPressed: (){},
                child: Text(context.strings.login),
              ),
            ),
          ),
        ],
      );
}
