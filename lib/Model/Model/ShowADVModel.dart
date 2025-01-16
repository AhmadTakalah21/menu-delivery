



import 'dart:convert';

import 'package:shopping_land_delivery/Configuration/config.dart';

List<ShowADVModel> dataItemStoreCategoryFromJson(var str) => List<ShowADVModel>.from(json.decode(str).map((x) =>
    ShowADVModel.fromJson(x)));




class ShowADVModel {
  int? id;
  int? superAdminId;
  String? title;
  String? imageUrl;
  String? fromDate;
  String? toDate;

  ShowADVModel(
      {this.id,
        this.superAdminId,
        this.title,
        this.imageUrl,
        this.fromDate,
        this.toDate});

  ShowADVModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    superAdminId = json['superAdmin_id'];
    title = json['title'];
    imageUrl = APIURLFile+json['image_url'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['superAdmin_id'] = this.superAdminId;
    data['title'] = this.title;
    data['image_url'] = this.imageUrl;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    return data;
  }
}
