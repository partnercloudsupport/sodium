import 'package:redux/redux.dart';
import 'package:sodium/data/repository/food_repository.dart';
import 'package:sodium/data/repository/prefs_repository.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/food/food_action.dart';
import 'package:sodium/redux/ui/food_add/food_add_action.dart';
import 'package:sodium/redux/ui/food_search/food_search_action.dart';

List<Middleware<AppState>> createFoodMiddleware(
  FoodRepository foodRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  final searchFood = _searchFood(foodRepository, sharedPrefRepository);
  final fetchFoodSelected = _fetchFoodSelected(foodRepository, sharedPrefRepository);

  return [
    TypedMiddleware<AppState, SearchFood>(searchFood),
    TypedMiddleware<AppState, FetchFoodSelected>(fetchFoodSelected),
  ];
}

Middleware<AppState> _searchFood(
  FoodRepository foodRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is SearchFood) {
      try {
        store.dispatch(LoadingFoodSearch());
        final foods = await foodRepository.search(action.query);

        if (foods.isEmpty) {
          store.dispatch(NotFoundFoodSearch());
          return;
        }

        store.dispatch(StoreFoodResults(foods));
        store.dispatch(SuccessFoodSearch());
      } catch (error) {
        store.dispatch(InitialFoodSearch());
      }

      next(action);
    }
  };
}

Middleware<AppState> _fetchFoodSelected(
  FoodRepository foodRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is FetchFoodSelected) {
      try {
        store.dispatch(LoadingFoodSelected());

        final food = await foodRepository.fetchFoodDetail(action.foodId);
        store.dispatch(StoreFoodSelected(food));
        store.dispatch(SuccessFoodSelected());
      } catch (error) {
        store.dispatch(InitialFoodSelected());
      }

      next(action);
    }
  };
}
