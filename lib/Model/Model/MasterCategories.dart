

import 'dart:convert';

List<MasterCategories> dataMasterCategoriesModelFromJson(var str) =>
    List<MasterCategories>.from(json.decode(str).map((x) => MasterCategories.fromJson(x)));



class MasterCategories {
  int? id;
  String? name;
  int? isSub;
  bool? isActive;
  String? type;

  MasterCategories({this.id, this.name, this.isSub, this.isActive, this.type});

  MasterCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isSub = json['is_sub'];
    isActive = json['is_active'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_sub'] = this.isSub;
    data['is_active'] = this.isActive;
    data['type'] = this.type;
    return data;
  }
}
