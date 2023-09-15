import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Luces(),
    );
  }
}

class Luces extends StatefulWidget {
  @override
  _LucesState createState() => _LucesState();
}

class _LucesState extends State<Luces> {
  List<bool> focoEncendido = [];
  final String arduinoIP = "http://192.168.0.98:80/";
  List<CustomButton> customButtons = [];
  Widget? botonPersonalizado; // Cambio de tipo de variable

  @override
  void initState() {
    super.initState();
    obtenerNumeroDeFocos();
  }

  void controlarFoco(int focoNumero, bool encendido) async {
    final url = arduinoIP + "relay$focoNumero/${encendido ? 'on' : 'off'}";

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          focoEncendido[focoNumero - 1] = encendido;
        });
        print("Foco $focoNumero ${encendido ? 'encendido' : 'apagado'}");
      } else {
        print("Error al ${encendido ? 'encender' : 'apagar'} Foco $focoNumero");
      }
    } catch (e) {
      print("Error de red: $e");
    }
  }

  Future<void> obtenerNumeroDeFocos() async {
    final url = arduinoIP + "mode/status";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final numFocos = int.tryParse(response.body) ?? 0;

        try {
          for (int i = 1; i <= numFocos; i++) {
            final urlStatus = arduinoIP + "relay$i/status";
            final response = await http.get(Uri.parse(urlStatus));

            if (response.statusCode == 200) {
              final responseBody = response.body.toLowerCase();
              final encendido = responseBody.contains("encendido");
              setState(() {
                focoEncendido.add(encendido);
              });
            } else {
              print("Error al obtener el estado del Foco $i");
            }
          }
        } catch (e) {
          print("Error de red: $e");
        }
      } else {
        print("Error al obtener el número de focos");
      }
    } catch (e) {
      print("Error de red: $e");
    }
  }

  void agregarCustomButton() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String customButtonName = "";
        List<bool> selectedFocos = List.generate(focoEncendido.length, (index) => false);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Agregar Botón Personalizado"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "Nombre del botón"),
                    onChanged: (value) {
                      customButtonName = value;
                    },
                  ),
                  SizedBox(height: 10.0),
                  Text("Selecciona los focos a encender:"),
                  Column(
                    children: List.generate(
                      focoEncendido.length,
                          (index) {
                        return CheckboxListTile(
                          title: Text("Foco ${index + 1}"),
                          value: selectedFocos[index],
                          onChanged: (value) {
                            setState(() {
                              selectedFocos[index] = value!;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Agregar el botón personalizado a la lista
                    customButtons.add(CustomButton(customButtonName, selectedFocos));
                    Navigator.of(context).pop();

                    // Actualiza la vista para mostrar el botón personalizado
                    setState(() {
                      botonPersonalizado = ElevatedButton(
                        onPressed: () {
                          // Lógica para ejecutar el botón personalizado
                        },
                        child: Text(
                          customButtonName,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                      );
                    });
                  },
                  child: Text("Guardar"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void encenderTodos() {
    for (int i = 1; i <= focoEncendido.length; i++) {
      controlarFoco(i, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Control de Luces"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.teal],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30.0),
                Icon(
                  Icons.lightbulb,
                  size: 100.0,
                  color: Colors.amber,
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: [
                      Text(
                        'Focos Disponibles',
                        style: TextStyle(fontSize: 24.0, color: Colors.white),
                      ),
                      SizedBox(height: 20.0),
                      if (focoEncendido.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(height: 10.0),
                            GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                              ),
                              itemCount: focoEncendido.length,
                              itemBuilder: (context, index) {
                                return buildFocoCard(index + 1);
                              },
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              'Comandos personalizados',
                              style: TextStyle(fontSize: 24.0, color: Colors.white),
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: encenderTodos,
                              child: Text(
                                'Bienvenido a casa',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                agregarCustomButton();
                              },
                              child: Icon(Icons.add),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(20.0),
                                primary: Colors.green,
                                onPrimary: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            if (botonPersonalizado != null) {
                              botonPersonalizado!,
                            },
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFocoCard(int focoNumero) {
    return Card(
      color: Colors.deepPurple[300],
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Foco $focoNumero',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ],
          ),
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
                value: focoEncendido[focoNumero - 1],
                onChanged: (value) {
                  setState(() {
                    focoEncendido[focoNumero - 1] = value;
                  });
                  controlarFoco(focoNumero, value);
                },
                activeColor: Colors.green,
                activeTrackColor: Colors.green[700],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomButton {
  String name;
  List<bool> selectedFocos;

  CustomButton(this.name, this.selectedFocos);
}



























