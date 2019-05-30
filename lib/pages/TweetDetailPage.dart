import 'package:flutter/material.dart';

class TweetDetailPage extends StatefulWidget {
  final Map<String, dynamic> tweetData;

  TweetDetailPage({Key key, this.tweetData}) : super(key: key);

  @override
  _TweetDetailPage createState() => _TweetDetailPage();
}

class _TweetDetailPage extends State<TweetDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'TweetDetailPage',
      textAlign: TextAlign.center,
    ));
  }
}
