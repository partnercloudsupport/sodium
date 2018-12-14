import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/data/model/news.dart';
import 'package:sodium/ui/screen/news_compose/news_compose_screen.dart';

class NewsEditContainer extends StatelessWidget {
  final News news;

  NewsEditContainer({
    @required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: NewsComposeViewModel.fromStore,
      builder: (BuildContext context, NewsComposeViewModel viewModel) {
        return NewsComposeScreen(
          viewModel: viewModel,
          news: news,
          isEditing: true,
        );
      },
    );
  }
}
