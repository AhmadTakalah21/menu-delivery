

import 'dart:convert';

import 'package:shopping_land_delivery/Configuration/config.dart';

List<Category> dataCategoryFromJson(var str) =>
    List<Category>.from(
        json.decode(str).map((x) => Category.fromJson(x)));



class Category {
  int? id;
  int? superAdminId;
  String? name;
  String? imageUrl;

  Category({this.id, this.superAdminId, this.name, this.imageUrl});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    superAdminId = json['superAdmin_id'];
    name = json['name'];
    imageUrl =  APIURLFile+json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['superAdmin_id'] = superAdminId;
    data['name'] = name;
    data['image_url'] = imageUrl;
    return data;
  }
}
