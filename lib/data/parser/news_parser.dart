import 'package:sodium/data/model/news.dart';
import 'package:sodium/utils/date_time_util.dart';

class NewsParser {
  static List<News> parseArray(List<dynamic> array) {
    return array.map((json) => parse(json)).toList();
  }

  static News parse(dynamic json) {
    return News(
      id: json[NewsField.id],
      title: json[NewsField.title],
      content: json[NewsField.content],
      cover: json[NewsField.cover],
      dateCreated: fromMysqlDateTime(json[NewsField.createdAt]),
      //    diff: json[NewsField.diff],
    );
  }
}

abstract class NewsField {
  static final String id = 'id';
  static final String title = 'title';
  static final String content = 'content';
  static final String dueDate = 'due_date';
  static final String category = 'category';
  static final String cover = 'cover';
  static final String createdAt = 'created_at';
  static final String diff = 'diff';
  static final String location = 'location';
}
