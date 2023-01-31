import 'dart:async';
import 'package:aptos_wallet/widgets/coin_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account.dart';
import '../providers/network.dart';
import '../services/transactions.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
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
    network.transactionLoading = true;
    await Future.delayed(const Duration(seconds: 2));
    await getAccountTransactions(account, network);
    network.transactionLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Account>(context, listen: true);
    Network network = Provider.of<Network>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity"),
        actions: [
          IconButton(
            onPressed: () async {
              getAccountTransactions(account, network);
            },
            icon: const Icon(
              Icons.replay_outlined,
            ),
          )
        ],
        backgroundColor: Color(0xFF4B39EF),
        automaticallyImplyLeading: false,
      ),
      body: network.transactionLoading
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(" Loading Transactions"),
                ],
              ),
            )
          : Center(
              child: account.transactions.isEmpty
                  ? const Text("No Data")
                  : ListView.builder(
                      itemCount: account.transactions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return account.transactions[index]["name"] != ""
                            ? coinItem(
                                context,
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.yellow,
                                  size: 34,
                                ),
                                coin: "Created Token",
                                symbol: account.transactions[index]["name"],
                                balance: 0,
                              )
                            : account.transactions[index]["collection"] != ""
                                ? coinItem(
                                    context,
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.yellow,
                                      size: 34,
                                    ),
                                    coin: "Created Collection",
                                    symbol: account.transactions[index]
                                        ["collection"],
                                    balance: 0,
                                  )
                                : account.transactions[index]["balance"] >= 0
                                    ? coinItem(
                                        context,
                                        icon: const Icon(
                                          Icons.call_received,
                                          color: Colors.green,
                                        ),
                                        coin: "Recieved",
                                        symbol:
                                            "${account.transactions[index]['reciever']}",
                                        balance: account.transactions[index]
                                            ["balance"],
                                      )
                                    : coinItem(
                                        context,
                                        icon: const Icon(
                                          Icons.call_made,
                                          color: Colors.red,
                                        ),
                                        coin: "Send",
                                        symbol:
                                            "${account.transactions[index]['reciever']}",
                                        balance: account.transactions[index]
                                            ["balance"],
                                      );
                      },
                    ),
            ),
    );
  }
}
