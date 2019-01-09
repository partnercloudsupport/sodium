import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/ui/common/chip.dart';
import 'package:sodium/ui/common/food/seasoning_options.dart';
import 'package:sodium/ui/common/section/section.dart';
import 'package:sodium/ui/common/tile.dart';
import 'package:sodium/utils/string_util.dart';
import 'package:sodium/utils/widget_utils.dart';

class SeasoningSelectionSection extends StatefulWidget {
  final SeasoningSectionViewModel viewModel;
  final Function(List<Seasoning> seasonings, int totalSodium) onSelected;

  SeasoningSelectionSection({
    this.viewModel,
    this.onSelected,
  });

  @override
  _SeasoningSelectionSectionState createState() => _SeasoningSelectionSectionState();
}

class _SeasoningSelectionSectionState extends State<SeasoningSelectionSection> {
  List<Seasoning> selectedSeasonings = [];
  int selectedSeasoningTotalSodium = 0;

  void _showSeasoningOptions(Seasoning seasoning) {
    final seasoningOptions = SeasoningOptions(
      seasoning: seasoning,
      onSave: (amount, unit) {
        popDialog(context);

        setState(() {
          final selectedSeasoning = seasoning.copyWith(
            selectedAmount: amount,
            unit: unit,
            totalSodium: (seasoning.sodiumPerTeaspoon * (amount * unit.multiplier)).toInt(),
          );

          selectedSeasonings.add(selectedSeasoning);
          selectedSeasoningTotalSodium = selectedSeasonings.fold(0, (int accumulate, Seasoning s) => accumulate + s.totalSodium);

          widget.onSelected(selectedSeasonings, selectedSeasoningTotalSodium);
        });
      },
    );

    showRoundedModalBottomSheet(
      autoResize: true,
      dismissOnTap: false,
      context: context,
      builder: (BuildContext context) => seasoningOptions,
    );
  }

  Widget _buildChipSeasoningItem(Seasoning seasoning, bool selected) {
    final chip = ChipSelector(
      label: seasoning.name,
      selected: selected,
      onTap: () {
        if (selected) {
          setState(() {
            selectedSeasonings.removeWhere((s) => s.id == seasoning.id);
            selectedSeasoningTotalSodium = selectedSeasonings.fold(0, (int accumulate, Seasoning s) => accumulate + s.totalSodium);

            widget.onSelected(selectedSeasonings, selectedSeasoningTotalSodium);
          });
        } else {
          _showSeasoningOptions(seasoning);
        }
      },
    );

    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: chip,
    );
  }

  List<Widget> _buildSelectedSeasonings() {
    return selectedSeasonings
        .map(
          (Seasoning seasoning) => Tile(
                title: Text('${seasoning.name}', style: Style.tileTitle),
                subtitle: Text('${decimalToFraction(seasoning.selectedAmount)} ${seasoning.unit.name}', style: Style.description),
                trail: Text(' ${seasoning.totalSodium} มก.', style: Style.description, textAlign: TextAlign.right),
                backgroundColor: Colors.white,
                padding: EdgeInsets.only(bottom: 12.0),
              ),
        )
        .toList();
  }

  Widget _buildSeasoningSection() {
    final seasoningPicker = Container(
      height: 36.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.viewModel.seasonings.length,
        itemBuilder: (BuildContext context, int index) {
          final seasoning = widget.viewModel.seasonings[index];
          final selected = selectedSeasonings.contains(seasoning);

          return _buildChipSeasoningItem(seasoning, selected);
        },
      ),
    );

    final selectedSeasoningsList = _buildSelectedSeasonings();

    final contents = <Widget>[];
    contents.add(seasoningPicker);
    contents.add(SizedBox(height: 16.0));

    if (selectedSeasonings.isNotEmpty) {
      contents.addAll(selectedSeasoningsList);
    } else {
      contents.addAll([
        SizedBox(height: 12.0),
        Icon(
          AssetIcon.salt,
          size: 48.0,
          color: Colors.grey,
        ),
        SizedBox(height: 8.0),
        Text('เลือกเครื่องปรุงด้านบน', style: Style.description),
        SizedBox(height: 8.0),
      ]);
    }

    contents.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'โซเดียม ',
            style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey),
          ),
          Text(
            '$selectedSeasoningTotalSodium มก.',
            style: Style.descriptionPrimary,
          ),
        ],
      ),
    );

    return Column(
      children: contents,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('การปรุงรสด้วยโซเดียม', style: Style.title),
        ],
      ),
      body: _buildSeasoningSection(),
    );
  }
}

class SeasoningSectionViewModel {
  final List<Seasoning> seasonings;

  SeasoningSectionViewModel({
    this.seasonings,
  });

  static SeasoningSectionViewModel fromStore(Store<AppState> store) {
    return SeasoningSectionViewModel(
      seasonings: store.state.seasonings,
    );
  }
}
