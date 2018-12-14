import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/news_compose/news_compose_screen.dart';

class NewsComposeContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: NewsComposeViewModel.fromStore,
      builder: (BuildContext context, NewsComposeViewModel viewModel) {
        return NewsComposeScreen(viewModel: viewModel);
      },
    );
  }
}
