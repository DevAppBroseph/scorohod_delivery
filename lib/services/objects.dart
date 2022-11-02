import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

StandartAnswer standartAnswerFromJson(String str) =>
    StandartAnswer.fromJson(json.decode(str));

String standartAnswerToJson(StandartAnswer data) => json.encode(data.toJson());

class StandartAnswer {
  StandartAnswer({
    required this.message,
  });

  String message;

  factory StandartAnswer.fromJson(Map<String, dynamic> json) => StandartAnswer(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

CourierAnswer courierAnswerFromJson(String str) =>
    CourierAnswer.fromJson(json.decode(str));

String courierAnswerToJson(CourierAnswer data) => json.encode(data.toJson());

class CourierAnswer {
  CourierAnswer({
    required this.message,
    required this.courier,
    required this.jwt,
  });

  String message;
  Courier courier;
  String jwt;

  factory CourierAnswer.fromJson(Map<String, dynamic> json) => CourierAnswer(
        message: json["message"],
        courier: Courier.fromJson(json["courier"]),
        jwt: json["jwt"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "courier": courier.toJson(),
        "jwt": jwt,
      };
}

class Courier {
  Courier({
    required this.courierId,
    required this.courierName,
    required this.courierEmail,
    required this.courierPhone,
    required this.courierStatus,
  });

  String courierId;
  String courierName;
  String courierEmail;
  String courierPhone;
  String courierStatus;

  factory Courier.fromJson(Map<String, dynamic> json) => Courier(
        courierId: json["courier_id"],
        courierName: json["courier_name"],
        courierEmail: json["courier_email"],
        courierPhone: json["courier_phone"],
        courierStatus: json["courier_status"],
      );

  Map<String, dynamic> toJson() => {
        "courier_id": courierId,
        "courier_name": courierName,
        "courier_email": courierEmail,
        "courier_phone": courierPhone,
      };
}

String ordersElementsToJson(List<OrderElement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<OrderElement> ordersElementFromJson(String str) => List<OrderElement>.from(
    json.decode(str).map((x) => OrderElement.fromJson(x)));

class OrderElement {
  OrderElement({
    required this.id,
    required this.quantity,
    required this.price,
    required this.basePrice,
    required this.weight,
    required this.image,
    required this.name,
  });

  int id;
  int quantity;
  double price;
  double basePrice;
  String weight;
  String? image;
  String name;

  factory OrderElement.fromJson(Map<String, dynamic> json) => OrderElement(
        id: json["id"],
        quantity: json["quantity"],
        price: double.tryParse(json["price"].toString()) ?? 1.0,
        basePrice: double.parse(json["basePrice"].toString()),
        weight: json["weight"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "price": price,
        "weight": weight,
        "name": name,
        "basePrice": basePrice,
        "image": image,
      };
}

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
// LatLng latLngFromJson(String str) => LatLng.fromJson(json.decode(str))!;
List<Order> ordersFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(Order data) => json.encode(data.toJson());
String latLngToJson(LatLng data) => json.encode(data.toJson());

class Order {
  Order({
    required this.orderId,
    required this.date,
    required this.status,
    required this.products,
    required this.totalPrice,
    required this.clientId,
    required this.address,
    required this.fcmToken,
    required this.userLatLng,
    required this.discount,
    required this.receiptId,
    required this.courierId,
    required this.shopId,
    required this.city,
  });

  String orderId;
  String date;
  String status;
  List<OrderElement> products;
  String totalPrice;
  String clientId;
  String address;
  String fcmToken;
  Coordinates userLatLng;
  String discount;
  String receiptId;
  String courierId;
  String shopId;
  String city;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"],
        date: json["date"] ?? '',
        status: json["status"],
        products: ordersElementFromJson(json["products"]),
        totalPrice: json["total_price"],
        clientId: json["client_id"],
        address: json["address"],
        fcmToken: json["fcm_token"],
        userLatLng: coordinatesFromJson(json['user_lat_lng']),
        discount: json["discount"],
        receiptId: json["receipt_id"],
        courierId: json["courier_id"],
        shopId: json["shop_id"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "date": date,
        "status": status,
        "products": products,
        "total_price": totalPrice,
        "client_id": clientId,
        "address": address,
        "discount": discount,
        "receipt_id": receiptId,
        "shop_id": shopId,
      };
}

String coordinatesToJson(Coordinates data) => json.encode(data.toJson());
Coordinates coordinatesFromJson(String str) =>
    Coordinates.fromJson(json.decode(str));

class Coordinates {
  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
        longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}

List<Shop> shopsFromJson(String str) =>
    List<Shop>.from(json.decode(str).map((x) => Shop.fromJson(x)));

String shopsToJson(List<Shop> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
  Shop({
    required this.shopId,
    required this.shopName,
    required this.shopLogo,
    required this.categoryId,
    required this.shopDescription,
    required this.shopMinSum,
    required this.shopAddress,
    required this.shopPriceDelivery,
    required this.shopWorkingHours,
    required this.shopStatus,
  });

  String shopId;
  String shopName;
  String shopLogo;
  String categoryId;
  String shopDescription;
  String shopMinSum;
  String shopAddress;
  String shopPriceDelivery;
  String shopWorkingHours;
  String shopStatus;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        shopId: json["shop_id"],
        shopName: json["shop_name"],
        shopLogo: json["shop_logo"],
        categoryId: json["category_id"],
        shopDescription: json["shop_description"],
        shopMinSum: json["shop_min_sum"],
        shopAddress: json["shop_address"],
        shopPriceDelivery: json["shop_price_delivery"],
        shopWorkingHours: json["shop_working_hours"],
        shopStatus: json["shop_status"],
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "shop_name": shopName,
        "shop_logo": shopLogo,
        "category_id": categoryId,
        "shop_description": shopDescription,
        "shop_min_sum": shopMinSum,
        "shop_price_delivery": shopPriceDelivery,
        "shop_working_hours": shopWorkingHours,
        "shop_status": shopStatus,
      };
}

//Manager Objects

Manager managerFromJson(String str) => Manager.fromJson(json.decode(str));

String managerToJson(Manager data) => json.encode(data.toJson());

class Manager {
  Manager({
    required this.message,
    required this.manager,
    required this.jwt,
  });

  String message;
  ManagerClass manager;
  String jwt;

  factory Manager.fromJson(Map<String, dynamic> json) => Manager(
        message: json["message"],
        manager: ManagerClass.fromJson(json["manager"]),
        jwt: json["jwt"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "manager": manager.toJson(),
        "jwt": jwt,
      };
}

class ManagerClass {
  ManagerClass({
    required this.managerEmail,
    required this.managerPhone,
    required this.managerId,
    required this.managerStatus,
    required this.managerName,
    required this.shopId,
  });

  String managerEmail;
  String managerPhone;
  String managerId;
  String managerName;
  String managerStatus;
  String shopId;

  factory ManagerClass.fromJson(Map<String, dynamic> json) => ManagerClass(
        managerEmail: json["manager_email"],
        managerPhone: json["manager_phone"],
        managerId: json["manager_id"],
        managerName: json["manager_name"],
        managerStatus: json["manager_status"],
        shopId: json["shop_id"],
      );

  Map<String, dynamic> toJson() => {
        "manager_email": managerEmail,
        "manager_phone": managerPhone,
        "manager_id": managerId,
        "manager_status": managerStatus,
        "shop_id": shopId,
      };
}

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.userId,
    required this.userName,
    required this.dateAuth,
    required this.phone,
    required this.token,
    required this.email,
    required this.uid,
    required this.os,
    required this.address,
    required this.room,
    required this.entrance,
    required this.floor,
  });

  String userId;
  String userName;
  String dateAuth;
  String phone;
  String token;
  String email;
  String uid;
  String os;
  String address;
  String room;
  String entrance;
  String floor;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        dateAuth: json["date_auth"],
        phone: json["phone"],
        token: json["token"],
        email: json["email"],
        uid: json["uid"],
        os: json["os"],
        address: json["address"],
        room: json["room"],
        entrance: json["entrance"],
        floor: json["floor"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "date_auth": dateAuth,
        "phone": phone,
        "token": token,
        "email": email,
        "uid": uid,
        "os": os,
        "address": address,
        "room": room,
        "entrance": entrance,
        "floor": floor,
      };
}

DeliveryInfo deliveryInfoFromJson(String str) =>
    DeliveryInfo.fromJson(json.decode(str));

String deliveryInfoToJson(DeliveryInfo data) => json.encode(data.toJson());

class DeliveryInfo {
  DeliveryInfo({
    required this.id,
    required this.countrySum,
    required this.outsideSum,
    required this.settlementDate,
  });

  String id;
  String countrySum;
  String outsideSum;
  String settlementDate;

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) => DeliveryInfo(
        id: json["id"],
        countrySum: json["country_sum"],
        outsideSum: json["outside_sum"],
        settlementDate: json["settlement_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_sum": countrySum,
        "outside_sum": outsideSum,
        "settlement_date": settlementDate,
      };
}
List<Group> groupsFromJson(String str) =>
    List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

class Group {
  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.parentId,
    required this.shopId,
    required this.groupImage,
  });

