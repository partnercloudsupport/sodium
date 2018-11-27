import 'dart:async';

import 'package:sodium/data/model/metal.dart';

class FetchMentalHealths {}

class StoreMentalHealths {
  final List<MentalHealth> mentalHealths;

  StoreMentalHealths(this.mentalHealths);
}

class CreateMentalHealth {
  final MentalHealth mentalHealth;
  final Completer<Null> completer;

  CreateMentalHealth(this.mentalHealth, this.completer);
}
