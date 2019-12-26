import 'package:flutter/material.dart';

mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool loading = true;
  bool hasError = false;
  String error = 'no error!';

  @override
  void initState() {
    super.initState();
    load().then((data) {
      setState(() {
        loading = false;
      });
    }).catchError((e) {
      setState(() {
        loading = false;
        hasError = true;
        error = e.toString();
      });
    });
  }

  // put your async initiating logic in load
  Future<void> load();
}
