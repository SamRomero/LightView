import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  late SharedPreferences _preferences;

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> addRutina(String nombre, List<int> focos, bool encender) async {
    final List<Map<String, dynamic>> rutinas = _preferences.getStringList('rutinas')?.map((jsonString) {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    })?.toList() ?? [];

    final nuevaRutina = {
      'nombre': nombre,
      'focos': focos,
      'encender': encender,
    };

    rutinas.add(nuevaRutina);

    await _preferences.setStringList('rutinas', rutinas.map((rutina) {
      return jsonEncode(rutina);
    }).toList());
  }

  List<Map<String, dynamic>> getRutinas() {
    final List<String>? rutinasJson = _preferences.getStringList('rutinas');

    if (rutinasJson != null) {
      return rutinasJson.map((jsonString) {
        return Map<String, dynamic>.from(jsonDecode(jsonString));
      }).toList();
    }

    return [];
  }

  Future<void> clearRutinas() async {
    await _preferences.remove('rutinas');
  }



  Future<void> addCam(String nombre, String url) async {
    final List<Map<String, dynamic>> cams = _preferences.getStringList('cams')?.map((jsonString) {
      return Map<String, dynamic>.from(jsonDecode(jsonString));
    })?.toList() ?? [];

    final nuevaCam = {
      'nombre': nombre,
      'url': url,
    };

    cams.add(nuevaCam);

    await _preferences.setStringList('cams', cams.map((cam) {
      return jsonEncode(cam);
    }).toList());
  }

  List<Map<String, dynamic>> getCams() {
    final List<String>? camsJson = _preferences.getStringList('cams');

    if (camsJson != null) {
      return camsJson.map((jsonString) {
        return Map<String, dynamic>.from(jsonDecode(jsonString));
      }).toList();
    }

    return [];
  }

  Future<void> clearCams() async {
    await _preferences.remove('cams');
  }
}

