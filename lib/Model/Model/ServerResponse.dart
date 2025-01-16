import 'dart:convert';

List<ServerResponse> dataServerResponseFromJson(var str) =>
    List<ServerResponse>.from(
        json.decode(str).map((x) => ServerResponse.fromJson(x)));

class ServerResponse {
  String? description;
  int? state;
  dynamic data;

  ServerResponse({this.description, this.state, this.data});

  ServerResponse.fromJson(Map<String, dynamic> jsonDate) {
    description = jsonDate['description'];
    state = jsonDate['status'];
    if (jsonDate['data'] != null) {
      data = json.encode(jsonDate['data']);
    }
  }
}