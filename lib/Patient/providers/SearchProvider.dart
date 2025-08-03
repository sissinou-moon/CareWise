import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  String _Location   = '';
  String _Specialtie = '';
  String _Type       = '';

  String get Location => _Location;
  String get Specialtie => _Specialtie;
  String get Type => _Type;

  //Write Data
  void WriteSearchDetails(String location, String specialtie, String type) {
    _Location = location;
    _Specialtie = specialtie;
    _Type = type;

    notifyListeners();
  }
}