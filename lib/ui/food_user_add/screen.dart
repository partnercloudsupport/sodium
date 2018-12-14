import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/food/food_action.dart';
import 'package:sodium/ui/common/chip.dart';
import 'package:sodium/ui/common/food/seasoning_options.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/common/section/section.dart';
import 'package:sodium/ui/common/tile.dart';
import 'package:sodium/utils/widget_utils.dart';

class MyFoodAddScreen extends StatefulWidget {
  static final String route = '/food_add';

  final MyFoodAddScreenViewModel viewModel;

  MyFoodAddScreen({
    this.viewModel,
  });

  @override
  _MyFoodAddScreenState createState() => _MyFoodAddScreenState();
}

class _MyFoodAddScreenState extends State<MyFoodAddScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController;
  FocusNode nameNode;

  List<Seasoning> selectedSeasonings;
  int selectedSeasoningTotalSodium;

  void _save() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => LoadingDialog(title: 'กำลังบันทึก'),
      barrierDismissible: false,
    );

    final food = Food(
      name: nameController.text,
      unit: 'หน่วย',
      isLocal: true,
      type: 'อาหารของฉัน',
      sodium: selectedSeasoningTotalSodium,
    );

    final Completer<Null> completer = Completer();
    completer.future.then((_) {
      hideDialog(context);
      popScreen(context);
      showToast('บันทึกแล้ว');
    }).catchError((error) {
      hideDialog(context);
      showToast('บันทึกไม่สำเร็จ ลองอีกครั้ง');
    });

    widget.viewModel.onSave(food, completer);
  }

  void _showSeasoningOptions(Seasoning seasoning) {
    final seasoningOptions = SeasoningOptions(
      seasoning: seasoning,
      onSave: (amount, unit) {
        hideDialog(context);

        setState(() {
          final selectedSeasoning = seasoning.copyWith(
            selectedAmount: amount,
            unit: unit,
            totalSodium: seasoning.sodiumPerTeaspoon * (amount * unit.multiplier).toInt(),
          );

          selectedSeasonings.add(selectedSeasoning);
          selectedSeasoningTotalSodium = selectedSeasonings.fold(0, (int accumulate, Seasoning s) => accumulate + s.totalSodium);
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

  List<Widget> _buildSelectedSeasonings() {
    return selectedSeasonings
        .map((Seasoning seasoning) => Padding(
              padding: EdgeInsets.only(bottom: 14.0),
              child: Tile(
                title: Text('${seasoning.name}', style: Style.tileTitle),
                subtitle: Text('${seasoning.selectedAmount.toInt()} ${seasoning.unit.name}', style: Style.description),
                trail: Text('${seasoning.totalSodium} มก.', style: Style.description, textAlign: TextAlign.right),
              ),
            ))
        .toList();
  }

  Widget _buildChipSeasoningItem(Seasoning seasoning, bool selected) {
    final chip = ChipSelector(
      label: seasoning.name,
      selected: selected,
      onTap: () => _showSeasoningOptions(seasoning),
    );

    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: chip,
    );
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
      ]);
    }

    return Column(
      children: contents,
    );
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();

    selectedSeasonings = [];
    selectedSeasoningTotalSodium = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _form = Form(
      key: _formKey,
      child: TextFormField(
        autofocus: true,
        validator: (String value) => value.isEmpty ? 'กรุณากรอกชื่ออาหาร' : null,
        controller: nameController,
        focusNode: nameNode,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: "ชื่ออาหาร",
          fillColor: Colors.white,
        ),
        textInputAction: TextInputAction.next,
      ),
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: _save,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('เพิ่มอาหาร'),
        elevation: .3,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SectionContainer(
              title: Text('ข้อมูลเบื้องต้น', style: Style.title),
              body: Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: _form,
              ),
            ),
            SectionContainer(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('การปรุงรสด้วยโซเดียม', style: Style.title),
                  Text('$selectedSeasoningTotalSodium มก.', style: Style.descriptionPrimary),
                ],
              ),
              body: _buildSeasoningSection(),
            )
          ],
        ),
      ),
    );
  }
}

class MyFoodAddScreenViewModel {
  final List<Seasoning> seasonings;
  final Function(Food food, Completer<Null> completer) onSave;

  MyFoodAddScreenViewModel({
    @required this.seasonings,
    @required this.onSave,
  });

  static MyFoodAddScreenViewModel fromStore(Store<AppState> store) {
    return MyFoodAddScreenViewModel(
      seasonings: store.state.seasonings,
      onSave: (Food food, Completer<Null> completer) => store.dispatch(CreateFoodUser(food, completer)),
    );
  }
}
