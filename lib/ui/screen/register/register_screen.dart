import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/user/user_action.dart';
import 'package:sodium/ui/common/ripple_button.dart';
import 'package:sodium/ui/screen/main/screen.dart';
import 'package:sodium/utils/completers.dart';
import 'package:sodium/utils/string_util.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = '/register';

  final RegisterScreenViewModel viewModel;

  RegisterScreen({
    this.viewModel,
  });

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  FocusNode _nameFocusNode;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;

  final _formKey = GlobalKey<FormState>();

  void _showMainScreen() {
    Navigator.of(context).pushReplacementNamed(MainScreen.route);
  }

  void _register() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final user = User.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    final completer = loadingThenPushReplaceCompleter(context, MainScreen.route, 'กำลังสมัครสมาชิก..', 'สมัครสมาชิกสำเร็จ', 'สมัครสมาชิกล้มเหลว ');
    widget.viewModel.onRegister(user, completer);
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: 'natthapon');
    _emailController = TextEditingController(text: 'premium@gmail.com');
    _passwordController = TextEditingController(text: '123456');

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("สร้างบัญชีผู้ใช้")),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: Style.textFieldDecoration.copyWith(labelText: 'ชื่อ'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String value) => FocusScope.of(context).requestFocus(_emailFocusNode),
                  validator: (String value) {
                    if (value.isEmpty) return "กรุณากรอกชื่อ";

                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: Style.textFieldDecoration.copyWith(labelText: 'อีเมลล์'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (String value) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                  validator: (String value) {
                    if (value.isEmpty) return 'กรุณากรอกอีเมลล์';
                    if (!isEmail(value)) return 'รูปแบบอีเมลล์ไม่ถูกต้อง';

                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: Style.textFieldDecoration.copyWith(labelText: 'รหัสผ่าน'),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (String value) => _register(),
                  validator: (String value) {
                    if (value.isEmpty) return 'กรุณากรอกรหัสผ่าน';

                    return null;
                  },
                ),
              ),
              SizedBox(height: 24.0),
              RippleButton(
                text: "สร้างบัญชีผู้ใช้",
                backgroundColor: Theme.of(context).primaryColor,
                highlightColor: Palette.highlight,
                textColor: Colors.white,
                onPress: () => _register(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreenViewModel {
  final Function(User user, Completer<Null> completer) onRegister;

  RegisterScreenViewModel({
    this.onRegister,
  });

  static RegisterScreenViewModel fromStore(Store<AppState> store) {
    return RegisterScreenViewModel(
      onRegister: (User user, Completer<Null> completer) => store.dispatch(Register(user, completer)),
    );
  }
}
