





import 'dart:convert';

import 'package:shopping_land_delivery/Configuration/config.dart';

List<ItemStoreCategory> dataItemStoreCategoryFromJson(var str) => List<ItemStoreCategory>.from(json.decode(str).map((x) => ItemStoreCategory.fromJson(x)));


class ItemStoreCategory {
  String? id;
  String? storeId;
  String? itemId;
  String? itemName;
  int? itemPrice;
  List<ItemImages>? itemImages;
  String? itemDescription;
  int? quantity;

  ItemStoreCategory(
      {this.id,
        this.storeId,
        this.itemId,
        this.itemName,
        this.itemPrice,
        this.itemImages,
        this.itemDescription,
        this.quantity});

  ItemStoreCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    storeId = json['store_id'].toString();
    itemId = json['item_id'].toString();
    itemName = json['item_name'];
    itemPrice = double.parse(json['item_price'].toString()).toInt();
    if (json['item_images'] != null) {
      itemImages = <ItemImages>[];
      json['item_images'].forEach((v) {
        itemImages!.add(ItemImages.fromJson(v));
      });
    }
    if (json['item_image'] != null) {
      itemImages = <ItemImages>[];
      json['item_image'].forEach((v) {
        itemImages!.add(ItemImages.fromJson(v));
      });
    }



    itemDescription = json['item_description'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['store_id'] = storeId;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_price'] = itemPrice;
    if (itemImages != null) {
      data['item_images'] = itemImages!.map((v) => v.toJson()).toList();
    }
    data['item_description'] = itemDescription;
    data['quantity'] = quantity;
    return data;
  }
}

class ItemImages {
  String? imageUrl;

  ItemImages({this.imageUrl});

  ItemImages.fromJson(Map<String, dynamic> json) {
    imageUrl = APIURLFile+json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_url'] = imageUrl;
    return data;
  }
}
