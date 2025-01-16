
import 'dart:convert';

import 'package:shopping_land_delivery/Configuration/config.dart';

List<Advertisements> dataAdvertisementsFromJson(var str) =>
    List<Advertisements>.from(
        json.decode(str).map((x) => Advertisements.fromJson(x)));



class Advertisements {
  String? id;
  String? imageUrl;

  Advertisements({this.id, this.imageUrl});

  Advertisements.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    imageUrl = APIURLFile+json['image_url'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    return data;
  }
}