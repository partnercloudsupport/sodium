import 'dart:async';

import 'package:sodium/data/model/food.dart';
import 'package:sodium/ui/screen/entry_add/screen.dart';

class FetchEntries {
  final Completer<Null> completer;

  FetchEntries({this.completer});
}

class StoreEntries {
  final List<Food> entries;

  StoreEntries(this.entries);
}

class CreateEntry {
  final Completer<CreateEntryResponse> completer;
  final Food food;

  CreateEntry(this.food, this.completer);
}

class UpdateEntry {
  final Completer<CreateEntryResponse> completer;
  final Food food;

  UpdateEntry(this.food, this.completer);
}

class DeleteEntry {
  final int id;
  final Completer<Null> completer;

  DeleteEntry({this.id, this.completer});
}
