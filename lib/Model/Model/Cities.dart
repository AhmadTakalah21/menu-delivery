


import 'dart:convert';

List<Cities> dataCitiesFromJson(var str) =>
    List<Cities>.from(json.decode(str).map((x) => Cities.fromJson(x)));


class Cities {
  String? id;
  int? superAdminId;
  String? name;

  Cities({this.id, this.superAdminId, this.name});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    superAdminId = json['superAdmin_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['superAdmin_id'] = superAdminId;
    data['name'] = name;
    return data;
  }
}
