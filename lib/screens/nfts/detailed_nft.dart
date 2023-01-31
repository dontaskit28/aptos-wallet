import 'package:aptos_wallet/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailedNft extends StatefulWidget {
  const DetailedNft({super.key});

  @override
  State<DetailedNft> createState() => _DetailedNftState();
}

class _DetailedNftState extends State<DetailedNft> {
  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFT Info"),
        centerTitle: true,
        backgroundColor: const Color(0xFF4B39EF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/loading.gif",
                  image: data.url,
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.9,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  eachRow(context, title: "Name", value: data.name),
                  eachRow(context, title: "Creator", value: data.creator),
                  eachRow(context, title: "Collection", value: data.collection),
                  eachRow(
                    context,
                    title: "Description",
                    value: data.description,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

eachRow(context, {required String title, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: value));
              snackBar(context, "Copied", "info");
            },
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
