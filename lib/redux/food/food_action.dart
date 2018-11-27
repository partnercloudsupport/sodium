import 'package:sodium/data/model/food.dart';

class SearchFood {
  final String query;

  SearchFood(this.query);
}

class StoreFoodResults {
  final List<Food> foods;

  StoreFoodResults(this.foods);
}

class FetchFoodSelected {
  final int foodId;

  FetchFoodSelected(this.foodId);
}

class StoreFoodSelected {
  final Food food;

  StoreFoodSelected(this.food);
}
