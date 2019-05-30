import 'dart:convert';

import 'package:aiyi_osc/api/Api.dart';
import 'package:aiyi_osc/constants/Constants.dart';
import 'package:aiyi_osc/util/NetUtils.dart';
import 'package:aiyi_osc/widgets/CommonEndLine.dart';
import 'package:aiyi_osc/widgets/SlideView.dart';
import 'package:aiyi_osc/widgets/SlideViewIndicator.dart';
import 'package:flutter/material.dart';

import 'NewsDetailPage.dart';

final slideViewIndicatorStateKey = GlobalKey<SlideViewIndicatorState>();

class NewsListPage extends StatefulWidget {
  @override
  _NewsListPage createState() => _NewsListPage();
}

class _NewsListPage extends State<NewsListPage> {
  final ScrollController _controller = ScrollController();
  final TextStyle titleTextStyle = TextStyle(fontSize: 15.0);
  final TextStyle subtitleStyle =
      TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);

  var listData;
  var slideData;
  var curPage = 1;

  SlideView slideView;
  var listTotalSize = 0;
  SlideViewIndicator indicator;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if (maxScroll == pixels && listData.length < listTotalSize) {
        curPage++;
        getNewsList(true);
      }
    });
    getNewsList(false);
  }

  @override
  Widget build(BuildContext context) {
    if (listData == null) {
      return Center(
        // CircularProgressIndicator是一个圆形的Loading进度条
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        itemBuilder: (context, i) => renderRow(i),
        controller: _controller,
        itemCount: listData.length * 2,
      );
      return RefreshIndicator(
        child: listView,
        onRefresh: _pullToRefresh,
      );
    }
  }

  getNewsList(bool isLoadMore) {
    String url = Api.newsList;
    url += "?pageIndex=$curPage&pageSize=10";
    NetUtils.get(url).then((data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['code'] == 0) {
          // code=0表示请求成功
          var msg = map['msg'];
          // total表示资讯总条数
          listTotalSize = msg['news']['total'];
          // data为数据内容，其中包含slide和news两部分，分别表示头部轮播图数据，和下面的列表数据
          var _listData = msg['news']['data'];
          var _slideData = msg['slide'];
          setState(() {
            if (!isLoadMore) {
              listData = _listData;
              slideData = _slideData;
            } else {
              List list1 = List();
              list1.addAll(listData); // 添加原来的数据
              list1.addAll(_listData); // 添加新取到的数据
              // 判断是否获取了所有的数据，如果是，则需要显示底部的"我也是有底线的"布局
              if (list1.length >= listTotalSize) {
                list1.add(Constants.endLineTag);
              }

              // 给列表数据赋值
              listData = list1;
              // 轮播图数据
              slideData = _slideData;
            }
            initSlider();
          });
        }
      }
    });
  }

  void initSlider() {
    indicator =
        SlideViewIndicator(slideData.length, key: slideViewIndicatorStateKey);
    slideView = SlideView(slideData, indicator, slideViewIndicatorStateKey);
  }

  Future<Null> _pullToRefresh() {
    curPage = 1;
    getNewsList(false);
    return null;
  }

  Widget renderRow(i) {
    if (i == 0) {
      return Container(
          height: 180.0,
          child: Stack(
            children: <Widget>[
              slideView,
              Container(
                alignment: Alignment.bottomCenter,
                child: indicator,
              )
            ],
          ));
    }
    i -= 1;
    if (i.isOdd) {
      return Divider(height: 1.0);
    }
    i = i ~/ 2;
    var itemData = listData[i];
    if (itemData is String && itemData == Constants.endLineTag) {
      return CommonEndLine();
    }
    var titleRow = Row(
      children: <Widget>[
        Expanded(
          child: Text(itemData['title'], style: titleTextStyle),
        )
      ],
    );
    var timeRow = Row(
      children: <Widget>[
        Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFECECEC),
            image: DecorationImage(
                image: NetworkImage(itemData['authorImg']), fit: BoxFit.cover),
            border: Border.all(
              color: const Color(0xFFECECEC),
              width: 2.0,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
          child: Text(
            itemData['timeStr'],
            style: subtitleStyle,
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text("${itemData['commCount']}", style: subtitleStyle),
              Image.asset('./images/ic_comment.png', width: 16.0, height: 16.0),
            ],
          ),
        )
      ],
    );
    var thumbImgUrl = itemData['thumb'];
    var thumbImg = Container(
      margin: const EdgeInsets.all(10.0),
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFECECEC),
        image: DecorationImage(
            image: ExactAssetImage('./images/ic_img_default.jpg'),
            fit: BoxFit.cover),
        border: Border.all(
          color: const Color(0xFFECECEC),
          width: 2.0,
        ),
      ),
    );
    if (thumbImgUrl != null && thumbImgUrl.length > 0) {
      thumbImg = Container(
        margin: const EdgeInsets.all(10.0),
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFECECEC),
          image: DecorationImage(
              image: NetworkImage(thumbImgUrl), fit: BoxFit.cover),
          border: Border.all(
            color: const Color(0xFFECECEC),
            width: 2.0,
          ),
        ),
      );
    }
    var row = Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                titleRow,
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: timeRow,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 100.0,
            height: 80.0,
            color: const Color(0xFFECECEC),
            child: Center(
              child: thumbImg,
            ),
          ),
        )
      ],
    );
    return InkWell(
      child: row,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => NewsDetailPage(id: itemData['detailUrl'])));
      },
    );
  }
}
