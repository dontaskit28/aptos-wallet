import 'package:aptos_wallet/services/nft_data.dart';
import 'package:aptosdart/aptosdart.dart';
import 'package:flutter/cupertino.dart';

class Account extends ChangeNotifier {
  double _balance = 0;
  AptosAccount? _account;
  List _transVersion = [];
  List<Map> _transactions = [];
  List<NFT> _nfts = [];

  double get balance => _balance;
  AptosAccount? get account => _account;
  List<Map> get transactions => _transactions;
  List get transVersion => _transVersion;
  List<NFT> get nfts => _nfts;

  set balance(double value) {
    _balance = value;
    notifyListeners();
  }

  set account(AptosAccount? value) {
    _account = value;
    notifyListeners();
  }

  set transactions(List<Map> value) {
    _transactions = value;
    notifyListeners();
  }

  set transVersion(List value) {
    _transVersion = value;
    notifyListeners();
  }

  set nfts(List<NFT> value) {
    _nfts = value;
    notifyListeners();
  }

  addTransaction(Map value) {
    _transactions.insert(0, value);
    notifyListeners();
  }

  addVersion(int value) {
    if (transactions.length >= 15) {
      _transactions.removeLast();
    }
    _transVersion.add(value);
    notifyListeners();
  }

  addNft(var value) {
    _nfts.add(value);
    notifyListeners();
  }
}
