import 'package:redux/redux.dart';
import 'package:sodium/data/model/blood_pressure.dart';
import 'package:sodium/redux/blood_pressures/blood_pressure_action.dart';

final bloodPressureReducers = combineReducers<List<BloodPressure>>([
  TypedReducer<List<BloodPressure>, FetchBloodPressureSuccess>(_fetchBloodPressureSuccess),
]);

List<BloodPressure> _fetchBloodPressureSuccess(
  List<BloodPressure> state,
  FetchBloodPressureSuccess action,
) {
  return action.bloodPressures;
}
