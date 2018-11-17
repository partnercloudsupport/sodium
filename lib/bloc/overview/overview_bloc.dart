import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sodium/bloc/overview/overview_event.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/loading_status.dart';
import 'package:sodium/data/repository/entry_repository.dart';
import 'package:sodium/utils/widget_utils.dart';

class OverviewBloc extends BlocBase {
  OverviewBloc() {
    _entryCreateController.stream.listen((CreateEntryEvent event) {
      _createEntry(event);
    });

    _getEntries();
  }

  EntryRepository _entryRepository = EntryRepository();

  //@formatter:off

  // Entry Create
  StreamController<CreateEntryEvent> _entryCreateController = StreamController.broadcast();
  Stream<CreateEntryEvent> get outEntryCreate => _entryCreateController.stream;
  Sink<CreateEntryEvent> get inEntryCreate => _entryCreateController.sink;

  // Entry Create Loading
  BehaviorSubject<LoadingStatus> _entryCreateLoadingController = BehaviorSubject<LoadingStatus>();
  Stream<LoadingStatus> get outFoodDetailLoading => _entryCreateLoadingController.stream;

  BehaviorSubject<List<Food>> _todayEntryController = BehaviorSubject<List<Food>>();
  Stream<List<Food>> get outTodayEntry => _todayEntryController.stream;
  Sink<List<Food>> get _inTodayEntry => _todayEntryController.sink;

  //@formatter:on

  void _createEntry(CreateEntryEvent event) async {
    try {
      await _entryRepository.create(event.food);
      event.completer.complete(null);
      showToast('บันทึกแล้ว');
      _getEntries();
    } catch (error) {
      event.completer.completeError(error);
    }
  }

  void _getEntries() async {
    try {
      final foods = await _entryRepository.getEntries();
      _inTodayEntry.add(foods);
    } catch (error) {
      print(error);
    }
  }

  @override
  void dispose() {
    _entryCreateLoadingController.close();
    _entryCreateController.close();

    _todayEntryController.close();
  }
}
