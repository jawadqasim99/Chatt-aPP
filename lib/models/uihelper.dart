import 'package:flutter/material.dart';

class UIHelper {
  static void showLoadingDailog(BuildContext context, String title) {
    AlertDialog loadingalert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 30,
          ),
          Text(title)
        ],
      ),
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return loadingalert;
        });
  }

  static void showAlertDailog(
      BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }
}
