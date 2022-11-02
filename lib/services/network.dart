import 'package:delivery/models/error.dart';
import 'package:delivery/services/app_data.dart';
import 'package:delivery/services/constants.dart';
import 'package:delivery/services/objects.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

enum Method { get, post, put, delete }

class NetHandler {
  static Future<String?> request({
    required BuildContext context,
    required String url,
    required String token,
    required Method method,
    required Map<String, String> params,
  }) async {
    // var appData = Provider.of<AppData>(context, listen: false);
    var headers = {"authorization": "Bearer $token", "version": "1"};
    var uri = Uri.parse(apiUrl + url);

    late Response response;

    switch (method) {
      case Method.get:
        response = await get(uri, headers: headers);
        break;
      case Method.post:
        response = await post(uri, body: params, headers: headers);
        break;
      case Method.put:
        response = await put(uri, body: params, headers: headers);
        break;
      case Method.delete:
        response = await delete(uri, body: params, headers: headers);
        break;
    }

    // switch (response.statusCode) {
    //   case 200:
    //     appData.setWebError(200);
    return response.body;
    //   case 400:
    //     appData.setWebError(400, error: answerErrorFromJson(response.body));
    //     break;
    //   default:
    //     appData.setWebError(600);
    //     break;
    // }
  }

  static Future<CourierAnswer?> authCourier(
      BuildContext context, String login, String password, String token) async {
    var data = await request(
      context: context,
      url: 'courier/login/',
      token: authToken,
      method: Method.post,
      params: {'login': login, 'password': password, 'token': token},
    );

    try {
      return data != null ? courierAnswerFromJson(data) : null;
    } catch (e) {
      return null;
    }

    // return data != null ? courierAnswerFromJson(data) : null;
  }

  Future<List<Group>?> getGroups(BuildContext context) async {
    var data = await request(
      url: "user/groups",
      method: Method.get,
      context: context,
      token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzZXJ2ZXIuc2Nvcm9ob2Quc2hvcCIsImF1ZCI6InNlcnZlci5zY29yb2hvZC5zaG9wIiwiaWF0IjoxNjYzMjUyMTA3LCJuYmYiOjE2NjMyNTIxMDcsImRhdGEiOnsiYWRtaW5fdWlkIjoiZDFhM2E4ZDNlYTZmM2ZjMjliZWI5YWM0YWVmYzIyNzAiLCJhZG1pbl9yb2xlIjoiMSJ9fQ.-BSWzt0A7FP0MWyY6Kj1FyNaSQwE8Cex3F0Lkf2JJSc',
      params: {},
    );

    return data != null ? groupsFromJson(data) : null;
  }

  Future<List<Product>?> getProducts(BuildContext context) async {
    var data = await request(
      url: "user/nomenclatures",
      method: Method.get,
      context: context,
      token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzZXJ2ZXIuc2Nvcm9ob2Quc2hvcCIsImF1ZCI6InNlcnZlci5zY29yb2hvZC5zaG9wIiwiaWF0IjoxNjYzMjUyMTA3LCJuYmYiOjE2NjMyNTIxMDcsImRhdGEiOnsiYWRtaW5fdWlkIjoiZDFhM2E4ZDNlYTZmM2ZjMjliZWI5YWM0YWVmYzIyNzAiLCJhZG1pbl9yb2xlIjoiMSJ9fQ.-BSWzt0A7FP0MWyY6Kj1FyNaSQwE8Cex3F0Lkf2JJSc',
      params: {},
    );
    print(data);
    return data != null ? productsFromJson(data) : null;
  }

  static Future<StandartAnswer?> updateCourierLocation(
      BuildContext context, String courierId, Coordinates coordinates) async {
    var data = await request(
      context: context,
      url: 'courier/location/$courierId',
      token: authToken,
      method: Method.put,
      params: {
        'location': coordinatesToJson(coordinates),
      },
    );
    print(data);

    return data != null ? standartAnswerFromJson(data) : null;
  }

