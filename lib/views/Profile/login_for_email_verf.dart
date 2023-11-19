import 'package:AirTours/constants/pages_route.dart';
import 'package:flutter/material.dart';
import '../../services_auth/auth_exceptions.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../../utilities/show_error.dart';

class LoginForEmailChanges extends StatefulWidget {
  const LoginForEmailChanges({super.key});

  @override
  State<LoginForEmailChanges> createState() => _LoginForEmailChangesState();
}

class _LoginForEmailChangesState extends State<LoginForEmailChanges> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isSecurePassword = true; //new line(_isSecurePassword)

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
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
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 13, 213, 130), //change color to green
        title: const Text('Login To Verify It Is You'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              //new line (container and all of it is inside)
              width: double.infinity,
              margin: const EdgeInsets.only(left: 8, right: 8), //0
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(blurRadius: 2, offset: Offset(0, 0))
              ], borderRadius: BorderRadius.circular(13), color: Colors.white),
              child: TextField(
                controller: _email,
                decoration: const InputDecoration(
                  //labelText: 'Your Email',
                  prefixIcon: Icon(Icons.mail), //new line(prefixIcon)
                  border: InputBorder.none, //new line(border)
                  hintText: "Email", //new line (hintText)
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              //new line (container and all of it is inside)
              width: double.infinity,
              margin: const EdgeInsets.only(left: 8, right: 8), //0
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(blurRadius: 2, offset: Offset(0, 0))
              ], borderRadius: BorderRadius.circular(13), color: Colors.white),
              child: TextField(
                controller: _password,
                obscureText: _isSecurePassword, //new line (obscureText)
                decoration: InputDecoration(
                  border: InputBorder.none, //new line(border)
                  prefixIcon: const Icon(Icons.lock), //new line(prefixIcon)
                  //labelText: 'Your Password',
                  hintText: "Password", //new line(hintText)
                  suffixIcon: togglePassword(), //new line(suffixIcon)
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuthProvider.authService()
                      .logIn(email: _email.text, password: _password.text);
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      updateEmailRoute, (route) => false);
                } on UserNotFoundAuthException {
                  await showErrorDialog(context, 'User not found');
                } on WrongPasswordAuthException {
                  await showErrorDialog(context, 'Wrong credentials');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Authentication Error');
                }
              },
              //new line (container and all of it is inside)
              child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 1,
                            offset: Offset(0, 0)) //change blurRadius to 1
                      ],
                      borderRadius: BorderRadius.circular(13),
                      color: const Color.fromARGB(
                          255, 13, 213, 130)), //change color to green
                  child: const Center(
                      child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))),
            )
          ],
        ),
      ),
    );
  }
}
