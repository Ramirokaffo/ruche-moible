


import 'package:ruche/LocalBdManager/LocalBdManager.dart';
import 'package:ruche/SettingClass/Area.dart';

class Ruche {
  late int? id;
  late String? description;
  late String? street;
  late String? region;
  late String? city;
  late String? country;
  late double? long;
  late double? lat;
  late int? areaId;
  late String? createAt;
  late Area? area;


  Ruche({
    this.id,
    this.description,
    this.street,
    this.region,
    this.city,
    this.country,
    this.long,
    this.lat,
    this.areaId,
    this.createAt,
  });


  Future save() async {
    const String sql = 'INSERT INTO user (code, image, village) VALUES("$code", "$image", "$village")';
    LocalBdManager.insertData(sql);
  }
}