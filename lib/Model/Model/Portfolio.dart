


import 'dart:convert';

import '../../main.dart';

List<Portfolio> dataWithdrawalsFromJson(var str) =>
    List<Portfolio>.from(json.decode(str).map((x) => Portfolio.fromJson(x)));


class Portfolio {
  String? name;
  int? balance;
  List<Sell>? withdrawals;
  List<Sells>? sells;

  Portfolio({this.name, this.balance, this.withdrawals, this.sells});

  Portfolio.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    balance = json['balance'];
    if (json['withdrawals'] != null) {
      withdrawals = <Sell>[];
      json['withdrawals'].forEach((v) {
        withdrawals!.add( Sell.fromJson(v));
      });
    }
    if (json['sells'] != null) {
      sells = <Sells>[];
      json['sells'].forEach((v) {
        sells!.add(Sells.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['balance'] = balance;
    if (withdrawals != null) {
      data['withdrawals'] = withdrawals!.map((v) => v.toJson()).toList();
    }
    if (sells != null) {
      data['sells'] = sells!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sell {
  int? id;
  String? amount;
  String? date;

  Sell({this.id, this.amount, this.date});

  Sell.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = '${json['amount']} ${alSettings.currency}';
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['date'] = date;
    return data;
  }
}

class Sells {
  int? id;
  String? orderPrice;
  String? date;

  Sells({this.id, this.orderPrice, this.date});

  Sells.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderPrice = '${json['order_price']} ${alSettings.currency}';;
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_price'] = orderPrice;
    data['date'] = date;
    return data;
  }
}
