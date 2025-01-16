


import 'dart:convert';

import 'package:shopping_land_delivery/Configuration/config.dart';

List<Offers> dataOffersFromJson(var str) =>
    List<Offers>.from(json.decode(str).map((x) => Offers.fromJson(x)));


class Offers {
  String? categoryName;
  List<Items>? items;

  Offers({this.categoryName, this.items});

  Offers.fromJson(Map<String, dynamic> data) {
    categoryName = data['category_name'];
    if (data['Items'] != null) {
      items = <Items>[];
      data['Items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_name'] = categoryName;
    if (items != null) {
      data['Items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? offerId;
  String? itemName;
  double? itemPrice;
  String? itemImage;
  double? itemOfferPrice;

  Items(
      {this.offerId,
        this.itemName,
        this.itemPrice,
        this.itemImage,
        this.itemOfferPrice});

  Items.fromJson(Map<String, dynamic> json) {
    offerId = json['offer_id'].toString();
    itemName = json['item_name'];
    itemPrice = double.parse(json['item_price'].toString());
    itemImage =  APIURLFile+json['item_image'];
    itemOfferPrice = double.parse( json['Item_offer_price'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offer_id'] = offerId;
    data['item_name'] = itemName;
    data['item_price'] = itemPrice;
    data['item_image'] = itemImage;
    data['Item_offer_price'] = itemOfferPrice;
    return data;
  }
}
