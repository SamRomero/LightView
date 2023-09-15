import 'dart:convert';
//import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  late SharedPreferences _preferences; // Agregamos 'late' para diferir la inicialización

  factory LocalStorage() {
    return _instance;
  }

  LocalStorage._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

}

class SharedPreferences {
  static getInstance() {}
}