

import 'dart:convert';

import 'package:shopping_land_delivery/Configuration/config.dart';

List<Percents> dataPercentsFromJson(var str) =>
    List<Percents>.from(json.decode(str).map((x) => Percents.fromJson(x)));




class Percents {
  int? id;
  int? itemId;
  String? itemName;
  String? itemImage;
  String? categoryName;
  int? percent;

  Percents(
      {this.id,
        this.itemId,
        this.itemName,
        this.itemImage,
        this.categoryName,
        this.percent});

  Percents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    percent = json['percent'];
    itemName = json['item_name'];
    itemImage =  APIURLFile+json['item_image'];
    categoryName = json['category_name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_image'] = itemImage;
    data['category_name'] = categoryName;
    data['percent'] = percent;
    return data;
  }
}

