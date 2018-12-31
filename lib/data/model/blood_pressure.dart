import 'package:sodium/ui/common/blood_pressure_status.dart';

class BloodPressure {
  final int id;
  final int systolic;
  final int diastolic;
  final BloodPressureLevel systolicLevel;
  final BloodPressureLevel diastolicLevel;
  final DateTime dateTime;

  BloodPressure({
    this.id,
    this.diastolicLevel,
    this.systolicLevel,
    this.systolic,
    this.diastolic,
    this.dateTime,
  });

  @override
  String toString() {
    return 'BloodPressure{id: $id, systolic: $systolic, diastolic: $diastolic, systolicLevel: $systolicLevel, diastolicLevel: $diastolicLevel, dateTime: $dateTime}';
  }
}
