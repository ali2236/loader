
import 'package:flutter/material.dart';
import 'package:loader/loader.dart';

mixin StatelessLoadingMixin<T> on StatelessWidget {

  Future<void> load();

  Widget futureBuild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Loader(
      load: () async{
        await load();
      },
      builder: (context, _){
        return futureBuild(context);
      },
    );
  }

}