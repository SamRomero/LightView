import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'camaras.dart';
import 'login_screen.dart';
import 'luces.dart';
import 'cam.dart';
import 'home.dart'; // Importa la pantalla Home
import 'package:lightview/localstorage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.onTabSelected,
    this.initialIndex,
  }) : super(key: key);

  final String title;
  final ValueChanged<int> onTabSelected;
  final int? initialIndex;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final LocalStorage _localStorage = LocalStorage();

  // Define las pantallas correspondientes a cada pestaña
  final List<Widget> _screens = [
    Home(), // Pantalla Home (nueva)
    Luces(),
    Camaras(),
  ];

  @override
  void initState() {
    _localStorage.init();
    super.initState();
    if (widget.initialIndex != null) {
      _currentIndex = widget.initialIndex!;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      // Llama a la función proporcionada desde Home para actualizar la pestaña seleccionada
      widget.onTabSelected(index);
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Ícono para Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb), // Ícono para Luces
            label: 'Luces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam), // Ícono para Cam
            label: 'Cam',
          ),
        ],
        selectedItemColor: Colors.purple[800],
        unselectedItemColor: Colors.blue[200],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signOut,
        tooltip: 'Cerrar Sesión',
        child: Icon(Icons.exit_to_app),
        backgroundColor: Colors.red, // Cambia el color según tu preferencia
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop, // Cambia la ubicación según tu preferencia
    );
  }
}



