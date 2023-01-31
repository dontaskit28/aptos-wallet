import 'dart:convert';
import 'dart:math';
import 'package:aptos_wallet/services/balance.dart';
import 'package:aptosdart/aptosdart.dart';
import 'package:http/http.dart' as http;
import '../providers/account.dart';
import '../providers/network.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

getAccountTransactions(Account account, Network network) async {
  network.transactionLoading = true;
  if (account.account == null) {
    account.transactions = [];
    network.transactionLoading = false;
    return;
  }
  HttpLink link = HttpLink(
    "https://indexer-devnet.staging.gcp.aptosdev.com/v1/graphql",
  );
  GraphQLClient gqlClient = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );
  try {
    QueryResult queryResult = await gqlClient.query(
      QueryOptions(
        document: gql("""
          query AccountTransactionsData {
            move_resources(
            where: {
              address: {
                _eq: "${account.account!.address()}"
              }
            }
            order_by: {
              transaction_version: desc
              }    
            distinct_on:
              transaction_version    
              limit:12
            ){
              transaction_version          
            }
          }
        """),
      ),
    );
    var temp = [];
    for (var element in queryResult.data!["move_resources"]) {
      temp.add(element["transaction_version"]);
    }
    for (var version in temp.reversed) {
      if (account.transVersion.contains(version)) {
        continue;
      } else {
        var result = await balanceChange(version, account.account!.address());
        if ((result["balance"] != 0 && result["reciever"] != "") ||
            result["collection"] != "" ||
            result["name"] != "") {
          account.addTransaction(result);
          account.addVersion(version);
          network.transactionLoading = false;
        }
      }
    }
    await getBalance(account);
  } catch (e) {}
  network.transactionLoading = false;
}

Future<Map> balanceChange(int version, String address) async {
  var response = await http.get(
    Uri.parse(
        "https://fullnode.devnet.aptoslabs.com/v1/transactions/by_version/$version"),
  );
  var result = jsonDecode(response.body);
  var events = result["events"];
  var type = result["type"];
  String reciever = "";
  double balance = 0;
  String collection = "";
  String name = "";
  if (type == "user_transaction") {
    for (var event in events) {
      if (event["type"] == "0x1::coin::DepositEvent") {
        if (event["guid"]["account_address"] == address) {
          balance = (double.parse(event["data"]["amount"])) / pow(10, 8);
        } else {
          reciever = event["guid"]["account_address"];
        }
      } else if (event["type"] == "0x1::coin::WithdrawEvent") {
        if (event["guid"]["account_address"] == address) {
          balance = ((double.parse(event["data"]["amount"])) / pow(10, 8)) * -1;
        } else {
          reciever = event["guid"]["account_address"];
        }
      } else if (event["type"] == "0x3::token::MintTokenEvent") {
        name = event["data"]["id"]["name"];
      } else if (event["type"] == "0x3::token::CreateCollectionEvent") {
        collection = event["data"]["collection_name"];
      }
    }
  }
  return {
    "reciever": reciever,
    "balance": balance,
    "collection": collection,
    "name": name,
  };
}

getTransactionsInAccount(Account account, Network network) async {
  if (account.account == null) {
    return;
  }
  network.transactionLoading = true;
  final transactionsList = await AptosClient()
      .getAccountCoinTransactions(address: account.account!.address());

  List<Map> temp = [];
  for (var transaction in transactionsList) {
    temp.add({
      "version": transaction.hash,
      "type": transaction.type,
      "amount":
          double.parse(transaction.payload!.arguments!.first) / pow(10, 8),
    });
  }
  account.transactions = temp;
  network.transactionLoading = false;
}