  String id;
  String name;
  String description;
  String parentId;
  String shopId;
  String groupImage;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    parentId: json["parent_id"],
    shopId: json["shop_id"],
    groupImage: json["group_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "parent_id": parentId,
    "shop_id": shopId,
    "group_image": groupImage,
  };
}

List<Product> productsFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    required this.nomenclatureId,
    required this.itemNumber,
    required this.name,
    required this.shopId,
    required this.groupId,
    required this.image,
    required this.description,
    required this.measure,
    required this.manufacturer,
    required this.terms,
    required this.price,
    required this.archive,
  });

  String nomenclatureId;
  String itemNumber;
  String name;
  String shopId;
  String groupId;
  String image;
  String description;
  String measure;
  String manufacturer;
  String terms;
  double price;
  String archive;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    nomenclatureId: json["nomenclature_id"] ?? '',
    itemNumber: json["item_number"] ?? '',
    name: json["name"] ?? '',
    shopId: json["shop_id"] ?? '',
    groupId: json["group_id"] ?? '',
    image: json["image"] ?? '',
    description: json["description"] ?? '',
    measure: json["measure"] ?? '',
    manufacturer: json["manufacturer"] ?? '',
    terms: json["terms"] ?? '',
    price: (int.tryParse(json['price'].toString()) ??
        double.parse(json['price'].toString()))
        .toDouble(),
    archive: json["archive"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "nomenclature_id": nomenclatureId,
    "item_number": itemNumber,
    "name": name,
    "shop_id": shopId,
    "group_id": groupId,
    "image": image,
    "description": description,
    "measure": measure,
    "manufacturer": manufacturer,
    "terms": terms,
    "price": price,
  };
}