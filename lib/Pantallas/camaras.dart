import 'package:flutter/material.dart';
import 'package:lightview/localstorage.dart';
import 'cam.dart';

class Camaras extends StatefulWidget {
  @override
  _CamarasState createState() => _CamarasState();
}

class _CamarasState extends State<Camaras> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  List<Map<String, dynamic>> _cams = [];

  @override
  void initState() {
    super.initState();
    _loadCams();
  }

  Future<void> _loadCams() async {
    final List<Map<String, dynamic>> cams = LocalStorage().getCams();

    setState(() {
      _cams = cams;
    });
  }

  Future<void> _addCam(String nombre, String url) async {
    if (nombre.isNotEmpty && url.isNotEmpty) {
      LocalStorage().addCam(nombre, url);
      _loadCams(); // Recarga la lista de cámaras después de agregar una nueva
      setState(() {
        _nombreController.clear();
        _urlController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cámara agregada con éxito.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingresa un nombre y una URL válida.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cámaras'),
      ),
      body: ListView.builder(
        itemCount: _cams.length,
        itemBuilder: (context, index) {
          final cam = _cams[index];
          return ListTile(
            title: Text(cam['nombre'] ?? ''),
            subtitle: Text(cam['url'] ?? ''),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Cam(url: cam['url'] ?? ''),
                  ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Agregar Cámara'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(labelText: 'URL'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addCam(_nombreController.text, _urlController.text);
                      Navigator.of(context).pop();
                    },
                    child: Text('Guardar'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

