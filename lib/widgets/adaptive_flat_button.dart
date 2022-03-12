import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptiveFlatButton extends StatelessWidget {
  final String buttonChildTextData;
  final Function buttonPressedHandler;
  final Function buttonPressedCupertinoHandler;

  AdaptiveFlatButton(
      this.buttonChildTextData, this.buttonPressedHandler, this.buttonPressedCupertinoHandler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              buttonChildTextData,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: buttonPressedCupertinoHandler)
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              buttonChildTextData,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: buttonPressedHandler);
  }
}
