import 'dart:async';

import 'package:sodium/data/model/blood_pressure.dart';

class FetchBloodPressureSuccess {
  final List<BloodPressure> bloodPressures;

  FetchBloodPressureSuccess(this.bloodPressures);
}

class FetchBloodPressures {
  final Completer<Null> completer;

  FetchBloodPressures({this.completer});
}

class CreateBloodPressure {
  final BloodPressure bloodPressure;
  final Completer<Null> completer;

  CreateBloodPressure(this.bloodPressure, this.completer);
}

class UpdateBloodPressure {
  final BloodPressure bloodPressure;
  final Completer<Null> completer;

  UpdateBloodPressure(this.bloodPressure, this.completer);
}

class DeleteBloodPressure {
  final int bloodPressureId;
  final Completer<Null> completer;

  DeleteBloodPressure(this.bloodPressureId, this.completer);
}
