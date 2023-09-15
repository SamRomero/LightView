import 'package:flutter/material.dart';

class Cam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.videocam,
              size: 100.0,
              color: Colors.blue, // Cambia el color a tu preferencia
            ),
            Text(
              'Cámara',
              style: TextStyle(fontSize: 24.0),
            ),
            // Agrega aquí tu contenido relacionado con la cámara
          ],
        ),
      ),
    );
  }
}
