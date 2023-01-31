import 'dart:math';
import 'package:aptos_wallet/providers/account.dart';
import 'package:aptos_wallet/widgets/address_box.dart';
import 'package:aptos_wallet/widgets/balance_input.dart';
import 'package:aptos_wallet/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/network.dart';
import '../../services/send_tokens.dart';

class TransferTokens extends StatefulWidget {
  const TransferTokens({super.key});

  @override
  State<TransferTokens> createState() => _TransferTokensState();
}

class _TransferTokensState extends State<TransferTokens> {
  final TextEditingController inputController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool loading = false;

  send(Account provider, Network network) async {
    double amt = double.tryParse(inputController.text) ?? 0;
    if (amt > provider.balance || amt <= 0) {
      snackBar(context, "Invalid Balance", "error");
      return;
    }
    var amount = (amt * pow(10, 8)).toInt().toString();
    String reciever = addressController.text;
    if (reciever == "" || reciever == provider.account!.address()) {
      snackBar(context, "Invalid reciever", "error");
      return;
    }
    setState(() {
      loading = true;
    });
    await sendTokens(
      reciever: reciever,
      amount: amount,
      provider: provider,
      network: network,
      context: context,
    );
    setState(() {
      loading = false;
    });
    inputController.text = "";
    addressController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    Account accountProvider = Provider.of<Account>(context, listen: true);
    Network network = Provider.of<Network>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Transfer"),
        centerTitle: true,
        backgroundColor: Color(0xFF4B39EF),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(
                        children: const [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: FaIcon(
                              FontAwesomeIcons.paperPlane,
                              size: 50,
                              color: Color(0xFF4B39EF),
                            ),
                          ),
                          Text(
                            "Send Tokens",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Send tokens to any aptos compatible wallet",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        BalanceInput(
                          controller: inputController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AddressBox(
                          controller: addressController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Center(
                          child: loading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF4B39EF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  onPressed: () {
                                    send(accountProvider, network);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      "Send",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
