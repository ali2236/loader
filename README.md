# Loader

Sometimes you need to load some data before building your widget.
Because `initState` doesn't support asynchronous loading you need to find another way to load your data.
The most common way of loading data is using a `FutureBuilder` but FutureBuilders are tedious.
Another way is using flags to rebuild the widget after all the loading is done.

Loader uses the flag method.

### LoadingMixin
The `LoadingMixin` adds all the necessary flags to your stateful widget's state to turn it to a 
FutureBuilder like widget.

their are two flags:

1. loading : true if the load function is still running
2. hasError: true if the load function has thrown an exception.

the exception text is stored in the `error` variable.
 
```dart
class DataRow extends StatefulWidget {
  
  final int index;
  
  DataRow({Key key, this.index}) : super(key: key);
  
  @override
  _DataRowState createState() => _DataRowState();
}

class _DataRowState extends State<DataRow> with LoadingMixin<DataRow>{
  
  String data;
  
  @override
    Future<void> load() async{
      data = await DataProvider.getData();
    }
  
  @override
  Widget build(BuildContext context) {
    if(loading) return Container();
    if(hasError) return Text(error);
    return Text(data);
  }
}
```

### StatelessLoadingMixin

For this mixin to work, you need to delete the `build` method and use the `futureBuild` method instead.

```dart
class FutureText extends StatelessWidget with StatelessLoadingMixin {
  final Future<String> futureText;
  final TextStyle style;

  FutureText(this.futureText, {this.style});

  String text;

  @override
  Future<void> load() async {
    text = await futureText;
  }

  @override
  Widget futureBuild(BuildContext context) {
    return Text(
      text,
      style: style,
    );
  }
}
```

### Loader
Loader is a widget which uses the `LoadingMixin` mixin.

This widget will run it's builder method, only after the load function is done.

The builder will get the value returned in the load function as the `value` parameter.

```dart
class Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Loader<String>(
          load: () async{
            return await retriveBannerText();
          },
          builder: (context, value){
            return Text(value);
          },
          errorBuilder: (error) => Text(error, style: TextStyle(color: Colors.red),),
        ),
      ),
    );
  }
}

```

### Implementations details

StatelessLoadingMixin is implemented using the Loader widget.

The Loader widget is implemented using LoadingMixin.

LoadingMixin is implemented using flags on a stateful widget.
