import 'package:flutter/material.dart';

mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool loading = true;
  bool hasError = false;
  bool _loaded = false;
  String error = 'no error!';

  // put your async initiating logic in load
  Future<void> load();

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
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
  }
}
