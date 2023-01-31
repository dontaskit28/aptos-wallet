import 'package:aptos_wallet/providers/wallet.dart';
import 'package:aptos_wallet/services/mnemonics_data.dart';
import 'package:aptos_wallet/services/storage_service.dart';
import 'package:aptos_wallet/widgets/snackbar.dart';
import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/network_type/network_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/network.dart';

class SeedInput extends StatefulWidget {
  final bool createNewWallet;
  final List<String> seeds;
  const SeedInput(
      {required this.createNewWallet, required this.seeds, super.key});

  @override
  State<SeedInput> createState() => _SeedInputState();
}

class _SeedInputState extends State<SeedInput> {
  final List<TextEditingController> _controllers = <TextEditingController>[];

  Future<bool> checkseeds(Wallet wallet, Network networkProvider) async {
    bool isImporting = wallet.isImporting;
    AptosDartSDK sdk = AptosDartSDK(logStatus: LogStatus.hide);

    final StorageService storageService = StorageService();
    String secretPhraseString;
    sdk.setNetwork(NetworkType(
      networkURL: "https://fullnode.devnet.aptoslabs.com/v1",
      networkName: "devnet",
      faucetURL: "https://faucet.devnet.aptoslabs.com/",
      coinCurrency: "APT",
      coinType: CoinType.aptos,
      transactionHistoryGraphQL: "",
      explorerBaseURL: "",
      explorerParam: "",
    ));
    // Check given seeds are matching with the generated seeds if creating new wallet
    if (!isImporting) {
      List<String> seeds = wallet.getSeeds;

      for (var i = 0; i < 12; i++) {
        if (_controllers[i].text != seeds[i]) {
          return false;
        }
      }
      secretPhraseString = seeds.join('');
      try {
        Uint8List uint8list =
            MnemonicUtils.convertMnemonicToSeed(secretPhraseString);
        final account =
            await AptosClient().createAccount(privateKeyBytes: uint8list);

        try {
          await FaucetClient().funcAccount(account.address(), 0);
        } on Exception catch (_) {
          debugPrint("Account alreadyy found on Devnet");
          return false;
        }

        debugPrint("account: ${account.address()}");
        storageService
            .writeSecureData(MnemoniceData('mnemonics', secretPhraseString));
      } catch (e) {
        return false;
      }
    } else {
      // get seeds from the user if importing wallet
      List<String> seeds = [];

      for (var i = 0; i < 12; i++) {
        seeds.add(_controllers[i].text);
        if (_controllers[i].text == "") {
          return false;
        }
      }
      secretPhraseString = seeds.join('');
      try {
        Uint8List uint8list =
            MnemonicUtils.convertMnemonicToSeed(secretPhraseString);
        final account =
            await AptosClient().createAccount(privateKeyBytes: uint8list);
        try {
          await FaucetClient().funcAccount(account.address(), 0);
          return false;
        } on Exception catch (_) {
          debugPrint("Account alreadyy found on Devnet");
        }

        debugPrint("account: ${account.address()}");
        storageService
            .writeSecureData(MnemoniceData('mnemonics', secretPhraseString));
      } catch (e) {
        return false;
      }
    }
    wallet.setMnemonics([]);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < 12; i++) {
      _controllers.add(TextEditingController());
      if (widget.createNewWallet) {
        _controllers[i].text = widget.seeds[i];
      }
    }
    final provider = Provider.of<Wallet>(context, listen: true);
    final networkProvider = Provider.of<Network>(context, listen: true);

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              seedInputField(_controllers[0]),
              const SizedBox(
                width: 10.0,
              ),
              seedInputField(_controllers[1]),
              const SizedBox(
                width: 10.0,
              ),
              seedInputField(_controllers[2]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              seedInputField(_controllers[3]),
              const SizedBox(
                width: 10.0,
              ),
              seedInputField(_controllers[4]),
              const SizedBox(
                width: 10.0,
              ),
              seedInputField(_controllers[5]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              seedInputField(_controllers[6]),
              const SizedBox(
                width: 10.0,
              ),
              seedInputField(_controllers[7]),
              const SizedBox(
                width: 10.0,
              ),
              seedInputField(_controllers[8]),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              seedInputField(_controllers[9]),
              const SizedBox(
                width: 10.0,
              ),
              seedInputField(_controllers[10]),
              const SizedBox(
                width: 10.0,
              ),
              seedInputField(_controllers[11]),
            ],
          ),
          const SizedBox(height: 50),
          !widget.createNewWallet
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        bool isOk = await checkseeds(provider, networkProvider);
                        if (!mounted) return;
                        if (!isOk) {
                          snackBar(
                              context, "Provided seeds are not valid", "error");
                        } else {
                          snackBar(context, "Importing wallet.", "success");
                          Navigator.pushReplacementNamed(context, "/home");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        elevation: 2,
                        backgroundColor: const Color(0xFF4B39EF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "Verify",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Flexible seedInputField(TextEditingController controller) {
    return Flexible(
      child: SizedBox(
        height: 45,
        child: TextField(
          controller: controller,
          readOnly: widget.createNewWallet,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
