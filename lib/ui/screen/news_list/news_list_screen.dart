import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/news.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/news/news_action.dart';
import 'package:sodium/redux/ui/news_list_screen/news_list_screen_state.dart';
import 'package:sodium/ui/common/loading/loading_shimmer.dart';
import 'package:sodium/ui/screen/news/news_container.dart';
import 'package:sodium/ui/screen/news_compose/news_compose_screen.dart';

class NewsListScreen extends StatefulWidget {
  static final String route = '/newsList';

  final NewsListViewModel viewModel;

  NewsListScreen({
    this.viewModel,
  });

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

// ignore: mixin_inference_inconsistent_matching_classes
class _NewsListScreenState extends State<NewsListScreen> with AfterLayoutMixin<NewsListScreen>, SingleTickerProviderStateMixin {
  static GlobalKey<RefreshIndicatorState> _newsRefreshIndicatorKey;

  Widget _buildAppBar() {
    return SliverAppBar(
      snap: true,
      floating: true,
      elevation: 1.0,
      forceElevated: true,
      title: Text('ข่าวสาร'),
      centerTitle: true,
    );
  }

  void _showNewsCompose() {
    Navigator.of(context).pushNamed(NewsComposeScreen.route);
  }

  void _showNews(News news) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => NewsContainer(news: news)));
  }

  Widget _buildNews() {
    return RefreshIndicator(
      key: _newsRefreshIndicatorKey,
      onRefresh: () async {
        Completer<Null> completer = Completer();
        widget.viewModel.onRefresh(completer);

        return completer.future;
      },
      child: widget.viewModel.news.isNotEmpty
          ? CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.only(top: 8.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final news = widget.viewModel.news[index];

                        return NewsItem(
                          news: news,
                          onPressed: () => _showNews(news),
                        );
                      },
                      childCount: widget.viewModel.news.length,
                    ),
                  ),
                )
              ],
            )
          : Container(),
    );
  }

  @override
  void initState() {
    _newsRefreshIndicatorKey = new GlobalObjectKey<RefreshIndicatorState>('__general');

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    //;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      floatingActionButton: widget.viewModel.user.isAdmin
          ? FloatingActionButton(
              onPressed: _showNewsCompose,
              elevation: 1.0,
              child: Icon(FontAwesomeIcons.pencilAlt),
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            _buildAppBar(),
          ];
        },
        body: _buildNews(),
      ),
    );
  }
}

class NewsListViewModel {
  final List<News> news;
  final User user;
  final NewsListScreenState state;
  final Function(Completer<Null> completer) onRefresh;

  NewsListViewModel({
    @required this.news,
    @required this.state,
    @required this.onRefresh,
    @required this.user,
  });

  static NewsListViewModel fromStore(Store<AppState> store) {
    return NewsListViewModel(
      news: store.state.news,
      state: store.state.uiState.newsListScreenState,
      user: store.state.user,
      onRefresh: (Completer<Null> completer) => store.dispatch(FetchNews(completer: completer)),
    );
  }
}

class NewsItem extends StatelessWidget {
  final News news;
  final VoidCallback onPressed;

  NewsItem({
    this.news,
    this.onPressed,
  });

  Widget _buildVideoTitle(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            news.title,
            textAlign: TextAlign.start,
            style: Style.title,
          ),
        ),
      ],
    );
  }

  Widget _buildDateCreated() {
    final formatter = DateFormat('dd MMM yyy');
    final date = formatter.format(news.dateCreated);

    return Text(
      date,
      style: TextStyle(color: Colors.black54),
    );
  }

  Widget _buildDiffDate(BuildContext context) {
    return Text(
      news.diff,
      style: TextStyle(color: Colors.black54),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        margin: EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //_buildDiffDate(context),
            _buildVideoTitle(context),
            SizedBox(height: 4.0),
            CachedNetworkImage(
              fit: BoxFit.cover,
              height: 200.0,
              width: 500.0,
              imageUrl: news.cover ?? 'https://increasify.com.au/wp-content/uploads/2016/08/default-image.png',
              placeholder: ShimmerLoading.square(),
            ),
          ],
        ),
      ),
    );
  }
}
