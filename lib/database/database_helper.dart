import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter47/model/picture.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class DataBaseHelper {
  static DataBaseHelper? _dataBaseHelper;
  static Database? _database;

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._internal();
      return _dataBaseHelper!;
    } else {
      return _dataBaseHelper!;
    }
  }

  DataBaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initialDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future _initialDatabase() async {
    // Agarda database bloklansa lock synxronize orqali ochib oladi
    var lock = Lock();
    Database? _db;

    // Database null kelsa uni lock orqali ochadi
    if (_db == null) {
      await lock.synchronized(() async {
        // lockdan ochgandan so'ng null kelsa yangi database kiritadi

        if (_db == null) {
          var databasePath = await getDatabasesPath();
          String path = join(databasePath, 'picture.db');
          print("Db ning Pathi :" + path.toString());
          var file = File(path);

          if (!await file.exists()) {
            ByteData data = await rootBundle.load(join('assets', 'picture.db'));
            List<int> bytes =
                data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
            await File(path).writeAsBytes(bytes);
          }
          _db = await openDatabase(path);
        }
      });
    }
    return _db;
  }

  takePicture() async {
    var db = await _getDatabase();
    var result = await db.query('Picture', orderBy: 'id DESC');
    print(result);
    return result;
  }

  Future<int> addPicture(Picture picture) async {
    var db = await _getDatabase();
    var result = await db.insert('Picture', picture.toMap());
    print("Rasm qo'shildi : $result");
    return result;
  }

  Future takeUrl(String url) async {
    var imageUrl = await http.get(Uri.parse(url));
    var bytes = imageUrl.bodyBytes;
    print("Url ni oldi : $bytes");
    return bytes;
  }

  takeGallery() async {
    var imagePicker = ImagePicker();
    var bytes = await imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(bytes!.path);
  }
}
