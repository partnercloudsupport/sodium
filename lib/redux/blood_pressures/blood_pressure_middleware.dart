import 'package:redux/redux.dart';
import 'package:sodium/data/repository/blood_pressure_repository.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/blood_pressures/blood_pressure_action.dart';

List<Middleware<AppState>> createBloodPressureMiddleware(
  BloodPressureRepository bloodPressureRepository,
) {
  return [
    TypedMiddleware<AppState, CreateBloodPressure>(
      _createBloodPressure(bloodPressureRepository),
    ),
    TypedMiddleware<AppState, UpdateBloodPressure>(
      _updateBloodPressure(bloodPressureRepository),
    ),
    TypedMiddleware<AppState, DeleteBloodPressure>(
      _deleteBloodPressure(bloodPressureRepository),
    ),
    TypedMiddleware<AppState, FetchBloodPressures>(
      _fetchBloodPressure(bloodPressureRepository),
    ),
  ];
}

Middleware<AppState> _createBloodPressure(
  BloodPressureRepository bloodPressureRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is CreateBloodPressure) {
      try {
        await bloodPressureRepository.createBloodPressure(action.bloodPressure);

        action.completer.complete(null);
        next(FetchBloodPressures());
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _updateBloodPressure(
  BloodPressureRepository bloodPressureRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is UpdateBloodPressure) {
      try {
        await bloodPressureRepository.updateBloodPressure(action.bloodPressure);

        action.completer.complete(null);
        next(FetchBloodPressures());
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _deleteBloodPressure(
  BloodPressureRepository bloodPressureRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is DeleteBloodPressure) {
      try {
        await bloodPressureRepository.deleteBloodPressure(action.bloodPressureId);

        action.completer.complete(null);
        next(FetchBloodPressures());
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _fetchBloodPressure(
  BloodPressureRepository bloodPressureRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchBloodPressures) {
      try {
        final bloodPressures = await bloodPressureRepository.fetchBloodPressures();
        action.completer?.complete(null);
        next(FetchBloodPressureSuccess(bloodPressures));
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
