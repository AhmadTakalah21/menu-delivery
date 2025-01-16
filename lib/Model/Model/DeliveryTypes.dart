

import 'dart:convert';

List<DeliveryTypes> dataDeliveryTypesFromJson(var str) =>
    List<DeliveryTypes>.from(json.decode(str).map((x) => DeliveryTypes.fromJson(x)));




class DeliveryTypes {
  int? id;
  String? name;
  int? isActive;
  int? fromPrice;
  int? toPrice;
  int? fromDays;
  int? toDays;

  DeliveryTypes(
      {this.id,
        this.name,
        this.isActive,
        this.fromPrice,
        this.toPrice,
        this.fromDays,
        this.toDays});

  DeliveryTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    fromPrice = json['from_price'];
    toPrice = json['to_price'];
    fromDays = json['from_days'];
    toDays = json['to_days'];
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
