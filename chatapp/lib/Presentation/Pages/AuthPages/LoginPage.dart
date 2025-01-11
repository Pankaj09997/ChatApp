import 'package:chatapp/Presentation/StateManagement/bloc/AuthBloc/auth_bloc.dart';
import 'package:chatapp/Presentation/Widgets/Button.dart';
import 'package:chatapp/Presentation/Widgets/TextField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Error logging in")));
            } else if (state is NavigateToSignUpState) {
              Navigator.pushNamed(context, '/signup');
            } else if (state is AuthSuccess) {
              Navigator.pushNamed(context, '/profilepicture');
            } else if (state is NavigateToProfileState) {
              Navigator.pushNamed(context, '/profilepicture');
            }
          },
          child: Column(
            children: [
              CustomTextFormField(
                  controller: emailController,
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null) {
                      return "You cannot leave this field empty";
                    }
                  },
                  keyboardType: TextInputType.text),
              SizedBox(
                height: height * 0.01,
              ),
              CustomTextFormField(
                controller: passwordController,
                prefixIcon: Icons.password,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecureText = !obsecureText;
                      });
                    },
                    icon: obsecureText
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
                validator: (value) {
                  if (value == null) {
                    return "You cannot leave this field empty";
                  }
                },
                keyboardType: TextInputType.text,
                isPassword: obsecureText,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomButton(
                  text: "Login",
                  onTap: () {
                    context.read<AuthBloc>().add(AuthLoginEvent(
                        email: emailController.text,
                        password: passwordController.text));
                  }),
              SizedBox(
                height: height * 0.02,
              ),
              RichText(
                text: TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'SignUp',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.read<AuthBloc>().add(NavigateToSignUp());
                            })
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
