




import 'dart:convert';

import 'package:get/get.dart';

List<ItemsDetailsModel> dataItemsDetailsModelFromJson(var str) =>
    List<ItemsDetailsModel>.from(json.decode(str).map((x) => ItemsDetailsModel.fromJson(x)));




class ItemsDetailsModel {
  int? id;
  String? name;
  int? price;
  String? description;
  bool? isActive;
  String? brandName;
  RxInt? isFav;
  bool isFavChange =false;

  int? countFavourites;
  int? priceAfterOffer;
  List<Images>? images;
  List<Units>? units;
  List<Tags>? tags;

  ItemsDetailsModel(
      {this.id,
        this.name,
        this.price,
        this.description,
        this.isActive,
        this.brandName,
        this.isFav,
        this.countFavourites,
        this.priceAfterOffer,
        this.images,
        this.units,
        this.tags});

  ItemsDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
    isActive = json['is_active'];
    brandName = json['brand_name'];
    isFav = RxInt(json['is_fav']);
    countFavourites = json['count_favourites'];
    priceAfterOffer = json['price_after_offer'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['units'] != null) {
      units = <Units>[];
      json['units'].forEach((v) {
        units!.add(new Units.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    data['brand_name'] = this.brandName;
    data['is_fav'] = this.isFav;
    data['count_favourites'] = this.countFavourites;
    data['price_after_offer'] = this.priceAfterOffer;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.units != null) {
      data['units'] = this.units!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  int? id;
  String? url;

  Images({this.id, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class Units {
  String? name;
  List<Measurements>? measurements;

  Units({this.name, this.measurements});

  Units.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['measurements'] != null) {
      measurements = <Measurements>[];
      json['measurements'].forEach((v) {
        measurements!.add(new Measurements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.measurements != null) {
      data['measurements'] = this.measurements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Measurements {
  int? id;
  String? name;
  String? unitName;

  Measurements({this.id, this.name, this.unitName});

  Measurements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    unitName = json['unit_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['unit_name'] = this.unitName;
    return data;
  }
}

class Tags {
  int? id;
  String? name;

  Tags({this.id, this.name});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}