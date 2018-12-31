import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/ui/seasoning_section/seasoning_section.dart';

class SeasoningContainer extends StatelessWidget {
  final Function(List<Seasoning> seasonings, int totalSodium) onSelected;

  SeasoningContainer({
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: SeasoningSectionViewModel.fromStore,
      builder: (BuildContext context, SeasoningSectionViewModel viewModel) {
        return SeasoningSection(
          viewModel: viewModel,
          onSelected: onSelected,
        );
      },
    );
  }
}
