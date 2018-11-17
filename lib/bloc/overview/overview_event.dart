import 'dart:async';

import 'package:sodium/data/model/food.dart';

class CreateEntryEvent {
  final Food food;
  final Completer<Null> completer;

  CreateEntryEvent(this.food, this.completer);
}
