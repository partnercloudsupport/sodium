import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/redux/app/app_state.dart';
import 'package:sodium/redux/user/user_action.dart';
import 'package:sodium/ui/common/loading/loading_dialog.dart';
import 'package:sodium/ui/common/ripple_button.dart';
import 'package:sodium/ui/register_screen.dart';
import 'package:sodium/utils/widget_utils.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';

  final LoginScreenViewModel viewModel;

  LoginScreen({
    this.viewModel,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController;
  TextEditingController _passwordController;

  FocusNode _emailNode;
  FocusNode _passwordNode;

  Widget _buildInitialContent() {
    final _header = Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Icon(
            AssetIcon.salt,
            color: Theme.of(context).primaryColor,
            size: 120.0,
          ),
          SizedBox(height: 16.0),
          Text(
            'Sodium Tracker',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );

    final _form = Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: TextFormField(
              validator: (String value) => value.isEmpty ? 'กรุณากรอกอีเมลล์' : null,
              controller: _emailController,
              focusNode: _emailNode,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "อีเมลล์",
                fillColor: Colors.white,
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (String value) => FocusScope.of(context).requestFocus(_passwordNode),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: TextFormField(
              validator: (String value) => value.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
              controller: _passwordController,
              focusNode: _passwordNode,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "รหัสผ่าน",
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (String value) => _login(),
            ),
          ),
          SizedBox(height: 24.0),
          RippleButton(
            text: "เข้าสู่ระบบ",
            backgroundColor: Theme.of(context).primaryColor,
            highlightColor: Style.highlightColor,
            textColor: Colors.white,
            onPress: () => _login(),
          ),
          SizedBox(height: 24.0),
          RippleButton(
            text: "สร้างบัญชีผู้ใช้",
            backgroundColor: Colors.white24,
            textColor: Theme.of(context).primaryColor,
            highlightColor: Colors.grey.shade200,
            onPress: () => _showRegister(context),
          ),
        ],
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          _header,
          _form,
        ],
      ),
    );
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed(RegisterScreen.route);
  }

  void _login() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => LoadingDialog(title: 'กำลังเข้าสู่ระบบ..'),
      barrierDismissible: false,
    );

    Completer<Null> completer = Completer();
    completer.future.then((_) {
      Navigator.of(context).pop();
      showToast('เข้าสู่ระบบสำเร็จ');
    }).catchError((error) {
      Navigator.of(context).pop();
      showToast('เข้าสู่ระบบไม่สำเร็จ');
    });

    widget.viewModel.onLogin(
      _emailController.text,
      _passwordController.text,
      completer,
    );
  }

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController(text: 'user@gmail.com');
    _passwordController = TextEditingController(text: '123456s');

    _emailNode = FocusNode();
    _passwordNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailNode.dispose();
    _passwordNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildInitialContent(),
    );
  }
}

class LoginScreenViewModel {
  final Function(String email, String password, Completer<Null> completer) onLogin;

  LoginScreenViewModel({
    this.onLogin,
  });

  static LoginScreenViewModel fromStore(Store<AppState> store) {
    return LoginScreenViewModel(
      onLogin: (String email, String password, Completer<Null> completer) => store.dispatch(Login(email, password, completer)),
    );
  }
}
