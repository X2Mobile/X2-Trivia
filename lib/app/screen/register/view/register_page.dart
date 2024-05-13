import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/data/exceptions/login_exceptions.dart';

import '../../../../domain/repositories/user_repository.dart';
import '../../../../gen/assets.gen.dart';
import '../../home/view/home_page.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (context) => const RegisterPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const RegisterPageView(),
    );
  }
}

class RegisterPageView extends StatefulWidget {
  const RegisterPageView({super.key});

  @override
  State<RegisterPageView> createState() => _RegisterPageViewState();
}

class _RegisterPageViewState extends State<RegisterPageView> {
  late final RegisterBloc _registerBloc;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _registerBloc = context.read<RegisterBloc>();
  }

  void _onRegister(String displayName, String email, String password) => _registerBloc.add(Register(name: displayName, email: email, password: password));

  void _onObscureTextTap() => _registerBloc.add(const RegisterObscureText());

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          Navigator.of(context, rootNavigator: true).pushReplacement(HomePage.route(userDisplayName: state.user.displayName));
        }
        if (state is RegisterErrorState) {
          Fluttertoast.showToast(
            msg: state.exception.getMessage(context),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Scaffold(
        appBar: appBar(),
        body: SafeArea(
          bottom: false,
          minimum: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                headerImage(),
                ...registerForm(),
                registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget appBar() => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
    title: Text(context.strings.createAccount),
      );

  Widget headerImage() => Padding(
        padding: const EdgeInsets.only(top: 120, bottom: 60),
        child: SvgPicture.asset(Assets.icons.x2logo),
      );

  List<Widget> registerForm() => [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: context.strings.name,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: context.strings.email,
            ),
          ),
        ),
        BlocBuilder<RegisterBloc, RegisterState>(
          builder: (_, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _passwordController,
                obscureText: !state.isPasswordVisible,
                decoration: InputDecoration(
                  labelText: context.strings.password,
                  suffixIcon: IconButton(
                    icon: Icon(state.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: _onObscureTextTap,
                  ),
                ),
              ),
            );
          },
        ),
        BlocBuilder<RegisterBloc, RegisterState>(
          builder: (_, state) {
            if (state is RegisterLoadingState) {
              return const LinearProgressIndicator(value: null);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ];

  Widget registerButton() => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FilledButton(
                onPressed: () => _onRegister(_nameController.text, _emailController.text, _passwordController.text),
                child: Text(context.strings.createAccount),
              ),
            ),
          ),
        ],
      );
}
