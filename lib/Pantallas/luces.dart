import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lightview/localstorage.dart';

class Luces extends StatefulWidget {
  @override
  _LucesState createState() => _LucesState();
}

class _LucesState extends State<Luces> {
  int numFocos = 0;
  List<bool> focoEstados = [];
  List<Map<String, dynamic>> rutinas = [];

  @override
  void initState() {
    super.initState();
    _getNumFocos();
    LocalStorage().init();
    printRutinas();
    _loadRutinas();
  }

  void _loadRutinas() async {
    final localStorage = LocalStorage();
    await localStorage.init();
    setState(() {
      rutinas = localStorage.getRutinas();
    });
  }

  void printRutinas() async {
    final localStorage = LocalStorage();
    await localStorage.init();
    //await localStorage.clearRutinas();
    final rutinas = localStorage.getRutinas();

    if (rutinas.isNotEmpty) {
      for (var i = 0; i < rutinas.length; i++) {
        final rutina = rutinas[i];
        print('Rutina ${i + 1}:');
        print('Nombre: ${rutina['nombre']}');
        print('Focos: ${rutina['focos']}');
        print('Encender: ${rutina['encender']}');
        print('\n');
      }
    } else {
      print('No hay rutinas creadas.');
    }
  }

  Future<void> _getNumFocos() async {
    final response = await http.get(Uri.parse('http://192.168.0.98:80/mode/status'));
    if (response.statusCode == 200) {
      final parsedResponse = int.tryParse(response.body);
      if (parsedResponse != null) {
        setState(() {
          numFocos = parsedResponse;
          focoEstados = List.generate(numFocos, (index) => false);
        });
        _getFocoEstados();
      }
    } else {
      // Manejo de errores aquí
    }
  }

  Future<void> _getFocoEstados() async {
    for (int i = 1; i <= numFocos; i++) {
      final response = await http.get(Uri.parse('http://192.168.0.98:80/relay$i/status'));
      if (response.statusCode == 200) {
        final responseBody = response.body.toLowerCase();
        setState(() {
          focoEstados[i - 1] = responseBody.contains('encendido');
        });
      } else {
        // Manejo de errores aquí
      }
    }
  }

  Future<void> _cambiarEstadoFoco(int index, bool encender) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.98:80/relay${index + 1}/${encender ? 'on' : 'off'}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        focoEstados[index] = encender;
      });
    } else {
      // Manejo de errores aquí
    }
  }

  void _mostrarSeleccionadorFocos(BuildContext context) {
    final TextEditingController nombreController = TextEditingController();
    final List<int> focosSeleccionados = List<int>.generate(numFocos, (index) => index);
    bool encenderFocos = false;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Checkbox(
                          value: encenderFocos,
                          onChanged: (value) {
                            setState(() {
                              encenderFocos = value ?? false;
                            });
                          },
                        ),
                        Text('Encender los focos'),
                      ],
                    ),
                    Text(
                      'Selecciona los focos que deseas controlar:',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: numFocos,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Foco ${index + 1}'),
                          trailing: Checkbox(
                            value: focosSeleccionados.contains(index),
                            onChanged: (value) {
                              setState(() {
                                if (value!) {
                                  focosSeleccionados.add(index);
                                } else {
                                  focosSeleccionados.remove(index);
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de la rutina',
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () async {
                        await LocalStorage().addRutina(nombreController.text, focosSeleccionados, encenderFocos);
                        _loadRutinas(); // Actualiza la lista de rutinas
                        Navigator.of(context).pop();
                      },
                      child: Text('Aplicar cambios y guardar rutina'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildRutinaButtons() {
    if (rutinas.isNotEmpty) {
      return rutinas.map((rutina) {
        return ElevatedButton(
          onPressed: () {
            final focos = rutina['focos'] as List<dynamic>;
            final encender = rutina['encender'] as bool;

            print('$focos $encender');
            for (final index in focos) {
              print(index);
              _cambiarEstadoFoco(index, encender);
            }
          },
          child: Text(rutina['nombre'] as String),
        );
      }).toList();
    } else {
      return [Text('No hay rutinas creadas.')];
    }
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
        child: ListView(
          children: [
            SizedBox(height: 10.0), // Agregar espacio en la parte superior
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lightbulb,
                    size: 100.0, // Tamaño del ícono
                    color: Colors.amber,
                  ),
                  SizedBox(width: 16.0),
                  Text(
                    'Focos disponibles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            numFocos == 0
                ? Center(
              child: CircularProgressIndicator(),
            )
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columnas por fila
                childAspectRatio: 1.3, // Ajusta este valor para reducir el tamaño verticalmente
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: numFocos,
              itemBuilder: (context, index) {
                return buildFocoCard(index + 1);
              },
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Rutinas:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              children: _buildRutinaButtons(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarSeleccionadorFocos(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildFocoCard(int focoNumero) {
    return Card(
      color: Colors.deepPurple[300],
      margin: EdgeInsets.all(10.0), // Margen alrededor de cada tarjeta
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
        crossAxisAlignment: CrossAxisAlignment.stretch, // Alinea el contenido al estiramiento horizontal
        children: [
          // Nombre del foco
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Foco $focoNumero',
              style: TextStyle(color: Colors.white, fontSize: 22.0),
              textAlign: TextAlign.center,
            ),
          ),
          // Ícono e interruptor
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.lightbulb,
                  color: Colors.amber,
                  size: 32.0,
                ),
              ),
              Switch(
                value: focoEstados[focoNumero - 1],
                onChanged: (value) {
                  _cambiarEstadoFoco(focoNumero - 1, value);
                },
                activeColor: Colors.green,
                activeTrackColor: Colors.green[700],
              ),
            ],
          ),
          SizedBox(height: 5.0), // Espacio inferior reducido
        ],
      ),
    );
  }
}



























