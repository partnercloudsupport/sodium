import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/data/model/seasoning.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/food/food_action.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/common/section/section.dart';
import 'package:sodium/ui/seasoning_section/seasoning_container.dart';
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

  List<Seasoning> _selectedSeasonings;
  int _selectedSeasoningTotalSodium;

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
      sodium: _selectedSeasoningTotalSodium,
      seasonings: _selectedSeasonings,
    );

    final Completer<Null> completer = Completer();
    completer.future.then((_) {
      popDialog(context);
      popScreen(context);
      showToast('บันทึกแล้ว');
    }).catchError((error) {
      popDialog(context);
      showToast('บันทึกไม่สำเร็จ ลองอีกครั้ง');
    });

    widget.viewModel.onSave(food, completer);
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();

    _selectedSeasonings = [];
    _selectedSeasoningTotalSodium = 0;
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('เพิ่มอาหาร'),
        elevation: .3,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _save,
          )
        ],
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
            SeasoningSelectionSectionContainer(
              onSelected: (seasonings, totalSodium) {
                setState(() {
                  _selectedSeasonings = seasonings;
                  _selectedSeasoningTotalSodium = totalSodium;
                });
              },
            ),
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
