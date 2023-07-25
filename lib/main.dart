import 'package:AirTours/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:AirTours/views/login_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: const   HomePage(),
      routes: {
        '/login/':(context) => const LoginView(),
        '/register/':(context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
      },
    ),);
}



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
        builder:(context, snapshot) {
         
          switch (snapshot.connectionState){
            
            case ConnectionState.done:

            final user = FirebaseAuth.instance.currentUser;
            
            if(user != null){
            if(user.emailVerified){
              return const NotesView();
            }
            else{
              return const LoginView();
            }
            }
            else{
             return const RegisterView();
            }
         
            

        default:
        return const  CircularProgressIndicator();
          
          }

          

        },
        
      );
  }
}


enum MenuAction { logout }


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value)async  {
             switch (value){
              case MenuAction.logout:
              final shouldLogout = await showLogOutDialog(context);
              if(shouldLogout==true){
               await FirebaseAuth.instance.signOut();
               // ignore: use_build_context_synchronously
               Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                (_) => false);

              }
              
            }
          },
          itemBuilder: (context) {
            return const [
               PopupMenuItem(
              value: MenuAction.logout,
            child: Text('Log out'),),
            ];
          },)
        ]
         
      ),
      body: const Text('Hello world'),

    );
  }
}


Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(context: context,
   builder: (context){
    return AlertDialog(
      title: const Text('Sign ouuut'),
      content: const Text('Are you sure'),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: const Text('Cancel')),

        TextButton(onPressed: (){
          Navigator.of(context).pop(true);
        }, child: const Text('Log out i think')),
      ],
    );
   }
   ).then((value) => value ?? false); 
}