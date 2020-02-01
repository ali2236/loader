import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool loading;
  bool hasError;
  bool _loaded;
  String error;

  // put your async initiating logic in load
  Future<void> load();

  // recalls load and rebuilds the widgets
  void reload() {
    setState(() {
      _load();
    });
  }

  void _load() {
    loading = true;
    hasError = false;
    _loaded = false;
    error = '';
    if (!_loaded) {
      _loaded = true;
      load().then((data) {
        if (mounted)
          setState(() {
            loading = false;
          });
      }).catchError((e) {
        if (mounted)
          setState(() {
            loading = false;
            hasError = true;
            error = e.toString();
          });
      });
    }
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }
}
