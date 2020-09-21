import 'package:flutter/material.dart';

Future<bool> showConfirmDialog(BuildContext context, {String title = '', String message = ''}) async {
  var result = false;

  var dialog = AlertDialog(
    title: Text(title),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Colors.black87,
      ),
    ),
    actions: [
      FlatButton(
        child: Text('Cancel'),
        onPressed: () {
          result = false;
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: Text('Ok'),
        onPressed: () {
          result = true;
          Navigator.of(context).pop();
        },
      ),
    ],
  );

  await showDialog(
    context: context,
    builder: (context) {
      return dialog;
    },
  );

  return result;
}
