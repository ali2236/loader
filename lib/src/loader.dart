import 'dart:async';
import 'package:flutter/material.dart';
import 'package:loader/src/loadingMixin.dart';

typedef LoaderCallback<T> = Future<T> Function();
typedef WidgetValueBuilder<T> = Widget Function(BuildContext context, T value);

class Loader<T> extends StatefulWidget {
  final bool autoReload;
  final LoaderCallback<T> load;
  final WidgetValueBuilder<T>? builder;
  final Widget? loadingWidget;
  final Widget Function(String error)? errorBuilder;

  const Loader({
    Key? key,
    required this.load,
    this.autoReload = true,
    this.builder,
    this.loadingWidget,
    this.errorBuilder,
  }) : super(key: key);

  static LoadingMixin of(BuildContext context) {
    return context.findAncestorStateOfType<_LoaderState>() as LoadingMixin;
  }

  @override
  _LoaderState<T> createState() => _LoaderState<T>();
}

class _LoaderState<T> extends State<Loader<T>> with LoadingMixin<Loader<T>> {
  late T _value;

  @override
  Future<void> load() async {
    _value = await widget.load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return widget.loadingWidget ?? Container();
    if (hasError)
      return widget.errorBuilder != null
          ? widget.errorBuilder!(error)
          : Text(error);
    return widget.builder != null
        ? widget.builder!(context, _value)
        : Container();
  }
}
