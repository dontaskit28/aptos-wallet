import 'dart:math';
import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/payload/payload.dart';
import 'package:aptosdart/core/transaction/transaction.dart';
import 'package:flutter/material.dart';
import '../providers/account.dart';
import '../providers/network.dart';
import '../widgets/snackbar.dart';
import 'transactions.dart';
import 'balance.dart';

sendTokens({
  required String reciever,
  required String amount,
  required Account provider,
  required Network network,
  required BuildContext context,
  bool mounted = true,
}) async {
  if (provider.account == null) {
    return;
  }
  Payload payload = Payload.fromJson(
    {
      "function": "0x1::aptos_account::transfer",
      "type_arguments": [],
      "arguments": [reciever, amount],
      "type": "entry_function_payload"
    },
  );
  try {
    final transaction = await AptosClient()
        .generateTransaction(provider.account!.address(), payload, '1000');
    final simulate =
        await AptosClient().simulateTransaction(provider.account!, transaction);
    if (!mounted) return;
    double fee = double.parse(simulate.gasUsed!) *
        (double.parse(simulate.gasUnitPrice!)) /
        pow(10, 8);
    showAlert(
      context: context,
      amount: amount,
      fee: fee,
      reciever: reciever,
      provider: provider,
      network: network,
      transaction: transaction,
    );
  } on Exception catch (_) {
    snackBar(context, "Invalid Address", "error");
  }
}

Future<List> sendTransaction({
  required Account provider,
  required Transaction transaction,
}) async {
  try {
    final signature =
        await AptosClient().signTransaction(provider.account!, transaction);
    transaction.signature = signature;
    final result = await AptosClient().submitTransaction(transaction);
    final transResult = await AptosClient().waitForTransaction(result.hash!);
    return [
      result,
      transResult,
    ];
  } catch (e) {
    return [null, false];
  }
}

showAlert({
  required BuildContext context,
  required String amount,
  required double fee,
  required String reciever,
  required Account provider,
  required Network network,
  required Transaction transaction,
}) {
  showModalBottomSheet(
    context: context,
    builder: ((context) {
      bool firstPress = true;
      return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Center(
                    child: Text(
                      "Confirm Sending",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Center(
                    child: Image(
                      image: AssetImage('assets/aptos_coin.png'),
                      height: 70,
                      width: 70,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Value:",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${(double.parse(amount)) / pow(10, 8)} APT",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transaction fee:",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "$fee APT",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                      ),
                      onPressed: ({bool mounted = true}) async {
                        if (!firstPress) {
                          return;
                        } else {
                          firstPress = false;
                        }
                        final res = await sendTransaction(
                          provider: provider,
                          transaction: transaction,
                        );
                        if (!mounted) return;
                        if (res.last.success) {
                          Navigator.popAndPushNamed(
                            context,
                            "/success",
                            arguments: res.first.hash,
                          );
                        } else {
                          Navigator.pop(context);
                          snackBar(context, "Transaction Failed", "error");
                        }
                        getBalance(provider);
                        getTransactionsInAccount(provider, network);
                      },
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }),
  );
}
