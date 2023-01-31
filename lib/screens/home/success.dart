import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/snackbar.dart';

class Success extends StatefulWidget {
  final String? hash;
  const Success({super.key, this.hash});

  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    final routes = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Success"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4B39EF),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: widget.hash,
                    ),
                  );
                  snackBar(context, "Copied", "info");
                },
                child: Text(
                  textAlign: TextAlign.center,
                  routes.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                child: const Text(
                  "View on Explorer",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () async {
                  Uri url = Uri.parse(
                      "https://explorer.aptoslabs.com/txn/${routes.toString()}?network=devnet");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.inAppWebView);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
