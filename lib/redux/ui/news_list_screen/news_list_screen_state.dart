import 'package:meta/meta.dart';
import 'package:sodium/data/model/loading.dart';

class NewsListScreenState {
  final LoadingStatus loadingStatus;

  NewsListScreenState({
    @required this.loadingStatus,
  });

  factory NewsListScreenState.initial() {
    return NewsListScreenState(
      loadingStatus: LoadingStatus.initial,
    );
  }

  NewsListScreenState copyWith({LoadingStatus loadingStatus}) {
    return NewsListScreenState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
