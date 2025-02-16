

import 'dart:convert';

List<OrderModel> dataOrderHistoryMFromJson(var str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));



enum OrderHistoryStatus
{

  processing,
  under_delivery,
  accepted,


}



class OrderModel {
  int? id;
  int? num;
  String? createdAt;
  String? user;
  String? userPhone;
  String? status;
  String? total;
  int? restaurantId;
  String? delivery_price;
  String? address;
  String? longitude;
  String? latitude;

  List<OrderItem>? orders;

  OrderModel({
    this.id,
    this.num,
    this.createdAt,
    this.user,
    this.userPhone,
    this.status,
    this.total,
    this.delivery_price,
    this.restaurantId,
    this.address,
    this.longitude,
    this.latitude,
    this.orders,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      num: json['num'],
      createdAt: json['created_at'],
      user: json['user'],
      userPhone: json['user_phone'],
      status: json['status'],
      delivery_price: json['delivery_price'],
      total: json['total'],
      restaurantId: json['restaurant_id'],
      address: json['address'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      orders: json['orders'] != null
          ? List<OrderItem>.from(json['orders'].map((x) => OrderItem.fromJson(x)))
          : [],
    );
  }
}

class OrderItem {
  int? id;
  String? name;
  String? type;
  int? price;
  int? count;
  int? total;

  OrderItem({
    this.id,
    this.name,
    this.type,
    this.price,
    this.count,
    this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      price: json['price'],
      count: json['count'],
      total: json['total'],
    );
  }
}



