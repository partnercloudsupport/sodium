import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/ui/screen/entry_stats/screen.dart';

class EntryStatsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: EntryStatsScreenViewModel.fromStore,
      builder: (BuildContext context, EntryStatsScreenViewModel viewModel) {
        return EntryStatsScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}
