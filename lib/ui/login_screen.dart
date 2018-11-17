import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sodium/bloc/application/application_bloc.dart';
import 'package:sodium/bloc/application/application_event.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/constant/assets.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/loading_status.dart';
import 'package:sodium/ui/common/loading/loading_content.dart';
import 'package:sodium/ui/common/loading/loading_view.dart';
import 'package:sodium/ui/common/ripple_button.dart';
import 'package:sodium/ui/register_screen.dart';
import 'package:sodium/utils/widget_utils.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController;
  TextEditingController _passwordController;

  FocusNode _emailNode;
  FocusNode _passwordNode;

  Widget _buildInitialContent(ApplicationBloc applicationBloc) {
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
              onFieldSubmitted: (String value) => _login(applicationBloc),
            ),
          ),
          SizedBox(height: 24.0),
          RippleButton(
            text: "เข้าสู่ระบบ",
            backgroundColor: Theme.of(context).primaryColor,
            highlightColor: Style.highlightColor,
            textColor: Colors.white,
            onPress: () => _login(applicationBloc),
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

  void _login(ApplicationBloc applicationBloc) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Completer<Null> completer = Completer();
    completer.future.then((_) {
      showToast('เข้าสู่ระบบสำเร็จ');
    }).catchError((error) {
      showToast('เข้าสู่ระบบไม่สำเร็จ');
    });

    final LoginEvent loginEvent = LoginEvent(
      email: _emailController.text,
      password: _passwordController.text,
      completer: completer,
    );

    applicationBloc.inLogin.add(loginEvent);
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
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    return Scaffold(
      body: StreamBuilder(
        initialData: LoadingStatus.initial,
        stream: applicationBloc.outLoginLoading,
        builder: (BuildContext context, AsyncSnapshot<LoadingStatus> snapshot) {
          final loadingStatus = snapshot.data;

          return LoadingView(
            loadingStatus: loadingStatus,
            loadingContent: LoadingContent(title: 'กำลังเข้าสู่ระบบ'),
            initialContent: _buildInitialContent(applicationBloc),
          );
        },
      ),
    );
  }
}
