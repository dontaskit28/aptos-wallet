import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddressBox extends StatefulWidget {
  final TextEditingController controller;
  const AddressBox({super.key, required this.controller});

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF4B39EF),
          width: 1,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () async {
              final clipboardData =
                  await Clipboard.getData(Clipboard.kTextPlain);
              setState(() {
                widget.controller.text = clipboardData?.text as String;
              });
            },
            child: const Icon(
              Icons.paste_rounded,
              color: Color(0xFF4B39EF),
            ),
          ),
          hintText: "Recevier's Address",
          hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 18,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(10),
        ),
        keyboardType: TextInputType.multiline,
        maxLines: 5,
        minLines: 2,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
