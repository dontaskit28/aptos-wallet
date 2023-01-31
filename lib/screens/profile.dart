import 'package:aptos_wallet/providers/account.dart';
import 'package:aptos_wallet/providers/network.dart';
import 'package:aptos_wallet/providers/wallet.dart';
import 'package:aptos_wallet/screens/create_screen/wallet_seeds.dart';
import 'package:aptos_wallet/screens/welcome.dart';
import 'package:aptos_wallet/services/storage_service.dart';
import 'package:aptos_wallet/widgets/box_item.dart';
import 'package:aptos_wallet/widgets/snackbar.dart';
import 'package:aptosdart/aptosdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Account accountProvider = Provider.of<Account>(context, listen: true);
    Network network = Provider.of<Network>(context, listen: true);
    return network.loading
        ? const Welcome()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Profile"),
              // centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF4B39EF),
            ),
            body: Center(
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xFF4B39EF),
                            child: FaIcon(FontAwesomeIcons.wallet,
                                size: 30, color: Colors.white)),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Wallet 1",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: (() {
                            Clipboard.setData(
                              ClipboardData(
                                text: accountProvider.account != null
                                    ? accountProvider.account?.address()
                                    : "",
                              ),
                            );
                            snackBar(
                                context, "Wallet address copied", "success");
                          }),
                          // child: Text("jfsdkjsdkfjsd"),
                          child: Text(
                            accountProvider.account != null
                                ? "${accountProvider.account!.address().substring(0, 10)}...${accountProvider.account!.address().substring(54)}"
                                : "",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        BoxItem(
                            name: "Reveal Seed Phrase",
                            icon: FontAwesomeIcons.key,
                            onPress: () {
                              var mnemonic =
                                  MnemonicUtils.convertPrivateKeyHexToMnemonic(
                                      accountProvider.account!
                                          .privateKeyInHex());
                              snackBar(context, mnemonic, "info");
                            }),
                        BoxItem(
                            name: "Network",
                            icon: FontAwesomeIcons.networkWired,
                            onPress: () {
                              snackBar(context,
                                  "Currently only devnet is available", "info");
                            }),
                        BoxItem(
                          name: "Logout",
                          icon: FontAwesomeIcons.signOutAlt,
                          onPress: () async {
                            final StorageService storageService =
                                StorageService();
                            await storageService.deleteSecureData('mnemonics');
                            accountProvider.account = null;
                            accountProvider.balance = 0;
                            if (!mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/", (Route<dynamic> route) => false);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

deleteWallet({bool mounted = true}) async {
  // Provider.of<Account>(context, listen: false).account = null;
  // Provider.of<Account>(context, listen: false).balance = 0;
  final StorageService storageService = StorageService();
  await storageService.deleteSecureData('mnemonics');
  // if (!mounted) return;
  // Navigator.pushNamed(context, "/");
}
