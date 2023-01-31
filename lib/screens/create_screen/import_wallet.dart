import 'package:aptos_wallet/providers/wallet.dart';
import 'package:aptos_wallet/screens/create_screen/wallet_seeds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
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
                          children: [
                            const Text(
                              "Enter your secret recovery phrase",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4B39EF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              provider.isImporting
                                  ? "Don't share it with anyone. If you lose it, you will lose your funds."
                                  : "Verify your seeds before continuing",
                              style: const TextStyle(
                                fontSize: 14,
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
                        children: const <Widget>[
                          SeedInput(
                            createNewWallet: false,
                            seeds: [],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(height: 20),
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
