import 'package:aptos_wallet/home.dart';
import 'package:aptos_wallet/providers/network.dart';
import 'package:aptos_wallet/providers/wallet.dart';
import 'package:aptos_wallet/screens/create_screen/create_wallet.dart';
import 'package:aptos_wallet/screens/create_screen/import_create_wallet.dart';
import 'package:aptos_wallet/screens/create_screen/import_wallet.dart';
import 'package:aptos_wallet/screens/home/success.dart';
import 'package:aptos_wallet/screens/nfts/detailed_nft.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/account.dart';
import 'screens/home/transfertokens.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Wallet()),
        ChangeNotifierProvider(create: (context) => Account()),
        ChangeNotifierProvider(create: (context) => Network()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = <String, WidgetBuilder>{
    "/home": (BuildContext context) => const HomePage(),
    "/checkwallet": (BuildContext context) => const ImportCreateWallet(),
    "/create_wallet_seeds": (BuildContext context) => const CreateNewWallet(),
    "/import_wallet_seeds": (BuildContext context) => const ImportWallet(),
    "/transfer_tokens": (BuildContext context) => const TransferTokens(),
    "/success": (BuildContext context) => const Success(),
    "/detailed_nft": (BuildContext context) => const DetailedNft(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aptos wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: routes,
    );
  }
}
