import 'package:aptos_wallet/providers/account.dart';
import 'package:aptos_wallet/services/nft_data.dart';
import 'package:aptosdart/aptosdart.dart';
import 'package:aptosdart/core/table_item/table_item.dart';

getAllNfts(Account account) async {
  account.nfts = [];
  if (account.account == null) {
    return;
  }
  try {
    List data = [];
    final result = await AptosClient().getEventsByEventHandle(
        address: account.account!.address(),
        // address:
        // "0xd7bfebad501a8dc7740e0480a24d32c725ea3745b5625e89b70a2d59f11a0a08",
        eventHandleStruct: "0x3::token::TokenStore",
        fieldName: "deposit_events");

    for (var event in result) {
      data.add({
        "collection": event.eventData!.nftId!.tokenDataId!.collection,
        "creator": event.eventData!.nftId!.tokenDataId!.creator,
        "name": event.eventData!.nftId!.tokenDataId!.name,
      });
    }

    for (var tableData in data) {
      dynamic resource = await AptosClient().getResourcesByType(
          address: tableData["creator"],
          resourceType: "0x3::token::Collections");

      dynamic nftData = await AptosClient().getTableItem(
        tableHandle: resource!.data.tokenData.handle,
        tableItem: TableItem(
          keyType: "0x3::token::TokenDataId",
          valueType: "0x3::token::TokenData",
          key: tableData,
        ),
      );
      account.addNft(NFT(
        nftData.uri,
        tableData["collection"],
        tableData["creator"],
        nftData.description,
        nftData.name,
      ));
      // account.addNft({
      //   "data": nftData,
      //   "creator": tableData["creator"],
      //   "collection": tableData["collection"],
      // });
    }
  } catch (e) {}
}

// mintNft({
//   required BuildContext context,
//   required Account account,
//   required String name,
//   required String url,
//   required String collection,
// }) async {
//   if (account.account == null) {
//     return;
//   }
//   try {
//     AptosClient client = AptosClient();
//     Payload payload = Payload.fromJson({
//       "function": "0x3::token::create_collection_script",
//       "type_arguments": [],
//       "arguments": [
//         collection,
//         name,
//         "https://aptos.dev",
//         "9007199254740991",
//         [false, false, false]
//       ],
//       "type": "entry_function_payload"
//     });
//     Payload payload2 = Payload.fromJson({
//       "function": "0x3::token::create_token_script",
//       "type_arguments": [],
//       "arguments": [
//         collection,
//         name,
//         "$name minted on Devnet",
//         "1",
//         "9007199254740991",
//         url,
//         account.account!.address(),
//         "0",
//         "0",
//         [false, false, false, false, false],
//         [],
//         [],
//         []
//       ],
//       "type": "entry_function_payload"
//     });

//     final transaction = await client.generateTransaction(
//         account.account!.address(), payload, '100000');
//     final sig = await client.signTransaction(account.account!, transaction);
//     transaction.signature = sig;
//     final result = await client.submitTransaction(transaction);
//     await client.waitForTransaction(result.hash!);

//     final transaction2 = await client.generateTransaction(
//         account.account!.address(), payload2, '100000');
//     final sig2 = await client.signTransaction(account.account!, transaction2);
//     transaction2.signature = sig2;
//     final result2 = await client.submitTransaction(transaction2);
//     final transResult2 = await client.waitForTransaction(result2.hash!);

//     if (transResult2) {
//       // ignore: avoid_print
//       print(result2.hash);
//       await getAllNfts(account);
//       snackBar(context, "Minted", "success");
//     } else {
//       snackBar(context, "Failed", "error");
//     }
//   } catch (e) {}
// }
