import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:to_do_copy/features/authentication/widgets/custom_loader.dart';

import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_firestore_service.dart';
import '../widgets/custom_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                    getVerticalSpacing(height: 30),
                    CustomFormField(
                      hintText: 'Name',
                      iconData: Icons.account_circle_outlined,
                      controller: nameController,
                      validator: (val) {
                        if (val == null) {
                          return 'Name is required';
                        }
                        if (val.isEmpty) {
                          return 'Name must not be empty';
                        }
                        if (val.length < 3) {
                          return 'Name length must be greater than 3';
                        }
                        return null;
                      },
                    ),
                    getVerticalSpacing(),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value ?? false;
                              });
                            },
                            checkColor: Colors.deepPurpleAccent,
                            fillColor: MaterialStateProperty.all(
                              Colors.transparent,
                            ),
                            side: BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                            overlayColor: MaterialStateProperty.all(
                              Colors.deepPurpleAccent.withOpacity(
                                0.4,
                              ),
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'I read and agree to ',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Terms & Condition',
                                  style: TextStyle(
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      print('terms and condition clicked');
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        onPressed: () async {
                          formKey.currentState?.save();
                          if (formKey.currentState!.validate()) {
                            if (!isChecked) {
                              print('terms and condition not agreed');
                            }
                            print('valid');
                            final name = nameController.text;
                            final email = emailController.text;
                            final password = passwordController.text;
                            print('name: $name');
                            print('email: $email');
                            // print('password: $password');
                            // final userCred = await firebaseAuthService.signInUser(
                            //   email: email,
                            //   password: password,
                            // );

                            // print('user logout; ${userCred.user!.uid}');
                            UserModel user = UserModel(
                              fullName: name,
                              email: email,
                              password: password,
                              isValid: isChecked,
                            );
                            CustomLoader.showMyLoader(context);
                            final userCredential = await firebaseAuthService
                                .registerUser(email: email, password: password);
                            await firebaseFirestoreService.storeUser(user);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Builder(builder: (context) {
                                  return Text(
                                    "registered succesfullty",
                                    style: TextStyle(
                                        color: Colors.deepPurpleAccent),
                                  );
                                }),
                                backgroundColor: Colors.white,
                              ),
                            );

                            print('user detail:$userCredential  ');
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            print('not valid');
                          }
                        },
                        child: Text(
                          'CREATE ACCOUNT',
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
                        text: 'Already have and account? ',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('sign in clicked');
                                Navigator.pushNamed(context, '/login');
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
}
