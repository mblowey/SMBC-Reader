

import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String text;

  LoadingDialog(this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        CircularProgressIndicator(),
        SizedBox(height: 20),
        Center(child: Text(text)),
      ],
    );
  }

}