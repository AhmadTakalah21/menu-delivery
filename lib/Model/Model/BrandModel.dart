


import 'dart:convert';

import 'package:shopping_land_delivery/Configuration/config.dart';

List<BrandModel> dataBrandModelFromJson(var str) =>
    List<BrandModel>.from(json.decode(str).map((x) => BrandModel.fromJson(x)));



class BrandModel {
  int? id;
  String? name;
  String? urlImage;
  String? type;
  List<Cities>? cities;

  BrandModel({this.id, this.name, this.urlImage, this.type, this.cities});

  BrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    urlImage = APIURLFile+json['url_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['url_image'] = this.urlImage;
    data['type'] = this.type;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  int? id;
  String? name;

  Cities({this.id, this.name});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
