import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

showAlertDialog(BuildContext context, String hash) async {
  Uri url =
      Uri.parse("https://explorer.aptoslabs.com/txn/$hash?network=devnet");
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Details"),
    onPressed: () async {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.inAppWebView);
      }
    },
  );

  AlertDialog alert = AlertDialog(
    title: Row(
      children: const [
        Icon(
          Icons.check_circle,
          color: Colors.green,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "Success",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ],
    ),
    content: InkWell(
        onTap: () {
          Clipboard.setData(
            ClipboardData(
              text: hash,
            ),
          );
          // snackBar(context, "Copied", "info");
        },
        child: Text("Hash: $hash")),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
