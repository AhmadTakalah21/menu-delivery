
import 'dart:convert';

List<SubCategories> dataSubCategoriesModelFromJson(var str) =>
    List<SubCategories>.from(json.decode(str).map((x) => SubCategories.fromJson(x)));




class SubCategories {
  int? id;
  String? name;
  bool? isActive;

  SubCategories({this.id, this.name, this.isActive});

  SubCategories.fromJson(Map<String, dynamic> json) {
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