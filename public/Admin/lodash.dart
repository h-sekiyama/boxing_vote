// 利用するJavaScriptのクラスを宣言
@JS('_')
library lodash;

import 'package:js/js.dart';

// 利用するクラスに紐づくメソッド名を宣言し、I/Fを定義
@JS('max')
external int max(List<int> array);

// 他のメソッドも同じく
@JS('camelCase')
external String camelCase(String string);
