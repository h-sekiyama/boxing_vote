import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';

class EmailSignUpForm extends StatefulWidget {
  @override
  _EmailSignUpFormState createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  var _name = "名無しの予想師";
  var _email = "";
  var _password1 = "";
  var _password2 = "";

  Future<void> _signUp() async {
    // 登録結果を格納する
    // バリデーションを実行
    final isValid = _formKey.currentState!.validate();
    // キーボードを閉じる
    FocusScope.of(context).unfocus();

    // バリデーションに問題がなければ登録
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });
        // formの内容を保存
        _formKey.currentState!.save();
        // パスワードの一致を確認
        if (_password1 != _password2) {
          setState(() {
            _isLoading = false;
          });
          _showErrorFlash("パスワードが一致しません");
          return;
        }

        final _auth = FirebaseAuth.instance;
        // サインアップを実行
        try {
          UserCredential authResult = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password1);
          _showMessageFlash("認証メールを送りました");
          setState(() {
            _isLoading = false;
          });

          // ユーザー情報をDBに追加
          var obj = {
            "name": _name,
            "votes": {},
          };
          FirebaseFirestore.instance
              .collection("users")
              .doc(authResult.user!.uid)
              .set(obj)
              .then((_) {
            // 表示名も更新
            FirebaseAuth.instance.currentUser!
                .updateProfile(displayName: _name);
          });
        } catch (e) {
          if (e.toString().contains("already in use")) {
            _showErrorFlash("既に登録済みのメールアドレスです");
          }
          setState(() {
            _isLoading = false;
          });
        }

        await _auth.currentUser!.sendEmailVerification();
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
        setState(() {
          _isLoading = false;
        });
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

  void _showMessageFlash(String message) {
    Flushbar(
      message: message,
      backgroundColor: Colors.blue,
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
              // ユーザー名の入力フィールド
              Container(
                  height: 80,
                  margin: EdgeInsets.all(8),
                  child: TextFormField(
                    key: ValueKey("name"),
                    keyboardType: TextInputType.name,
                    maxLength: 12,
                    cursorColor: Colors.black,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      hintText: '名前',
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
                    onSaved: (value) {
                      _name = value!;
                    },
                  )),
              // メールアドレスの入力フィールド
              Container(
                  margin: EdgeInsets.all(8),
                  child: TextFormField(
                    key: ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
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
              // パスワード1の入力フィールド
              Container(
                  margin: EdgeInsets.all(8),
                  child: TextFormField(
                    key: ValueKey("password1"),
                    cursorColor: Colors.black,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      hintText: 'パスワード',
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
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return '最低4文字以上は入力してください';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password1 = value!;
                    },
                  )),
              // パスワード2の入力フィールド
              Container(
                  margin: EdgeInsets.all(8),
                  child: TextFormField(
                    key: ValueKey("password2"),
                    cursorColor: Colors.black,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      hintText: 'パスワード確認',
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
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return '最低4文字以上は入力してください';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password2 = value!;
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
                        child: Text("登録",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        onPressed: _signUp,
                      ))
            ],
          ),
        ),
        padding: EdgeInsets.all(16),
      ),
    );
  }
}
