import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../constants/pages_route.dart';
import '../../utilities/button.dart';
import '../../utilities/show_error.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
                  color: Color.fromRGBO(137, 147, 158, 1),
                  fontSize: 40,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
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
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[100]),
              child: TextField(
                textAlign: TextAlign.center,
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Enter Password',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurple, width: 3))),
              ),
            ),
            const SizedBox(height: 30),
            MyButton(
                title: 'Login',
                onPressed: () async {
                  final email = _email.text;
                  final pass = _password.text;
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: pass);
                    final user = FirebaseAuth.instance.currentUser;
                    print(user);
                    if (user?.emailVerified ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          bottomRoute, (route) => false);
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          verficationRoute, (route) => false);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      await showErrorDialog(context, 'user-not-found');
                    } else if (e.code == 'wrong-password') {
                      await showErrorDialog(context, "wrong-password");
                    } else {
                      await showErrorDialog(context, e.code);
                    }
                  } catch (e) {
                    await showErrorDialog(context, e.toString());
                  }
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not Registered? ',
                ),
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/register/', (route) => false);
                    },
                    child: const Text("Register now"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
