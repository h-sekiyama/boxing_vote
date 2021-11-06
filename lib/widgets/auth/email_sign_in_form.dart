import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

import 'auth_check.dart';

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _email = "";
  var _password = "";

  Future<void> _signIn() async {
    // 登録結果を格納する
    // バリデーションを実行
    var isValid = _formKey.currentState?.validate();
    // キーボードを閉じる
    FocusScope.of(context).unfocus();

    // バリデーションに問題がなければ登録
    if (isValid != null) {
      if (isValid) {
        try {
          setState(() {
            _isLoading = true;
          });
          // formの内容を保存
          _formKey.currentState?.save();

          // 変更部分！サインインを実行
          UserCredential authResult = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AuthCheck(),
              ));
          setState(() {
            _isLoading = false;
          });
        } on PlatformException catch (err) {
          var message = 'エラーが発生しました。認証情報を確認してください。';
          if (err.message != null) {
            message = err.message!;
          }
          _showErrorFlash(message);
          setState(() {
            _isLoading = false;
          });
        } catch (err) {
          print(err);
          if (err.toString().contains("no user record")) {
            _showErrorFlash("ユーザー情報が見つかりません");
          }
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showErrorFlash(String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.red,
      margin: EdgeInsets.all(8),
      duration: Duration(seconds: 3),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // メールアドレスの入力フィールド
              TextFormField(
                key: ValueKey("email"),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "メールアドレス"),
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return "正しいメールアドレスを入力してください";
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              // パスワード1の入力フィールド
              TextFormField(
                key: ValueKey("password"),
                decoration: InputDecoration(labelText: "パスワード"),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 4) {
                    return '最低4文字以上は入力してください';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              SizedBox(
                height: 12,
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RaisedButton(
                      child: Text("サインイン"),
                      onPressed: _signIn,
                    )
            ],
          ),
        ),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}
