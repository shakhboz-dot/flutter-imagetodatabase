import 'dart:typed_data';

class Picture {
  int? id;
  String? title;
  Uint8List? image;

  Picture(this.title, this.image);

  Picture.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.image = map['image'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['title'] = title;
    map['image'] = image;
    return map;
  }
}
