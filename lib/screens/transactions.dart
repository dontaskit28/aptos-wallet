import 'package:aptos_wallet/widgets/coin_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account.dart';
import '../providers/network.dart';
import '../services/transactions.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
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
    // await Future.delayed(const Duration(seconds: 2));
    await getTransactionsInAccount(account, network);
    network.transactionLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    Account account = Provider.of<Account>(context, listen: true);
    Network network = Provider.of<Network>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction"),
        backgroundColor: const Color(0xFF4B39EF),
        actions: [
          IconButton(
            onPressed: () async {
              getTransactionsInAccount(account, network);
            },
            icon: const Icon(
              Icons.replay_outlined,
            ),
          )
        ],
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
                        return account.transactions[index]["type"] ==
                                "0x1::coin::DepositEvent"
                            ? coinItem(
                                context,
                                icon: const Icon(
                                  Icons.call_received,
                                  color: Colors.green,
                                ),
                                coin: "Recieved",
                                symbol:
                                    "${account.transactions[index]['version']}",
                                balance: account.transactions[index]["amount"],
                              )
                            : coinItem(
                                context,
                                icon: const Icon(
                                  Icons.call_made,
                                  color: Colors.red,
                                ),
                                coin: "Sent",
                                symbol:
                                    "${account.transactions[index]['version']}",
                                balance: -account.transactions[index]["amount"],
                              );
                      },
                    ),
            ),
    );
  }
}
