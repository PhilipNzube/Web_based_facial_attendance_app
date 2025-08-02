import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/online_webview_controller.dart';

void showErrorDialog(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(
          'An error occurred: $error',
          style: const TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<OnlineWebViewController>(context, listen: false)
                  .refreshData(context);
            },
          ),
        ],
      );
    },
  );
}
