import 'package:aptos_wallet/providers/account.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BalanceInput extends StatefulWidget {
  TextEditingController controller;
  BalanceInput({super.key, required this.controller});

  @override
  State<BalanceInput> createState() => _BalanceInputState();
}

class _BalanceInputState extends State<BalanceInput> {
  List dropdownItemList = ["APT", "SOL", "BTC"];
  String first = "APT";
  bool isInvalidBal = false;
  @override
  Widget build(BuildContext context) {
    Account provider = Provider.of<Account>(context, listen: true);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF4B39EF),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  if (value != "" &&
                      ((double.tryParse(value) ?? 0) > provider.balance ||
                          (double.tryParse(value) ?? 0) <= 0)) {
                    isInvalidBal = true;
                  } else {
                    isInvalidBal = false;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: "0.0",
                hintStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 28,
                ),
                labelText: "Balance",
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 28,
                color: isInvalidBal ? Colors.red : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     margin: const EdgeInsets.fromLTRB(2, 0, 5, 0),
          //     child: DropdownButtonHideUnderline(
          //       child: DropdownButton(
          //         value: first,
          //         onChanged: (value) {
          //           setState(() {
          //             first = value as String;
          //           });
          //         },
          //         borderRadius: BorderRadius.circular(10),
          //         dropdownColor: Theme.of(context).primaryColor,
          //         icon: const Icon(Icons.arrow_drop_down),
          //         iconEnabledColor: Colors.white,
          //         items: dropdownItemList
          //             .map((e) => DropdownMenuItem(
          //                   value: e,
          //                   child: Text(
          //                     e,
          //                     style: const TextStyle(
          //                       color: Colors.white,
          //                     ),
          //                   ),
          //                 ))
          //             .toList(),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
