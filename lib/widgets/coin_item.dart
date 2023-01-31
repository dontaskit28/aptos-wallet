import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'snackbar.dart';

Widget coinItem(BuildContext context,
    {required icon,
    required String coin,
    required String symbol,
    required double balance}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.93,
    margin: const EdgeInsets.all(6),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(
        color: Color(0xFF4B39EF),
        width: 2,
      ),
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 24,
            child: icon,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                coin,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: symbol,
                    ),
                  );
                  snackBar(context, "Copied", "info");
                },
                child: Text(coin == "Sent" || coin == "Recieved"
                    ? "Transaction: $symbol"
                    : symbol),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                coin == "Recieved"
                    ? "+${balance.toStringAsFixed(3)} APT"
                    : "${balance.toStringAsFixed(3)} APT",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: coin == "Sent" ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
