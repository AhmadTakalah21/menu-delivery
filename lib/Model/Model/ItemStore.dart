





import 'dart:convert';

import 'package:shopping_land_delivery/Configuration/config.dart';

List<ItemStore> dataItemStoreFromJson(var str) => List<ItemStore>.from(json.decode(str).map((x) => ItemStore.fromJson(x)));







class ItemStore {
  int? id;
  int? itemId;
  String? itemName;
  String? itemImage;
  int? itemPrice;
  int? itemOfferPrice;
  int? itemQuantity;
  String? startOffer;
  String? endOffer;
  String? itemDescription;



  ItemStore(
      {this.id,
        this.itemId,
        this.itemName,
        this.itemImage,
        this.itemPrice,
        this.itemOfferPrice,
        this.itemQuantity,
        this.startOffer,
        this.endOffer});

  ItemStore.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['store_item_id'];
    itemName = json['item_name'];
    itemImage = APIURLFile+json['item_image'];
    itemPrice = json['item_price'];
    itemOfferPrice = json['item_offer_price'];
    itemQuantity = json['item_quantity'];
    startOffer = json['start_offer'];
    endOffer = json['end_offer'];
    itemDescription = json['description'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['item_name'] = itemName;
    data['item_image'] = itemImage;
    data['item_price'] = itemPrice;
    data['item_offer_price'] = itemOfferPrice;
    data['item_quantity'] = itemQuantity;
    data['start_offer'] = startOffer;
    data['end_offer'] = endOffer;
    return data;
  }
}









