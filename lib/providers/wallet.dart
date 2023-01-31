import 'package:flutter/material.dart';

class Wallet extends ChangeNotifier {
  bool _isImporting = false;
  List<String> _seeds = <String>[];

  bool get isImporting => _isImporting;

  void setImport(bool state) {
    _isImporting = state;
  }

  void setMnemonics(List<String> seeds) {
    _seeds = seeds;
  }

  List<String> get getSeeds => _seeds;
}
