import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/data/model/food.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/entry/entry_action.dart';
import 'package:sodium/ui/common/dialog/confirm_dialog.dart';
import 'package:sodium/ui/common/option_item.dart';
import 'package:sodium/ui/screen/entry_add/container.dart';
import 'package:sodium/utils/completers.dart';
import 'package:sodium/utils/widget_utils.dart';

class FoodActionOptions extends StatelessWidget {
  final FoodActionOptionViewModel viewModel;
  final Food food;
  final BuildContext context;

  FoodActionOptions({
    Key key,
    @required this.food,
    this.context,
    this.viewModel,
  }) : super(key: key);

  void _handleDelete(Food food) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext dialogContext) {
          return ConfirmDialog(
            title: 'ต้องการลบหรือไม่',
            description: 'บันทึกนี้จะหายไปแล้วไม่สามารถกู้คืนได้',
            confirmText: 'ลบ',
            cancelText: 'ยกเลิก',
            onCancel: () {
              popDialog(context);
            },
            onConfirm: () {
              popDialog(context);

              final completer = loadingCompleter(context, 'กำลังลบรายการอาหาร...', 'ลบรายการอาหารแล้ว');

              viewModel.onDelete(food.entryId, completer);
            },
          );
        });
  }

  void _handleEdit(Food food) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => AddEntryContainer(
            dateTime: food.dateTime,
            food: food,
            editing: true,
          ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: OptionItem(
            icon: Icons.edit,
            title: 'แก้ไข',
            description: 'แก้ไขรายการอาหาร',
          ),
          onTap: () {
            popBottomSheet(context);
            _handleEdit(food);
          },
        ),
        ListTile(
          title: OptionItem(
            icon: Icons.delete,
            title: 'ลบ',
            description: 'ลบรายการอาหาร',
          ),
          onTap: () {
            popBottomSheet(context);
            _handleDelete(food);
          },
        ),
      ],
    );
  }
}

class FoodActionOptionViewModel {
  final Function(int, Completer) onDelete;

  FoodActionOptionViewModel({
    this.onDelete,
  });

  static FoodActionOptionViewModel fromStore(Store<AppState> store) {
    return FoodActionOptionViewModel(
      onDelete: (int id, Completer completer) => store.dispatch(DeleteEntry(id: id, completer: completer)),
    );
  }
}
