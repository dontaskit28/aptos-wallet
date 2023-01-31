import 'package:flutter/cupertino.dart';

class Network extends ChangeNotifier {
  String _testnet = "https://fullnode.testnet.aptoslabs.com/v1";
  String _devnet = "https://fullnode.devnet.aptoslabs.com/v1";
  bool _loading = true;
  bool _transactionLoading = false;
  bool _nftsLoading = false;

  String get testnet => _testnet;
  String get devnet => _devnet;
  bool get loading => _loading;
  bool get transactionLoading => _transactionLoading;
  bool get nftsLoading => _nftsLoading;

  set testnet(String value) {
    _testnet = value;
    notifyListeners();
  }

  set devnet(String value) {
    _devnet = value;
    notifyListeners();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set transactionLoading(bool value) {
    _transactionLoading = value;
    notifyListeners();
  }

  set nftsLoading(bool value) {
    _nftsLoading = value;
    notifyListeners();
  }
}
