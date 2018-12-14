import 'package:meta/meta.dart';
import 'package:sodium/data/model/loading.dart';

class NewsScreenState {
  final LoadingStatus loadingStatus;

  NewsScreenState({
    @required this.loadingStatus,
  });

  factory NewsScreenState.initial() {
    return NewsScreenState(
      loadingStatus: LoadingStatus.initial,
    );
  }

  NewsScreenState copyWith({LoadingStatus loadingStatus}) {
    return NewsScreenState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }
}
