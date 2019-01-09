import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/model/news.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/delegate/firebase_image_delegate.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/news/news_action.dart';
import 'package:sodium/redux/ui/news_screen/news_screen_state.dart';
import 'package:sodium/ui/common/dialog/confirm_dialog.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/screen/news_compose/news_edit_container.dart';
import 'package:sodium/utils/widget_utils.dart';
import 'package:zefyr/zefyr.dart';

class NewsScreen extends StatefulWidget {
  static final String route = '/news';

  final News news;
  final NewsViewModel viewModel;

  NewsScreen({
    this.news,
    this.viewModel,
  });

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  ZefyrController _controller;
  FocusNode _focusNode;
  FirebaseImageDelegate _firebaseImageDelegate;

  final List<IconData> _overflowActions = [
    Icons.edit,
    Icons.delete,
  ];

  void _showEditNews(News news, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => NewsEditContainer(news: widget.news)));
  }

  void _delete(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return ConfirmDialog(
            title: 'ต้องการลบหรือไม่',
            description: 'ข่าวสารจะหายไปและไม่สามารถกู้คืนได้',
            confirmText: 'ลบ',
            cancelText: 'ยกเลิก',
            onCancel: () {
              Navigator.of(context).pop();
            },
            onConfirm: () {
              popDialog(context); // Hide confirm dialog

              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return LoadingDialog(title: 'กำลังลบข่าวสาร');
                },
              );

              Completer<Null> completer = Completer();
              completer.future.then((_) {
                popDialog(context); // Hide LoadingDialog
                popScreen(context);

                showToast("ลบข่าวสารแล้ว");
              });

              widget.viewModel.onDelete(widget.news.id, completer);
            },
          );
        });
  }

  @override
  void initState() {
    final document = NotusDocument.fromJson(json.decode(widget.news.content));
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
    _firebaseImageDelegate = FirebaseImageDelegate();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text('ข่าวสาร'),
        actions: widget.viewModel.user.isAdmin
            ? <Widget>[
                PopupMenuButton<String>(
                  onSelected: (item) {
                    if (item == 'edit') {
                      _showEditNews(widget.news, context);
                    }

                    if (item == 'delete') {
                      _delete(context);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('แก้ไข'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('ลบ'),
                      )
                    ];
                  },
                ),
              ]
            : [],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          focusNode: _focusNode,
          enabled: false,
          controller: _controller,
          imageDelegate: _firebaseImageDelegate,
        ),
      ),
    );
  }
}

class NewsViewModel {
  final NewsScreenState state;
  final Function(int, Completer<Null>) onDelete;
  final User user;

  NewsViewModel({
    this.state,
    this.onDelete,
    this.user,
  });

  static NewsViewModel fromStore(Store<AppState> store) {
    return NewsViewModel(
      // state: store.state.newsScreenState,
      onDelete: (int newsId, Completer<Null> completer) {
        store.dispatch(DeleteNews(newsId, completer));
      },
      user: store.state.user,
    );
  }
}
