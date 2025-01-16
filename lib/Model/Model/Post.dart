


import 'dart:convert';

import 'package:get/get.dart';
import 'package:shopping_land_delivery/Configuration/config.dart';

List<PostModel> dataPostFromJson(var str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));




class PostModel {
  int? id;
  String? title;
  String? description;
  List<Files>? files;
  RxInt? isLike;
  int? counterLikes;
  bool isFavChange =false;
  PostModel(
      {this.id,
        this.title,
        this.description,
        this.files,
        this.isLike,
        this.counterLikes});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    isLike = RxInt(json['is_like']);
    counterLikes = json['counter_likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    data['is_like'] = this.isLike;
    data['counter_likes'] = this.counterLikes;
    return data;
  }
}

class Files {
  int? id;
  String? url;

  Files({this.id, this.url});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = APIURLFile+json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}