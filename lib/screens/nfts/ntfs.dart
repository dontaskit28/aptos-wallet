import 'package:aptos_wallet/providers/network.dart';
import 'package:aptos_wallet/services/ntf.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/account.dart';

class Ntfs extends StatefulWidget {
  const Ntfs({super.key});

  @override
  State<Ntfs> createState() => _NtfsState();
}

class _NtfsState extends State<Ntfs> {
  bool loading = false;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Account accountProvider = Provider.of<Account>(context, listen: false);
      Network network = Provider.of<Network>(context, listen: false);
      onLoad(accountProvider, network);
    });
  }

  onLoad(Account account, Network network) async {
    network.nftsLoading = true;
    await Future.delayed(const Duration(seconds: 2));
    await getAllNfts(account);
    network.nftsLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Account>(context, listen: true);
    Network network = Provider.of<Network>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFTs"),
        actions: [
          IconButton(
            onPressed: () async {
              network.nftsLoading = true;
              await getAllNfts(account);
              network.nftsLoading = false;
            },
            icon: const Icon(
              Icons.replay_outlined,
            ),
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF4B39EF),
      ),
      body: Center(
        child: network.nftsLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Loading NFTs"),
                ],
              )
            : account.nfts.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("No NFT's Found"),
                    ],
                  )
                : GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    children: <Widget>[
                      for (var ele in account.nfts)
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/detailed_nft",
                              arguments: ele,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/loading.gif",
                              image: ele.url,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
        // : Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       SizedBox(
        //         height: MediaQuery.of(context).size.height * 0.72,
        //         width: MediaQuery.of(context).size.width * 0.95,
        //         child:
        //       ),
        //       loading
        //           ? const CircularProgressIndicator()
        //           : ElevatedButton(
        //               style: ButtonStyle(
        //                 padding: MaterialStateProperty.all(
        //                   const EdgeInsets.symmetric(
        //                     horizontal: 40,
        //                     vertical: 15,
        //                   ),
        //                 ),
        //               ),
        //               onPressed: () async {
        //                 setState(() {
        //                   loading = true;
        //                 });
        //                 await mintNft(
        //                   context: context,
        //                   account: account,
        //                   name: "Rakesh",
        //                   collection: "Our Collection",
        //                   url:
        //                       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNZ-ngxm1ocQd-1GgCHhfisQDLAynfuPPDXg&usqp=CAU",
        //                 );
        //                 setState(() {
        //                   loading = false;
        //                 });
        //               },
        //               child: const Text(
        //                 "Mint NFT",
        //                 style: TextStyle(fontSize: 16),
        //               ),
        //             )
        //     ],
        //   ),
      ),
    );
  }
}
