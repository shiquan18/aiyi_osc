import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NewsDetailPage extends StatefulWidget {
  final String id;

  NewsDetailPage({Key key, this.id}) : super(key: key);

  @override
  _NewsDetailPage createState() => _NewsDetailPage();
}

class _NewsDetailPage extends State<NewsDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      '_NewsDetailPage',
      textAlign: TextAlign.center,
    ));
  }
}