  static Future<List<Order>?> getNewOrders(BuildContext context) async {
    var data = await request(
      context: context,
      url: 'courier/order',
      token: authToken,
      method: Method.get,
      params: {},
    );
    print('data is: ' + data.toString());

    return data != null ? ordersFromJson(data) : null;
  }

  static Future<List<Order>?> getCourierOrders(
      BuildContext context, String courierId) async {
    var data = await request(
      context: context,
      url: 'courier/order/$courierId',
      token: authToken,
      method: Method.get,
      params: {},
    );
    print('data is: ' + data.toString());

    return data != null ? ordersFromJson(data) : null;
  }

  static Future<User?> getOrderUser(BuildContext context, String userId) async {
    var data = await request(
      context: context,
      url: 'manager/user/$userId',
      token: authToken,
      method: Method.get,
      params: {},
    );
    return data != null ? userFromJson(data) : null;
  }

  static Future<List<Order>?> setOrderStatus(
    BuildContext context,
    String courierId,
    String orderId,
    bool courier,
    String status,
    String statusName,
    String token,
  ) async {
    var data = await request(
      context: context,
      url: courier ? 'courier/order/$courierId' : 'manager/order/$courierId',
      token: authToken,
      method: Method.put,
      params: {
        'order_id': orderId,
        'status': status,
        'status_name': statusName,
        "token": token,
      },
    );
    print(courierId);

    return data != null ? ordersFromJson(data) : null;
  }

  static Future<bool> setCourierStatus(
    BuildContext context,
    String courierId,
    int status,
  ) async {
    var data = await request(
      context: context,
      url: 'courier/status/$courierId',
      token: authToken,
      method: Method.put,
      params: {
        'status': status.toString(),
      },
    );
    print('data is: ' + data.toString());

    return data != null ? true : false;
  }

  static Future<bool> setManagerStatus(
    BuildContext context,
    String managerId,
    int status,
  ) async {
    var data = await request(
      context: context,
      url: 'manager/status/$managerId',
      token: authToken,
      method: Method.put,
      params: {
        'status': status.toString(),
      },
    );

    return data != null ? true : false;
  }

  Future<DeliveryInfo?> getDeliveryInfo(BuildContext context) async {
    var data = await request(
        context: context,
        url: "courier/delivery",
        token: authToken,
        method: Method.get,
        params: {});
    print(data);

    return data != null ? deliveryInfoFromJson(data) : null;
  }

  static Future<List<Order>?> changeProduct(
    BuildContext context,
    String managerId,
    String orderId,
    String token,
    List<OrderElement> products,
    String totalPrice,
  ) async {
    var data = await request(
      context: context,
      url: 'manager/product/$managerId',
      token: authToken,
      method: Method.put,
      params: {
        'order_id': orderId,
        'token': token,
        'products': ordersElementsToJson(products),
        "total_price": totalPrice,
      },
    );
    print(data);

    return data != null ? ordersFromJson(data) : null;
  }

  static Future<List<Shop>?> getShops(BuildContext context) async {
    var data = await request(
      context: context,
      url: 'courier/shops',
      token: authToken,
      method: Method.get,
      params: {},
    );

    return data != null ? shopsFromJson(data) : null;
  }

  //Manager
  static Future<Manager?> authManager(BuildContext context, String login,
      String password, String fcmToken) async {
    var data = await request(
      context: context,
      url: 'manager/login/',
      token: authToken,
      method: Method.post,
      params: {'login': login, 'password': password, "fcm_token": fcmToken},
    );

    try {
      return data != null ? managerFromJson(data) : null;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Order>?> getManagerOrders(
      BuildContext context, String shopId) async {
    var data = await request(
      context: context,
      url: 'manager/order/$shopId',
      token: authToken,
      method: Method.get,
      params: {},
    );
    print('data is: ' + data.toString());
    return data != null ? ordersFromJson(data) : null;
  }

  static Future<Shop?> getCurrentShop(
      BuildContext context, String shopId) async {
    var data = await request(
      context: context,
      url: 'courier/shops/$shopId',
      token: authToken,
      method: Method.get,
      params: {},
    );

    return data != null ? shopFromJson(data) : null;
  }
}
