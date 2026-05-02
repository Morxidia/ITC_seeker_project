// lib/services/json_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/itc_structure.dart';

class JsonLoader {
  static Future<ITCStructure> loadStructure() async {
    final raw = await rootBundle.loadString('assets/structure.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    return ITCStructure.fromJson(map);
  }
}
