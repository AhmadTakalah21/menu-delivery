


import 'dart:convert';

import 'package:get/get.dart';
import 'package:shopping_land_delivery/Configuration/config.dart';
import 'package:shopping_land_delivery/main.dart';

List<Product> dataProductFromJson(var str) =>
    List<Product>.from(
        json.decode(str).map((x) => Product.fromJson(x)));




class Product {
  int? id;
  String? productName;
  String? itemName;
  String? itemImage;
  String? quantityColor;
  int? quantity;
  String? itemPrice;
  String? itemOfferPrice;
  String? priceColor;

  Product(
      {this.id,
        this.productName,
        this.itemName,
        this.itemImage,
        this.quantityColor,
        this.quantity,
        this.itemPrice,
        this.priceColor});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['Product_name'];
    itemName = json['item_name'];
    itemImage =  APIURLFile+json['item_image'];
    quantityColor = json['quantity_color'];
    quantity = json['quantity'];
    itemPrice = '${double.parse(json['item_price'].toString()).toInt()} ${alSettings.currency.tr}';
    itemOfferPrice = '${double.parse(json['item_offer_price'].toString()).toInt()} ${alSettings.currency.tr}';
    priceColor = json['price_color'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['Product_name'] = productName;
    data['item_name'] = itemName;
    data['item_image'] = itemImage;
    data['quantity_color'] = quantityColor;
    data['item_price'] = itemPrice;
    data['price_color'] = priceColor;
    data['quantity'] = quantity;
    return data;
  }
}
