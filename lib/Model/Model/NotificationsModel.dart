

import 'dart:convert';

List<NotificationsModel> dataNotificationsModelFromJson(var str) =>
    List<NotificationsModel>.from(json.decode(str).map((x) => NotificationsModel.fromJson(x)));


class NotificationsModel {
  int? id;
  String? title;
  String? body;
  String? date;

  NotificationsModel({this.id, this.title, this.body, this.date});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['date'] = date;
    return data;
  }
}
