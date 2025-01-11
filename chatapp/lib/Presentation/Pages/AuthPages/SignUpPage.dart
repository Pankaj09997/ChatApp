import 'package:chatapp/Presentation/Pages/AuthPages/LoginPage.dart';
import 'package:chatapp/Presentation/StateManagement/bloc/AuthBloc/auth_bloc.dart';
import 'package:chatapp/Presentation/Widgets/Button.dart';
import 'package:chatapp/Presentation/Widgets/TextField.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassowrd = TextEditingController();
  bool obsecureText = true;
  bool obsecureText1 = true;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("SignUp"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is NavigateToLoginState) {
                Navigator.pop(context);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)));
              } else if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("User have been successfully registered")));
              } else if (state is NavigateToLoginState) {
                Navigator.pushNamed(context, '/');
              }
            },
            child: Column(
              children: [
                CustomTextFormField(
                    controller: emailController,
                    hintText: "Enter your email",
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value == null) {
                        return "You cannot leave this field empty";
                      }
                    },
                    keyboardType: TextInputType.text),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomTextFormField(
                    controller: nameController,
                    hintText: "Enter your name",
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "You cannot leave this field empty";
                      }
                    },
                    keyboardType: TextInputType.text),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: "Enter your password",
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
                    if (value == null || value.trim().isEmpty) {
                      return "You cannot leave this field empty";
                    } else if (value != confirmPassowrd.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password donot match")));
                    }
                  },
                  keyboardType: TextInputType.text,
                  isPassword: obsecureText,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                CustomTextFormField(
                  controller: confirmPassowrd,
                  prefixIcon: Icons.password,
                  hintText: "Confirm your password",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecureText1 = !obsecureText1;
                        });
                      },
                      icon: obsecureText1
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "You cannot leave this field empty";
                    }
                  },
                  keyboardType: TextInputType.text,
                  isPassword: obsecureText1,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return CircularProgressIndicator();
                    } else {
                      return CustomButton(
                          text: "Signup",
                          onTap: () {
                            context.read<AuthBloc>().add(AuthSignUpEvent(
                                email: emailController.text,
                                name: nameController.text,
                                password: passwordController.text,
                                password2: confirmPassowrd.text));
                          });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
