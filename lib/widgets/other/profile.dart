import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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
                ElevatedButton(
                  onPressed: isEnabled
                      ? () {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update({
                            "name": userName,
                          });
                          FirebaseAuth.instance.currentUser!
                              .updateProfile(displayName: userName);

                          if (selectedImage != null) {
                            uploadImage();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      primary: Colors.orange, onPrimary: Colors.white),
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
                ),
                Visibility(visible: isComplete, child: Text("更新しました"))
              ],
            ),
          ],
        ),
      ),
    );
  }

  void downloadImage() async {
    Reference imageRef = storage
        .ref()
        .child("profile")
        .child("${FirebaseAuth.instance.currentUser!.uid}.png");
    String imageUrl = await imageRef.getDownloadURL();

    // 画面に反映
    setState(() {
      nowImage = Image.network(imageUrl);
    });
  }

  void uploadImage() async {
    try {
      if (selectedImage != null) {
        storage
            .ref("profile/${FirebaseAuth.instance.currentUser!.uid}.png")
            .putFile(selectedImage!)
            .whenComplete(() => {
                  setState(() {
                    isComplete = true;
                    isEnabled = false;
                  })
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

  Future _getImageFromGallery() async {
    final _pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (_pickedFile != null) {
        selectedImage = File(_pickedFile.path);
        nowImage = Image.file(selectedImage!);
        isEnabled = true;
      }
    });
  }
}
