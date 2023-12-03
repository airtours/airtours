import 'package:AirTours/services_auth/firebase_auth_provider.dart';
import 'package:AirTours/views/Admin/add_admin.dart';
import 'package:AirTours/views/Admin/admin.dart';
import 'package:AirTours/views/Global/bottom_bar.dart';
import 'package:AirTours/views/Manage_booking/upgrade_card.dart';
import 'package:AirTours/views/Profile/profile_view.dart';
import 'package:AirTours/views/Profile/add_balance.dart';
import 'package:AirTours/views/Profile/login_for_delete_verf.dart';
import 'package:AirTours/views/Profile/login_for_email_verf.dart';
import 'package:AirTours/views/Profile/login_for_password_verf.dart';
import 'package:AirTours/views/Profile/update_email.dart';
import 'package:AirTours/views/Profile/update_password.dart';
import 'package:AirTours/views/Welcome_pages/login_view.dart';
import 'package:AirTours/views/Welcome_pages/register_view.dart';
import 'package:AirTours/views/Welcome_pages/reset_view.dart';
import 'package:AirTours/views/Welcome_pages/verification_view.dart';
import 'package:AirTours/views/Welcome_pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'constants/pages_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      bottomRoute: (context) => const Bottom(),
      verficationRoute: (context) => const VerifyEmailView(),
      welcomeRoute: (context) => const WelcomeView(),
      createFlightRoute: (context) => const CreateFlight(),
      addAdminRoute: (context) => const AddAdmin(),
      updateEmailRoute: (context) => const UpdateEmailView(),
      updatePasswordRoute: (context) => const UpdatePasswordView(),
      addBalanceRoute: (context) => const AddBalance(),
      profileRoute: (context) => const ProfileView(),
      loginForEmailChangesRoute: (context) => const LoginForEmailChanges(),
      loginForPasswordChangesRoute: (context) =>
          const LoginForPasswordChanges(),
      loginForDeleteRoute: (context) => const LoginForDelete(),
      upgradeCard: (context) => const UpgradeCard(),
      resetView: (context) => const ResetPassword()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuthProvider.authService().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuthProvider.authService().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const Bottom();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const WelcomeView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
