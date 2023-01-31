import 'package:aptos_wallet/providers/account.dart';
import 'package:aptos_wallet/providers/network.dart';
import 'package:aptos_wallet/screens/welcome.dart';
import 'package:aptos_wallet/services/ntf.dart';
import 'package:aptos_wallet/services/storage_service.dart';
import 'package:aptos_wallet/widgets/coin_item.dart';
import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/constant/enums.dart';
import 'package:aptosdart/core/network_type/network_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/transactions.dart';
import '../../services/airdrop.dart';
import '../../services/balance.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final StorageService _storageService = StorageService();

  AptosDartSDK sdk = AptosDartSDK(logStatus: LogStatus.hide);

  bool airdropButton = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Account accountProvider = Provider.of<Account>(context, listen: false);
      Network networkProvider = Provider.of<Network>(context, listen: false);
      onLoad(accountProvider, networkProvider);
    });
    WidgetsFlutterBinding.ensureInitialized();
  }

  void onLoad(Account account, Network network) async {
    await initHiveForFlutter();
    sdk.setNetwork(NetworkType(
      networkURL: "https://fullnode.devnet.aptoslabs.com/v1",
      networkName: "devnet",
      faucetURL: "https://faucet.devnet.aptoslabs.com/",
      coinCurrency: "APT",
      coinType: CoinType.aptos,
      transactionHistoryGraphQL:
          "https://indexer-devnet.staging.gcp.aptosdev.com/v1/graphql",
      explorerBaseURL: "",
      explorerParam: "",
    ));
    await createWallet(account);
    await getBalance(account);
    network.loading = false;
    if (account.transactions.isEmpty) {
      await getTransactionsInAccount(account, network);
    }
    if (account.nfts.isEmpty) {
      await getAllNfts(account);
    }
  }

  createWallet(Account provider) async {
    final secretPhraseString =
        await _storageService.readSecureData('mnemonics');
    Uint8List uint8list =
        MnemonicUtils.convertMnemonicToSeed(secretPhraseString.toString());
    final account =
        await AptosClient().createAccount(privateKeyBytes: uint8list);
    provider.account = account;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Account>(context, listen: true);
    Network network = Provider.of<Network>(context, listen: true);
    return network.loading
        ? const Welcome()
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              centerTitle: true,
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFF4B39EF),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await getBalance(provider);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              mainAxisAlignment: MainAxisAlignment.center,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  provider.balance == 0
                                      ? 0.toStringAsFixed(5)
                                      : (provider.balance).toStringAsFixed(5),
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  " APT",
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              child: airdropButton
                                  ? SizedBox(
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            airdropButton = false;
                                          });
                                          await airDrop(
                                            context: context,
                                            provider: provider,
                                            network: network,
                                          );

                                          setState(() {
                                            airdropButton = true;
                                          });
                                          await getTransactionsInAccount(
                                              provider, network);
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            Color(0xFF4B39EF),
                                          ),
                                          padding: MaterialStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                vertical: 15.0),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            FaIcon(
                                              FontAwesomeIcons.arrowDown,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Airdrop",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, "/transfer_tokens");
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color(0xFF4B39EF),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      FaIcon(FontAwesomeIcons.paperPlane,
                                          color: Colors.white, size: 18),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Send",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              coinItem(
                                context,
                                icon: Image.asset('assets/aptos_coin.png'),
                                coin: "Aptos Coin",
                                balance: provider.balance,
                                symbol: "APT",
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            // Center(
                            //   child: TextButton(
                            //     onPressed: () {},
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: const [
                            //         Icon(
                            //           Icons.add,
                            //         ),
                            //         SizedBox(
                            //           width: 5,
                            //         ),
                            //         Text(
                            //           "Add coin",
                            //           style: TextStyle(
                            //             fontSize: 18,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
