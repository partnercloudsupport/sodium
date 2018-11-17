import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sodium/bloc/application/application_bloc.dart';
import 'package:sodium/bloc/application/application_event.dart';
import 'package:sodium/bloc/provider/bloc_provider.dart';
import 'package:sodium/constant/styles.dart';
import 'package:sodium/data/model/loading_status.dart';
import 'package:sodium/data/model/user.dart';
import 'package:sodium/ui/common/loading/loading_content.dart';
import 'package:sodium/ui/common/loading/loading_view.dart';
import 'package:sodium/ui/common/ripple_button.dart';
import 'package:sodium/utils/widget_utils.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  void _register(ApplicationBloc applicationBloc) {
    final user = User.register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
//
    Completer<Null> completer = Completer();
    completer.future.then((_) {
      showToast('สมัครสมาชิกสำเร็จ');
    }).catchError((error) {
      showToast('สมัครสมาชิกไม่สำเร็จ');
    });

    final RegisterEvent registerEvent = RegisterEvent(
      user: user,
      completer: completer,
    );

    applicationBloc.inRegister.add(registerEvent);
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: 'natthapon');
    _emailController = TextEditingController(text: 'premium@gmail.com');
    _passwordController = TextEditingController(text: '123456');
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ApplicationBloc applicationBloc = BlocProvider.of<ApplicationBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("สร้างบัญชีผู้ใช้"),
      ),
      body: StreamBuilder(
        stream: applicationBloc.outRegisterLoading,
        initialData: LoadingStatus.initial,
        builder: (BuildContext context, AsyncSnapshot<LoadingStatus> snapshot) {
          return LoadingView(
            loadingStatus: snapshot.data,
            loadingContent: LoadingContent(title: 'กำลังสมัครสมาชิก...'),
            initialContent: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "ชื่อ - นามสกุล",
                          fillColor: Colors.white,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "อีเมลล์",
                          fillColor: Colors.white,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "รหัสผ่าน",
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    RippleButton(
                      text: "สร้างบัญชีผู้ใช้",
                      backgroundColor: Theme.of(context).primaryColor,
                      highlightColor: Style.highlightColor,
                      textColor: Colors.white,
                      onPress: () => _register(applicationBloc),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
