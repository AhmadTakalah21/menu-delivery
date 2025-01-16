


import 'dart:convert';

List<Types> dataTypesFromJson(var str) =>
    List<Types>.from(json.decode(str).map((x) => Types.fromJson(x)));



class Types {
  int? id;
  String? name;
  bool? isActive;

  Types({this.id, this.name, this.isActive});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    return data;
  }
}