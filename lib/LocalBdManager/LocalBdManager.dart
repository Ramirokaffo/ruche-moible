import 'dart:async';

import 'package:path/path.Dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';



class LocalBdManager {
  Future localBdChangeSetting(
      String settingName, String newSettingValue) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    await database.rawUpdate('UPDATE setting SET valeur = ? WHERE name = ?',
        [newSettingValue, settingName]);
    await database.close();
  }

   static Future localBdChangeUser(
      int id, String mpath) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    await database.rawUpdate('UPDATE user SET image = ? WHERE id = ?',
        [mpath, id]);
    await database.close();
  }

   static Future localBdChangeName(
      int id, String newstatus) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    await database.rawUpdate('UPDATE user SET name = ? WHERE id = ?',
        [newstatus, id]);
    await database.close();
  }



  Future localBdInsertSetting(String settingName, String settingValue) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    await database.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO setting (name, valeur) VALUES("$settingName", "$settingValue")');
    });
    await database.close();
  }

  static Future insertData(String sql) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    await database.transaction((txn) async {
      await txn.rawInsert(sql);
    });
    await database.close();
  }

  Future<bool> localBdIsThisSettingAvailable(String settingName) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    List<Map> result = await database
        .rawQuery('SELECT * FROM setting WHERE name = ?;', [settingName]);
    await database.close();
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future initializeBD() async {
    // print('Bd initialization.....');
    // databaseFactory = databaseFactoryFfi;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');

  await deleteDatabase(path);
// return;
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE setting (`id` INTEGER NOT NULL , `name` VARCHAR(200) NULL, `village` VARCHAR(95) NULL, `valeur` VARCHAR(500) NULL, PRIMARY KEY (`id`));');
      await db.execute(
          'CREATE TABLE area (`id` int NOT NULL, '
              '`name` varchar(45) DEFAULT NULL, PRIMARY KEY (`id`));');
      await db.execute(
          'CREATE TABLE ruche ('
              '`id` INTEGER NOT NULL, '
              '`description` varchar(5000) DEFAULT NULL, '
              '`long` float DEFAULT NULL, '
              '`lat` float DEFAULT NULL, '
              '`street` varchar(45) DEFAULT NULL, '
              '`region` varchar(45) DEFAULT NULL, '
              '`city` varchar(45) DEFAULT NULL, '
              '`country` varchar(45) DEFAULT NULL, '
              '`areaId` int DEFAULT NULL, '
              '`createAt` datetime(6) DEFAULT NULL '
              ', PRIMARY KEY (`id`), CONSTRAINT `areaId` FOREIGN KEY '
              '(`areaId`) REFERENCES `area` (`id`));');
      await db.transaction((txn) async {
        await txn.rawInsert(
            'INSERT INTO setting (name, valeur) VALUES("account", "0")');
        await txn.rawInsert(
            'INSERT INTO setting (name, valeur) VALUES("user", "none")');
        await txn.rawInsert(
            'INSERT INTO setting (name, valeur) VALUES("token", "none")');
      });
    });
    // await database.close();
  }


  // Future localBdInsertUser(String ref_lastname, String ref_firstname, ref_code,
  //     ref_order, ref_cni, ref_sexe, ref_phone, chef_lastname, chef_firstname, chef_code, chef_phone, image) async {
  //   var databasesPath = await getDatabasesPath();
  //   String path = join(databasesPath, 'local.db');
  //   var database = await openDatabase(path);
  //   await database.transaction((txn) async {
  //     await txn.rawInsert(
  //         'INSERT INTO user (ref_lastname, ref_firstname, ref_code, ref_order, '
  //             'ref_cni, ref_sexe, ref_phone, chef_lastname, chef_firstname, '
  //             'chef_code, chef_phone, image) VALUES("$ref_lastname", "$ref_firstname", '
  //             '"$ref_code", "$ref_order", "$ref_cni", "$ref_sexe", "$ref_phone", '
  //             '"$chef_lastname", "$chef_firstname", "$chef_code", "$chef_phone", "$image")');
  //   });
  //   await database.close();
  // }


  Future localBdSelectSetting(String settingName) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    List<Map> list = await database
        .rawQuery('SELECT valeur FROM setting WHERE name = ?', [settingName]);
    return list[0]["valeur"];
  }

  static Future localBdSelectOneUser(int id) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    List<Map> list = await database
        .rawQuery('SELECT * FROM user WHERE id = ?', [id]);
    return list[0];
  }

  static Future localBdSelectOneVillage(String village) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'local.db');
    var database = await openDatabase(path);
    var list = await database
        .rawQuery('SELECT COUNT(*) FROM user WHERE village = ?', [village]);
    // print(list);
    return list[0]["COUNT(*)"];
  }

  static Future localBdSelectUser() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'local.db');
      var database = await openDatabase(path);
      List<Map> list = await database
          .rawQuery('SELECT * FROM user;');
      for (var img in list) {
        // print("object");
        // print(await getImageFileFromName(img["image"].split("/").last));

        // File im = await getImageFileFromName(img["image"].split("/").last);
        // img["image"] = im.path;
      }
      // print("object");
      return list;
    } catch (e) {
      print(e);
    }
  }

  static Future<File> getImageFileFromName(String imageName) async {
    final directory = await getExternalStorageDirectory();
    final imagePath = '${directory?.path}/$imageName';
    return File(imagePath);
  }

    static Future localBdSearchUser(String search, String village) async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'local.db');
      var database = await openDatabase(path);
      List<Map> list = [];
      print(village.isEmpty);
      if (village.isEmpty) {
        list = await database
          .rawQuery("SELECT * FROM user WHERE name LIKE '%${search}%' OR code LIKE '%${search}%' ;");
      } else {
        print("village: $village");
        list = await database
            .rawQuery("SELECT * FROM user WHERE (name LIKE '%${search}%' OR code LIKE '%${search}%') AND (village LIKE '%${village}%') ;");

      }
      for (var img in list) {
        // print(img);
        // File im = await getImageFileFromName(img["image"].split("/").last);
        // img["image"] = im.path;
      }
      return list;
    } catch (e) {
      print(e);
    }
  }


  static Future localBdDeleteUser(int id) async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'local.db');
      var database = await openDatabase(path);
      List<Map> list = await database
          .rawQuery('DELETE FROM user WHERE id = ?;', [id]);

      return list;
    } catch (e) {
      print(e);
    }
  }
}
