import 'package:flutter/material.dart';
import 'luces.dart';
import 'cam.dart';
import 'my_home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Define las variables aquí si es necesario

  Future<void> _luces() async{
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            title: 'LightView',
            initialIndex: 1,
            onTabSelected: (index) {},), // Redirige a Luces
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.teal],
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.asset(
                  'assets/home.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '¡Bienvenido Usuario!',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: 'LightView',
                        initialIndex: 1,
                        onTabSelected: (index) {},), // Redirige a Luces
                    ));
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                padding: EdgeInsets.symmetric(
                  vertical: 50.0,
                  horizontal: 90.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Manejo de Luces',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(
                        title: 'LightView',
                        initialIndex: 2,
                        onTabSelected: (index) {},), // Redirige a Luces
                    ));
                },
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
                padding: EdgeInsets.symmetric(
                  vertical: 50.0,
                  horizontal: 110.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Ver Cámaras',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

