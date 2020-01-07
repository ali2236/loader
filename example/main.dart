import 'package:flutter/material.dart';
import 'package:loader/src/loadingMixin.dart';
import 'package:loader/src/loadingStatelessWidget.dart';

main() => runApp(LoaderApp());

class LoaderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: UserAppBar(),
      ),
      body: PostsPage(),
    );
  }
}

class UserAppBar extends StatefulWidget {
  @override
  _UserAppBarState createState() => _UserAppBarState();
}

class _UserAppBarState extends State<UserAppBar> with LoadingMixin<UserAppBar> {
  String _username;

  @override
  Future<void> load() async {
    _username = await getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(loading ? '...' : hasError ? 'error' : _username),
    );
  }
}

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with LoadingMixin<PostsPage> {
  List<Post> _posts;

  @override
  Future<void> load() async {
    _posts = await getPosts();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: Text('loading...'));
    if (hasError) return Text('an error accured: $error');
    return ListView(
      children: _posts
          .map(
            (post) => ListTile(
              title: Text(post.title),
            ),
          )
          .toList(),
    );
  }
}

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

class Post {
  final String title;

  Post(this.title);
}

Future<List<Post>> getPosts() async {
  return await Future.delayed(
      Duration(milliseconds: 3800),
      () => [
            Post('Flutter 1.12 released!'),
            Post('Dart 2.7 released!'),
            Post('Flutter 1.9 released!'),
            Post('Flutter 1.8 released!'),
            Post('Flutter 1.1 released!'),
            Post('Flutter 1.0 released!'),
          ]);
}

Future<String> getUsername() async {
  return await Future.delayed(Duration(seconds: 2), () => 'Aligator');
}
