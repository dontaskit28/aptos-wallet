import 'dart:math';
import 'package:aptosdart/aptosdart.dart';
import '../providers/account.dart';

getBalance(Account account) async {
  if (account.account == null) {
    return;
  }
  try {
    dynamic resource = await AptosClient().getResourcesByType(
        address: account.account!.address(),
        resourceType: "0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>");
    account.balance = double.parse(resource.data.coin.value) / pow(10, 8);
  } catch (e) {
    account.balance = 0;
  }
}
