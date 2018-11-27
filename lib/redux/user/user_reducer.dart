import 'package:redux/redux.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/user/user_action.dart';

final userReducers = combineReducers<User>([
  TypedReducer<User, StoreUser>(_storeUser),
]);

User _storeUser(
  User state,
  StoreUser action,
) {
  return action.user;
}
