import 'package:flutter/material.dart';

class CommonWebPage extends StatefulWidget {
  final String title;
  final String url;

  CommonWebPage({Key key, this.title, this.url}) : super(key: key);

  @override
  _CommonWebPage createState() => _CommonWebPage();
}

class _CommonWebPage extends State<CommonWebPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      'CommonWebPage',
      textAlign: TextAlign.center,
    ));
  }
}
