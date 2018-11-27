import 'package:sodium/data/model/food.dart';
import 'package:sodium/utils/date_time_util.dart';

List<Food> todayEntriesSelector(List<Food> entries) {
  if (entries == null) {
    return null;
  }

  DateTime now = DateTime.now();
  final todayEntries = entries.where((Food food) {
    return isSameDate(food.dateTime, now);
  });

  return todayEntries.toList();
}

int todayEatenSodiumSelector(List<Food> foods) {
  final List<Food> entries = todayEntriesSelector(foods);
  final int eaten = entries.fold(0, (accumulated, food) => food.sodium + accumulated);

  return eaten;
}
