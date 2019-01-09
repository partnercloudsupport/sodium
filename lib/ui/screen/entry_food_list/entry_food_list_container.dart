import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/entry_food_list/entry_food_list.dart';

class EntryFoodListContainer extends StatelessWidget {
  final DateTime dateTime;

  EntryFoodListContainer({
    @required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: EntryFoodListViewModel.fromStore,
      builder: (BuildContext context, EntryFoodListViewModel viewModel) {
        return EntryFoodList(
          datetime: dateTime,
          viewModel: viewModel,
        );
      },
    );
  }
}
