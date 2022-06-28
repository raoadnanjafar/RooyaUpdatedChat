import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showAlertDialog(
    {BuildContext? context,
    Function()? done,
    Function()? cancel,
    String? content = 'You want to delete it?'}) {
  showDialog(
      context: context!,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("Alert"),
          actions: [
            CupertinoDialogAction(onPressed: cancel, child: Text("Cancel")),
            CupertinoDialogAction(onPressed: done, child: Text("Ok")),
          ],
          content: Text(content.toString()),
        );
      });
}
