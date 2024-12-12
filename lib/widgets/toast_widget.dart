import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, {bool position = true}) {
  Fluttertoast.showToast(
    msg: message,
    gravity: position == true ? ToastGravity.BOTTOM : ToastGravity.TOP,
    toastLength: Toast.LENGTH_SHORT,
    backgroundColor: const Color.fromARGB(199, 88, 87, 87),
  );
}
