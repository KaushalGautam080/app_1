import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firebase_auth_service.dart';
import '../services/firebase_firestore_service.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_loader.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget getVerticalSpacing({double? height}) => SizedBox(
        height: height ?? 20,
      );
  bool obscureText = true;
  bool isChecked = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final firebaseAuthService = FirebaseAuthService();
  final firebaseFirestoreService = FirebaseFirestoreService();

  String? emailValidator(String? email) {
    if (email == null) {
      return 'Email is required';
    }
    if (email.isEmpty) {
      return 'Email must not be empty';
    }
    if (email.contains('@') & email.contains('.')) {
      return null;
    } else {
      return 'Email is invalid';
    }
  }

  String? passwordValidator(String? password) {
    if (password == null) {
      return 'Password is required';
    }
    if (password.isEmpty) {
      return 'Password must not be empty';
    }
    if (password.length >= 6) {
      return null;
    } else {
      return 'Password must be of length 6 or more';
    }
  }

  Future<void> login() async {
    formKey.currentState?.save();
    if (formKey.currentState!.validate()) {
      try {
        print('valid');
        final name = nameController.text;
        final email = emailController.text;
        final password = passwordController.text;
        print('name: $name');
        print('email: $email');
        // print('password: $password');

        // print('user logout; ${userCred.user!.uid}');

        CustomLoader.showMyLoader(context);
        final userCred = await firebaseAuthService.signInUser(
          email: email,
          password: password,
        );

        Navigator.pop(context);
        final isEmailVerified = userCred.user!.emailVerified;
        print("is email verified : $isEmailVerified");
        if (!isEmailVerified) {
          await userCred.user!.sendEmailVerification();
          showSnackBar(
              message: 'Your email is not verified,please verify your email. ',
              context: context,
              backgroundColor: Colors.white);
          return;
        }

        SharedPreferences sp = await SharedPreferences.getInstance();
        final token = await userCred.user!.getIdToken();
        print('token:$token');
        sp.setString('Token', token);
        final data = Jwt.parseJwt(token);

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } on FirebaseAuthException catch (e) {
        print('firebase exception :${e.message}');
        Navigator.pop(context);
      }
    } else {
      print('not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Container(
            height: 540,
            width: 500,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    getVerticalSpacing(height: 30),
                    CustomFormField(
                      hintText: 'E-Mail',
                      iconData: Icons.mail,
                      inputType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: emailValidator,
                    ),
                    getVerticalSpacing(),
                    CustomFormField(
                      hintText: 'Password',
                      iconData: Icons.key_outlined,
                      obscureText: obscureText,
                      controller: passwordController,
                      onPressedEye: () {
                        print('eye pressed');
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      validator: passwordValidator,
                    ),
                    getVerticalSpacing(),
                    getVerticalSpacing(
                      height: 30,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purpleAccent,
                            Colors.indigoAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: MaterialButton(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 30,
                        ),
                        onPressed: login,
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        splashColor: Colors.white.withOpacity(
                          0.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            40,
                          ),
                        ),
                      ),
                    ),
                    getVerticalSpacing(
                      height: 20,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Haven\'t Registered yet? ',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Register clicked');
                                Navigator.pushNamed(context, '/register');
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(
      {required String message,
      required BuildContext context,
      Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Builder(builder: (context) {
          return Text(
            "Login succesfullty",
            style: TextStyle(color: Colors.deepPurpleAccent),
          );
        }),
        backgroundColor: backgroundColor ?? Colors.white,
      ),
    );
  }
}
