import 'package:flutter/material.dart';

import '../../constants/pages_route.dart';
import '../../services/cloud/firebase_cloud_storage.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isSecurePassword = true; //new line(_isSecurePassword)
  final FirebaseCloudStorage c = FirebaseCloudStorage();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _password2;
  late final TextEditingController _phoneNum;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _password2 = TextEditingController();
    _phoneNum = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  Widget togglePassword() {
    //new widget (togglePassword)
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword
          ? const Icon(Icons.visibility)
          : const Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //change color to white
      body: Form(
        key: _formKey,
        child: Center(
          //create center widget
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200,
                    child: Image.asset('images/AirTours-5.png'), //change image
                  ), //delet text contain('AirTours')
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter email";
                        }
                        final emailRegex = RegExp(
                            r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
                        if (!emailRegex.hasMatch(value)) {
                          return "Enter a valid email";
                        }
                      },
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        border: InputBorder.none,
                        hintText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), //change height to 10
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, //change color to white
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter password";
                        }
                        // Add a check for the minimum length of the password
                        if (value.length < 6) {
                          return "Password must be at least 6 characters long";
                        }
                      },
                      //textAlign: TextAlign.center,
                      controller: _password,
                      obscureText: _isSecurePassword, //new line(obscureText)
                      decoration: InputDecoration(
                        border: InputBorder.none, //new line(border)
                        prefixIcon:
                            const Icon(Icons.key), //new line(prefixIcon)
                        hintText: 'Password',
                        suffixIcon: togglePassword(), //new line(suffixIcon)
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), //change height to 10
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, //change color to white
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter confirm password";
                        }
                      },
                      //textAlign: TextAlign.center,
                      controller: _password2,
                      obscureText: _isSecurePassword, //new line (obscureText)
                      decoration: InputDecoration(
                        border: InputBorder.none, //new line(border)
                        prefixIcon:
                            const Icon(Icons.key), //new line(prefixIcon)
                        hintText: 'Confirm Password',
                        suffixIcon: togglePassword(), //new line(suffixIcon)
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white, //change color to white
                        borderRadius: BorderRadius.circular(5)),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter phone number";
                        }

                        // Add a simple check for a valid phone number pattern
                        final phoneRegex = RegExp(r'^[0-9]{10}$');
                        if (!phoneRegex.hasMatch(value)) {
                          return "Enter a valid 10-digit phone number";
                        }
                      },
                      controller: _phoneNum,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone), //new line(prefixIcon)
                        border: InputBorder.none,
                        hintText: 'Phone Number',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 13, 213, 130),
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), //change height to 10
                  MyButton(
                      title: 'Register',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final email = _email.text;
                          final pass = _password.text;
                          final pass2 = _password2.text;
                          if (pass != pass2) {
                            showErrorDialog(context, "Password doesn't match!");
                          } else {
                            try {
                              await FirebaseAuthProvider.authService()
                                  .createUser(email: email, password: pass);

                              final String userId =
                                  FirebaseAuthProvider.authService()
                                      .currentUser!
                                      .id;
                              final String currentEmail =
                                  FirebaseAuthProvider.authService()
                                      .currentUser!
                                      .email;
                              c.createNewUser(
                                  ownerUserId: userId,
                                  email: currentEmail,
                                  phoneNum: '',
                                  balance: 0.0);
                              FirebaseAuthProvider.authService()
                                  .sendEmailVerification();
                              await Navigator.of(context)
                                  .pushNamed(verficationRoute);
                            } on WeakPasswordAuthException {
                              await showErrorDialog(context, 'Weak password');
                            } on EmailAlreadyInUseAuthException {
                              await showErrorDialog(
                                  context, 'Email already in use');
                            } on InvalidEmailAuthException {
                              await showErrorDialog(
                                  context, 'This is an invalid email');
                            } on GenericAuthException {
                              await showErrorDialog(
                                  context, 'Failed to register');
                            }
                          }
                        }
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already Registered?'),
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginRoute, (route) => false);
                          },
                          child: const Text('Login Here'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
