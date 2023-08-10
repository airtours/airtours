import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/pages_route.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _password2;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _password2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _password2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: Image.asset('img/tours3.png'),
            ),
            const Text(
              'AirTours',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(137, 147, 158, 1)),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: 'Enter Email',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 3))),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.deepPurple, width: 3)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _password2,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 3))),
              ),
            ),
            const SizedBox(height: 30),
            MyButton(
                title: 'Register',
                onPressed: () async {
                  final email = _email.text;
                  final pass = _password.text;
                  final pass2 = _password2.text;
                  if (pass != pass2) {
                    showErrorDialog(context, "Password doesn't match!");
                  } else {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: pass);
                      final user = FirebaseAuth.instance.currentUser;
                      await user?.sendEmailVerification();
                      Navigator.of(context).pushNamed(verficationRoute);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'email-already-in-use') {
                        await showErrorDialog(context, 'email-already-in-use');
                      } else if (e.code == 'invalid-email') {
                        await showErrorDialog(context, 'invalid-email');
                      } else if (e.code == 'weak-password') {
                        await showErrorDialog(context, 'weak-password');
                      } else {
                        await showErrorDialog(context, e.code);
                      }
                    } catch (e) {
                      await showErrorDialog(context, e.toString());
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
            // MyButton(
            //   title: 'Already Registered? Login Here!',
            //   onPressed: () {
            //     Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
