

import 'dart:convert';

import 'package:get/get.dart';
import 'package:shopping_land_delivery/Configuration/config.dart';

List<OptionWidget> dataOptionWidgetFromJson(var str) =>
    List<OptionWidget>.from(json.decode(str).map((x) => OptionWidget.fromJson(x)));


List<Items> dataItemsWidgetFromJson(var str) =>
    List<Items>.from(json.decode(str).map((x) => Items.fromJson(x)));




class OptionWidget {
  int? id;
  String? name;
  List<Items>? items;

  OptionWidget({this.id, this.name, this.items});

  OptionWidget.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  int? price;
  RxInt? isFav;
  bool isFavChange =false;
  int? countFavourites;
  String? brandName;
  int? priceAfterOffer;
  Image? image;

  Items({this.brandName,this.id, this.name, this.price, this.priceAfterOffer, this.image});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    priceAfterOffer = json['price_after_offer'];
    isFav = RxInt(json['is_fav']);
    countFavourites = json['count_favourites'];
    brandName = json['brand_name'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_after_offer'] = this.priceAfterOffer;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Image {
  int? id;
  String? url;

  Image({this.id, this.url});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = APIURLFile+json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}
