import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<Profile> {
  // ギャラリーから選択した画像
  File? selectedImage;
  final _picker = ImagePicker();
  // FireStoreのインスタンス
  FirebaseStorage storage = FirebaseStorage.instance;
  // ユーザー名
  String userName = "";
  // ユーザーアイコン
  Image? nowImage;
  // プロフィール更新が完了したか
  bool isComplete = false;
  // 更新可能か否か
  bool isEnabled = false;
  // プロフ画像のURL
  String imageUrl = "";

  Future getImageFromCamera() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      selectedImage = File(pickedFile!.path);
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(pickedFile!.path);
    });
  }

  void initState() {
    downloadImage();
    userName = FirebaseAuth.instance.currentUser!.displayName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                GestureDetector(
                    onTap: () => _getImageFromGallery(),
                    child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 90),
                        child: _displaySelectionImageOrGrayImage())),
                Container(
                    width: 300,
                    margin: EdgeInsets.all(8),
                    child: TextFormField(
                      autofocus: false,
                      initialValue:
                          FirebaseAuth.instance.currentUser!.displayName,
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                      decoration: new InputDecoration(
                        hintText: '名前',
                      ),
                      onChanged: (value) {
                        userName = value;
                        if (value.length == 0 ||
                            value ==
                                FirebaseAuth
                                    .instance.currentUser!.displayName) {
                          setState(() {
                            isEnabled = false;
                          });
                        } else {
                          setState(() {
                            isEnabled = true;
                          });
                        }
                      },
                    )),
                Container(
                    width: 180,
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: isEnabled
                          ? () {
                              // 全画面プログレスダイアログ
                              showGeneralDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  transitionDuration:
                                      Duration(milliseconds: 300),
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  pageBuilder: (BuildContext context,
                                      Animation animation,
                                      Animation secondaryAnimation) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                "name": userName,
                              });
                              FirebaseAuth.instance.currentUser!
                                  .updateProfile(displayName: userName)
                                  .then((value) => {
                                        if (selectedImage != null)
                                          {uploadImage()}
                                        else
                                          {
                                            setState(() {
                                              isComplete = true;
                                            }),
                                            Navigator.of(context).pop()
                                          }
                                      });
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'これにする',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          height: 1.2,
                        ),
                      ),
                    )),
                Visibility(visible: isComplete, child: Text("更新しました"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  // アイコン画像のダウンロード
  void downloadImage() async {
    try {
      Reference imageRef = storage
          .ref()
          .child("profile")
          .child("${FirebaseAuth.instance.currentUser!.uid}.png");
      imageUrl = await imageRef.getDownloadURL();

      // 画面に反映
      setState(() {
        nowImage = Image.network(imageUrl);
      });
    } catch (FirebaseException) {
      print(FirebaseException);
    }
  }

  // アイコン画像のアップロード
  void uploadImage() async {
    try {
      if (selectedImage != null) {
        storage
            .ref("profile/${FirebaseAuth.instance.currentUser!.uid}.png")
            .putFile(selectedImage!)
            .whenComplete(() async => {
                  imageUrl = await storage
                      .ref()
                      .child("profile")
                      .child("${FirebaseAuth.instance.currentUser!.uid}.png")
                      .getDownloadURL(),
                })
            .whenComplete(() => {
                  setState(() {
                    isComplete = true;
                    isEnabled = false;
                  }),
                  Navigator.of(context).pop()
                });
      }
    } catch (e) {
      print(e);
    }

    String url;
  }

  Widget _displaySelectionImageOrGrayImage() {
    if (nowImage != null) {
      return Container(
        child: ClipRRect(
          child: nowImage,
        ),
      );
    } else if (selectedImage == null) {
      return Container(
        child: ClipRRect(
          child: Image.asset('images/cat.png'),
        ),
      );
    } else {
      return Container(
        child: Image.file(
          selectedImage!,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  /// Crop Image
  Future<File?> _cropImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.black,
        toolbarTitle: "",
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        backgroundColor: Colors.black,
        cropFrameColor: Colors.transparent,
        showCropGrid: false,
        hideBottomControls: true,
        initAspectRatio: CropAspectRatioPreset.square,
      ),
      iosUiSettings: IOSUiSettings(
        hidesNavigationBar: true,
        aspectRatioPickerButtonHidden: true,
        doneButtonTitle: "切り抜き",
        cancelButtonTitle: "戻る",
        aspectRatioLockEnabled: true,
      ),
    );
    return croppedImage;
  }

  Future _getImageFromGallery() async {
    final _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      selectedImage = await _cropImage(_pickedFile.path);
    }
    if (selectedImage != null) {
      setState(() {
        nowImage = Image.file(selectedImage!);
        isEnabled = true;
      });
    }
  }
}
