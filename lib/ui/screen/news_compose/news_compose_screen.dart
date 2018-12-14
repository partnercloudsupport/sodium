import 'dart:async';
import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/news.dart';
import 'package:sodium/delegate/firebase_image_delegate.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/news/news_action.dart';
import 'package:sodium/redux/ui/news_compose_screen/news_compose_screen_state.dart';
import 'package:sodium/ui/common/loading/loading.dart';
import 'package:sodium/ui/common/loading/loading_container.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/utils/document_util.dart';
import 'package:sodium/utils/widget_utils.dart';
import 'package:zefyr/zefyr.dart';

class NewsComposeScreen extends StatefulWidget {
  static final String route = '/newCompose';

  final NewsComposeViewModel viewModel;
  final News news;
  final bool isEditing;

  NewsComposeScreen({
    this.viewModel,
    this.news,
    this.isEditing = false,
  });

  @override
  _NewsComposeScreenState createState() => _NewsComposeScreenState();
}

class _NewsComposeScreenState extends State<NewsComposeScreen> {
  final _formKey = GlobalKey<FormState>();

  ZefyrController _zefyrController;
  TextEditingController _titleController;
  FocusNode _zefyrFocusNode;
  FirebaseImageDelegate _imageDelegate;

  void _save() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final content = json.encode(_zefyrController.document.toJson());
    final cover = getFirstImage(_zefyrController.document);
    final news = News(
      id: widget.isEditing ? widget.news.id : null,
      title: _titleController.text,
      content: content,
      cover: cover ?? '',
      dateCreated: DateTime.now(),
    );

    Completer<Null> completer = Completer();
    completer.future.then((_) {
      showToast("ข่าวสารเผยแพร่แล้ว");
      Navigator.of(context).pop();
    });

    if (!widget.isEditing) {
      widget.viewModel.onCreate(news, completer);
    } else {
      widget.viewModel.onUpdate(news, completer);
    }
  }

  void _onStartUpload(Stream<StorageTaskEvent> event) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return LoadingDialog(title: 'กำลังอัพโหลดรูปภาพ');
      },
    );
  }

  void _onCompleteUpload() {
    hideDialog(context);
  }

  @override
  void initState() {
    _titleController = TextEditingController();
    _zefyrFocusNode = FocusNode();

    if (widget.isEditing) {
      _titleController.text = widget.news.title;
    }

    final document = widget.isEditing ? NotusDocument.fromJson(json.decode(widget.news.content)) : NotusDocument();
    _zefyrController = ZefyrController(document);

    _imageDelegate = FirebaseImageDelegate(
      onCompleteUpload: _onCompleteUpload,
      onStartUploading: _onStartUpload,
    );

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _zefyrFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        elevation: 1.0,
        title: Text(widget.isEditing ? 'แก้ไขข่าวสาร' : 'สร้างข่าวสาร'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _save,
          ),
        ],
      ),
      body: LoadingContainer(
        loadingStatus: widget.viewModel.state.loadingStatus,
        loadingContent: Loading(title: 'กำลังบันทึก'),
        initialContent: ZefyrScaffold(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    style: Style.title,
                    validator: (String value) => value.isEmpty ? 'กรุณากรอกชื่อเรื่อง' : null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "ชื่อเรื่อง", labelStyle: TextStyle(fontSize: 18.0)),
                    onFieldSubmitted: (String value) => FocusScope.of(context).requestFocus(_zefyrFocusNode),
                  ),
                  Expanded(
                    child: ZefyrField(
                      decoration: InputDecoration(labelText: 'เนื้อหา'),
                      autofocus: true,
                      enabled: true,
                      controller: _zefyrController,
                      focusNode: _zefyrFocusNode,
                      imageDelegate: _imageDelegate,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NewsComposeViewModel {
  final Function(News, Completer<Null>) onCreate;
  final Function(News, Completer<Null>) onUpdate;

  final Function onUploadImage;
  final NewsComposeScreenState state;

  NewsComposeViewModel({
    @required this.onUpdate,
    @required this.onCreate,
    @required this.onUploadImage,
    @required this.state,
  });

  static NewsComposeViewModel fromStore(Store<AppState> store) {
    return NewsComposeViewModel(
      onCreate: (News news, Completer<Null> completer) => store.dispatch(AddNews(news, completer)),
      onUpdate: (News news, Completer<Null> completer) => store.dispatch(UpdateNews(news, completer)),
      state: store.state.uiState.newsComposeScreenState,
      onUploadImage: () {},
    );
  }
}
