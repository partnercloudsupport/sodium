import 'package:meta/meta.dart';
import 'package:sodium/data/model/loading.dart';

class NewsComposeScreenState {
  final LoadingStatus loadingStatus;

  NewsComposeScreenState({
    @required this.loadingStatus,
  });

  factory NewsComposeScreenState.initial() {
    return NewsComposeScreenState(loadingStatus: LoadingStatus.initial);
  }

  NewsComposeScreenState copyWith({LoadingStatus loadingStatus}) {
    return NewsComposeScreenState(loadingStatus: loadingStatus ?? this.loadingStatus);
  }
}
