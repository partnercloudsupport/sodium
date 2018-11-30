import 'dart:async';

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

class CreateFoodUser {
  final Food food;
  final Completer<Null> completer;

  CreateFoodUser(this.food, this.completer);
}

class FetchFoodsUser {}

class StoreFoodsUser {
  final List<Food> food;

  StoreFoodsUser(this.food);
}
