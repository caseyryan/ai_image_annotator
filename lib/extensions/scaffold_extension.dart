import 'package:flutter/material.dart';

Future snackbar({
  required BuildContext context,
  required String text,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

extension ScaffoldExtension on Scaffold {
  Widget removeInsets(
    BuildContext context, {
    bool removeTop = true,
    bool removeBottom = false,
  }) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: removeTop,
      removeBottom: removeBottom,
      child: this,
    );
  }
}
