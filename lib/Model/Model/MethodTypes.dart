

import 'dart:convert';

List<MethodTypes> dataMethodTypesFromJson(var str) =>
    List<MethodTypes>.from(json.decode(str).map((x) => MethodTypes.fromJson(x)));



class MethodTypes {
  int? id;
  String? name;
  int? isActive;
  String? accountNumber;

  MethodTypes({this.id, this.name, this.isActive, this.accountNumber});

  MethodTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    accountNumber = json['account_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['account_number'] = this.accountNumber;
    return data;
  }
}
