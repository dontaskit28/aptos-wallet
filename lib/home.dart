import 'package:aptos_wallet/screens/activity.dart';
import 'package:aptos_wallet/screens/home/homepage.dart';
import 'package:aptos_wallet/screens/nfts/ntfs.dart';
import 'package:aptos_wallet/screens/profile.dart';
import 'package:aptos_wallet/screens/transactions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storageService = StorageService();
  bool _isWalletCreated = false;
  @override
  void initState() {
    super.initState();
    onLoad();
  }

  onLoad() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    _isWalletCreated =
        await _storageService.containsKeyInSecureData('mnemonics');
    if (!mounted) return;
    if (!_isWalletCreated) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/checkwallet',
        (Route<dynamic> route) => false,
      );
    }
  }

  int selectedIndex = 0;
  final List<Widget> tabs = [
    const MyHomePage(
      title: "Aptos Wallet",
    ),
    const Ntfs(),
    // const Activity(),
    const Transaction(),
    const Profile(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Network network = Provider.of<Network>(context, listen: true);
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        iconSize: 20,
        selectedItemColor: const Color(0xFF4B39EF),
        unselectedItemColor: Colors.grey.shade500,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.wallet,
            ),
            label: "Wallet",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.image,
            ),
            label: "NFTs",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.bolt,
            ),
            label: "Activity",
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.solidCircleUser,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
