import 'package:another_flushbar/flushbar.dart';
import 'package:boxing_vote/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'auth_check.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _email = "";

  Future<void> _sendPasswordResetMail() async {
    // 登録結果を格納する
    // バリデーションを実行
    var isValid = _formKey.currentState?.validate();
    // キーボードを閉じる
    FocusScope.of(context).unfocus();

    // バリデーションに問題がなければパスワードリセットメール送信
    if (isValid != null) {
      if (isValid) {
        try {
          setState(() {
            _isLoading = true;
          });
          // formの内容を保存
          _formKey.currentState?.save();

          // サインインを実行
          await FirebaseAuth.instance
              .sendPasswordResetEmail(email: _email)
              .then((value) {
            _showMessageFlash("パスワードリセットメールを送りました。");
          });
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

  void _showMessageFlash(String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.blue,
      margin: EdgeInsets.all(8),
      duration: Duration(seconds: 3),
    )..show(context);
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
    return Container(
      child: Padding(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ロゴ
              Image(
                width: MediaQuery.of(context).size.width * 0.85,
                image: AssetImage('images/logo.png'),
              ),
              // メールアドレスの入力フィールド
              Container(
                  margin:
                      EdgeInsets.only(top: 30, bottom: 10, left: 8, right: 8),
                  child: TextFormField(
                    key: ValueKey("email"),
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      hintText: 'メールアドレス',
                      hintStyle: TextStyle(color: Color(0xffcccccc)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    validator: (value) {
                      if (!EmailValidator.validate(value!)) {
                        return "正しいメールアドレスを入力してください";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  )),

              SizedBox(
                height: 12,
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: 180,
                      margin: EdgeInsets.all(2),
                      child: TextButton(
                        child: Text("パスワードリセット",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                        onPressed: _sendPasswordResetMail,
                      )),
              GestureDetector(
                  child: Text("ログインはこちら",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black)),
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthScreen(false),
                            fullscreenDialog: true));
                  })
            ],
          ),
        ),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}
