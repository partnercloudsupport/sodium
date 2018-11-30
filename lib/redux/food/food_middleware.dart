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
  final searchFood = _searchFood(foodRepository);
  final fetchFoodSelected = _fetchFoodSelected(foodRepository);
  final createUserFood = _createFood(foodRepository);
  final fetchUserFoods = _fetchUserFoods(foodRepository);

  return [
    TypedMiddleware<AppState, SearchFood>(searchFood),
    TypedMiddleware<AppState, FetchFoodSelected>(fetchFoodSelected),
    TypedMiddleware<AppState, CreateFoodUser>(createUserFood),
    TypedMiddleware<AppState, FetchFoodsUser>(fetchUserFoods),
  ];
}

Middleware<AppState> _searchFood(
  FoodRepository foodRepository,
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

Middleware<AppState> _createFood(
  FoodRepository foodRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is CreateFoodUser) {
      try {
        await foodRepository.createUserFood(action.food);
        store.dispatch(FetchFoodsUser());

        action.completer.complete(null);
      } catch (error) {}

      next(action);
    }
  };
}

Middleware<AppState> _fetchUserFoods(
  FoodRepository foodRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is FetchFoodsUser) {
      try {
        final foods = await foodRepository.fetchUserFoods();
        store.dispatch(StoreFoodsUser(foods));
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
