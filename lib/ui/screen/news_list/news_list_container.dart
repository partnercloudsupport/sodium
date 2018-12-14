import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/screen/news_list/news_list_screen.dart';

class NewsListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: NewsListViewModel.fromStore,
      onDispose: (Store<AppState> store) {},
      builder: (BuildContext context, NewsListViewModel viewModel) {
        return NewsListScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
