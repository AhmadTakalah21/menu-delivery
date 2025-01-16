


import 'dart:convert';

List<DeliveryType> dataDeliveryTypeMFromJson(var str) =>
    List<DeliveryType>.from(json.decode(str).map((x) => DeliveryType.fromJson(x)));




class DeliveryType {
  int? id;
  String? name;
  int? isActive;
  int? fromPrice;
  int? toPrice;
  int? fromDays;
  int? toDays;

  DeliveryType(
      {this.id,
        this.name,
        this.isActive,
        this.fromPrice,
        this.toPrice,
        this.fromDays,
        this.toDays});

  DeliveryType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['from_price'] = this.fromPrice;
    data['to_price'] = this.toPrice;
    data['from_days'] = this.fromDays;
    data['to_days'] = this.toDays;
    return data;
  }
}
