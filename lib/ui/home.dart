import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter47/database/database_helper.dart';
import 'package:flutter47/model/picture.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  DataBaseHelper? dataBaseHelper;
  List<Picture>? allpicture;
  String? imageUrl;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dataBaseHelper = DataBaseHelper();
    allpicture = <Picture>[];
    dataBaseHelper!.takePicture().then((mobileData) {
      for (var readData in mobileData) {
        allpicture!.add(Picture.fromMap(readData));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Picture Data"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      labelText: "Url",
                      hintText: "Input your Url",
                    ),
                    validator: (url) {
                      if (url!.length < 5) {
                        return "Url must be at least 5 sign";
                      }
                    },
                    onSaved: (url) {
                      imageUrl = url;
                    },
                  ),
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      allFunction(imageUrl!);
                    }
                  },
                  child: Text("Take image"),
                ),
                ElevatedButton(
                  onPressed: () => _imgFromGallery(),
                  child: Text("From gallery"),
                ),
              ],
            ),
            allpicture!.length != 0
                ? Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0),
                      itemBuilder: (context, index) {
                        return Container(
                          child: Image.memory(
                            allpicture![index].image!,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                      itemCount: allpicture!.length,
                    ),
                  )
                : Center(
                    child: CupertinoActivityIndicator(),
                  ),
          ],
        ),
      ),
    );
  }

  allFunction(String image) async {
    dataBaseHelper!.takeUrl(image).then((value) {
      return dataBaseHelper!.addPicture(Picture("Rasm 1", value)).then((value) {
        dataBaseHelper!.takePicture().then((mobileData) {
          for (var readData in mobileData) {
            allpicture!.add(Picture.fromMap(readData));
          }
          setState(() {});
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => super.widget),
          );
        });
      });
    });
  }

  _imgFromGallery() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      var file = File(image!.path);
    });
  }
}
