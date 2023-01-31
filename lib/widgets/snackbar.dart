import 'package:flutter/material.dart';

snackBar(BuildContext context, String message, String variant) {
  Color backgroundColor = Theme.of(context).primaryColor;
  if (variant == 'error') {
    backgroundColor = Colors.red.shade400;
  } else if (variant == 'success') {
    backgroundColor = Colors.green.shade500;
  } else if (variant == "info") {
    backgroundColor = Colors.grey.shade600;
  }

  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: backgroundColor,
      content: Text(message),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
