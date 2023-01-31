import 'package:aptosdart/aptosdart.dart';
import 'package:flutter/material.dart';
import '../providers/account.dart';
import '../providers/network.dart';
import '../widgets/snackbar.dart';
import 'balance.dart';

// AirDrop 1 APT
airDrop(
    {required BuildContext context,
    required Account provider,
    required Network network}) async {
  if (provider.account == null) {
    return;
  }
  try {
    await FaucetClient()
        .funcAccount(provider.account!.address(), 100000000)
        .then((e) {
      snackBar(context, "Airdrop Success", 'success');
    });
    await getBalance(provider);
  } catch (e) {
    snackBar(context, "Airdrop Failed", 'error');
  }
}
