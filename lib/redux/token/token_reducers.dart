import 'package:redux/redux.dart';
import 'package:sodium/redux/token/token_action.dart';

final tokenReducers = combineReducers<String>([
  TypedReducer<String, StoreToken>(_saveToken),
  TypedReducer<String, DeleteToken>(_deleteToken),
]);

String _saveToken(
  String state,
  StoreToken action,
) {
  return action.token;
}

String _deleteToken(
  String state,
  DeleteToken action,
) {
  return null;
}
