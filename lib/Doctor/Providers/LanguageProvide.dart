import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _language   = '';

  String get Language => _language;

  //Write Data
  void ChangeLanguage(String language) {
    _language = language;

    notifyListeners();
  }
}