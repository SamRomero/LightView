import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lightview/Pantallas/home.dart';
import 'Pantallas/home.dart';
import 'Pantallas/my_home_page.dart';
import 'localstorage.dart';
import 'Pantallas/login_screen.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inicializar LocalStorage
  //LocalStorage localStorage = LocalStorage();
  //await localStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.deepPurple, Colors.teal],
        ),
      ),
      child: MaterialApp(
        title: 'LightView',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => MyHomePage(title: 'a', onTabSelected: (int value) { 0; },)
        },
      ),
    );
  }

}