import 'package:flutter/material.dart';
import 'package:loader/src/loadingMixin.dart';

typedef LoaderCallback<T> = Future<T> Function();

class Loader<T> extends StatefulWidget {
  final LoaderCallback load;
  final Widget Function(BuildContext context, T value) builder;
  final Widget loadingWidget;
  final Widget Function(String error) errorBuilder;

  const Loader(
      {Key key,
      @required this.load,
      this.builder,
      this.loadingWidget,
      this.errorBuilder})
      : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with LoadingMixin<Loader> {
  dynamic _value;

  @override
  Future<void> load() async {
    _value = await widget.load();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return widget.loadingWidget ?? Container();
    if (hasError)
      return widget.errorBuilder != null
          ? widget.errorBuilder(error)
          : Text(error);
    return widget.builder != null
        ? widget.builder(context, _value)
        : Container();
  }
}
