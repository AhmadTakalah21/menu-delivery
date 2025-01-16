


import 'dart:convert';

List<CartModel> dataCartModelFromJson(var str) =>
    List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));




class CartModel {
  int? totalPriceAfterDiscount;
  List<Carts>? carts;

  CartModel({this.totalPriceAfterDiscount, this.carts});

  CartModel.fromJson(Map<String, dynamic> json) {
    totalPriceAfterDiscount = json['total_price_after_discount'];
    if (json['carts'] != null) {
      carts = <Carts>[];
      json['carts'].forEach((v) {
        carts!.add(new Carts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_price_after_discount'] = this.totalPriceAfterDiscount;
    if (this.carts != null) {
      data['carts'] = this.carts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Carts {
  int? id;
  int? price;
  int? quantity;
  Item? item;
  List<CartDetail>? cartDetail;

  Carts({this.id, this.price, this.quantity, this.item, this.cartDetail});

  Carts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    quantity = json['quantity'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    if (json['cart_detail'] != null) {
      cartDetail = <CartDetail>[];
      json['cart_detail'].forEach((v) {
        cartDetail!.add(new CartDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    if (this.cartDetail != null) {
      data['cart_detail'] = this.cartDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  int? id;
  String? name;
  int? price;
  String? brandName;
  Null? priceAfterOffer;
  int? isFav;
  int? countFavourites;
  Image? image;

  Item(
      {this.id,
        this.name,
        this.price,
        this.brandName,
        this.priceAfterOffer,
        this.isFav,
        this.countFavourites,
        this.image});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    brandName = json['brand_name'];
    priceAfterOffer = json['price_after_offer'];
    isFav = json['is_fav'];
    countFavourites = json['count_favourites'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['brand_name'] = this.brandName;
    data['price_after_offer'] = this.priceAfterOffer;
    data['is_fav'] = this.isFav;
    data['count_favourites'] = this.countFavourites;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Image {
  int? id;
  String? url;

  Image({this.id, this.url});

  Image.fromJson(Map<String, dynamic> json) {
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

class CartDetail {
  String? name;
  List<Measurements>? measurements;

  CartDetail({this.name, this.measurements});

  CartDetail.fromJson(Map<String, dynamic> json) {
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

  Measurements({this.id, this.name});

  Measurements.fromJson(Map<String, dynamic> json) {
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

