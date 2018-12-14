import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/data/model/news.dart';
import 'package:sodium/ui/screen/news/news_screen.dart';

class NewsContainer extends StatelessWidget {
  final News news;

  NewsContainer({
    @required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: NewsViewModel.fromStore,
      builder: (BuildContext context, NewsViewModel viewModel) {
        print(viewModel.user);

        return NewsScreen(
          news: news,
          viewModel: viewModel,
        );
      },
    );
  }
}
