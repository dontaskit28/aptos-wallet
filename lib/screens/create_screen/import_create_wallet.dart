import 'package:aptos_wallet/providers/wallet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ImportCreateWallet extends StatefulWidget {
  const ImportCreateWallet({super.key});

  @override
  State<ImportCreateWallet> createState() => _ImportCreateWalletState();
}

class _ImportCreateWalletState extends State<ImportCreateWallet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Wallet>(context, listen: true);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: FaIcon(
                          FontAwesomeIcons.wallet,
                          size: 60,
                          color: Color(0xFF4B39EF),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "Aptos Wallet",
                      style: TextStyle(
                          color: Color(0xFF4B39EF),
                          fontWeight: FontWeight.bold,
                          fontSize: 26.0),
                    ),
                    SizedBox(height: 14),
                    Text(
                      "Your Crypto Wallet for the Future",
                      style: TextStyle(
                        color: Color(0xFF4B39EF),
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        provider.setImport(false);
                        Navigator.pushNamed(context, '/create_wallet_seeds');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 42, vertical: 10),
                        backgroundColor: const Color(0xFF4B39EF),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          FaIcon(
                            FontAwesomeIcons.plus,
                            size: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Create a new wallet",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          provider.setImport(true);
                          Navigator.pushNamed(context, '/import_wallet_seeds');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: const Color(0xFF4B39EF),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            FaIcon(
                              FontAwesomeIcons.circleArrowDown,
                              size: 18,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Import an existing wallet",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
