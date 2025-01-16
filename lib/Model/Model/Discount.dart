


import 'dart:convert';

List<Discount> dataDiscountFromJson(var str) =>
    List<Discount>.from(json.decode(str).map((x) => Discount.fromJson(x)));




class Discount {
  String? id;
  String? cartId;
  int? amount;
  int? percent;
  String? reason;

  Discount({this.id, this.cartId, this.amount, this.percent, this.reason});

  Discount.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    cartId = json['cart_id'].toString();
    amount = json['amount'];
    percent = json['percent'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['cart_id'] = cartId;
    data['amount'] = amount;
    data['percent'] = percent;
    data['reason'] = reason;
    return data;
  }
}
