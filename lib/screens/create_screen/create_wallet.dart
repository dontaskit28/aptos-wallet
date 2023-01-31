import 'package:aptos_wallet/providers/wallet.dart';
import 'package:aptos_wallet/screens/create_screen/wallet_seeds.dart';
import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/utils/mnemonic/mnemonic_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewWallet extends StatefulWidget {
  const CreateNewWallet({super.key});

  @override
  State<CreateNewWallet> createState() => _CreateNewWalletState();
}

class _CreateNewWalletState extends State<CreateNewWallet> {
  List<String> seeds = MnemonicUtils.generateMnemonicList();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Wallet>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Your secret recovery phrase",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B39EF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "This phrase is the only way to recover your wallet.\n Please write it down and keep it safe.",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF4B39EF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Don't share it with anyone. If you lose it, you will lose your funds.",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF4B39EF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SeedInput(
                            createNewWallet: true,
                            seeds: seeds,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              provider.setMnemonics(seeds);
                              Navigator.pushReplacementNamed(
                                  context, "/import_wallet_seeds");
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              backgroundColor: const Color(0xFF4B39EF),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
