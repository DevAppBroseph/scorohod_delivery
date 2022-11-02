import 'package:delivery/services/objects.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourierPrefsHandler {
  CourierPrefsHandler(this._preferences);

  final SharedPreferences _preferences;

  final String _courierToken = 'courierToken';
  final String _courierId = 'courierId';
  final String _courierName = 'driverName';
  final String _courierEmail = 'courierEmail';
  final String _courierPhone = 'courierPhone';
  final String _courierStatus = 'courierStatus';

  static Future<CourierPrefsHandler> getInstance() async {
    var shared = await SharedPreferences.getInstance();
    return CourierPrefsHandler(shared);
  }

  String getCourierToken() {
    return _preferences.getString(_courierToken) ?? '';
  }

  String getCourierName() {
    return _preferences.getString(_courierName) ?? '';
  }

  String getCourierEmail() {
    return _preferences.getString(_courierEmail) ?? '';
  }

  String getCourierPhone() {
    return _preferences.getString(_courierPhone) ?? '';
  }

  String getCourierId() {
    return _preferences.getString(_courierId) ?? '';
  }

  String getCourierStatus() {
    return _preferences.getString(_courierStatus) ?? '';
  }

  void setCourierToken(String token) {
    _preferences.setString(_courierToken, token);
  }

  void setCourierName(String name) {
    _preferences.setString(_courierName, name);
  }

  void setCourierEmail(String email) {
    _preferences.setString(_courierEmail, email);
  }

  void setCourierPhone(String phone) {
    _preferences.setString(_courierPhone, phone);
  }

  void setCourierId(String uid) {
    _preferences.setString(_courierId, uid);
  }

  void setCourierStatus(String status) {
    _preferences.setString(_courierStatus, status);
  }

  void setEmptyCourier() {
    _preferences.setString(_courierToken, '');
    _preferences.setString(_courierName, '');
    _preferences.setString(_courierEmail, '');
    _preferences.setString(_courierPhone, '');
    _preferences.setString(_courierStatus, '');
  }
}

class ManagerPrefsHandler {
  ManagerPrefsHandler(this._preferences);

  final SharedPreferences _preferences;

  final String _managerToken = 'managerToken';
  final String _managerId = 'managerId';
  final String _managerName = 'managerName';
  final String _managerEmail = 'managerEmail';
  final String _managerPhone = 'managerPhone';
  final String _managerStatus = 'courierEmail';
  final String _shopId = 'shopId';

  static Future<ManagerPrefsHandler> getInstance() async {
    var shared = await SharedPreferences.getInstance();
    return ManagerPrefsHandler(shared);
  }

  String getManagerToken() {
    return _preferences.getString(_managerToken) ?? '';
  }

  String getManagerEmail() {
    return _preferences.getString(_managerEmail) ?? '';
  }

  String getManagerPhone() {
    return _preferences.getString(_managerPhone) ?? '';
  }

  String getManagerId() {
    return _preferences.getString(_managerId) ?? '';
  }

  String getManagerStatus() {
    return _preferences.getString(_managerStatus) ?? '';
  }

  String getShopId() {
    return _preferences.getString(_shopId) ?? '';
  }

  String getManagerName() {
    return _preferences.getString(_managerName) ?? '';
  }

  void setManagerStatus(String status) {
    _preferences.setString(_managerStatus, status);
  }

  void setManagerId(String id) {
    _preferences.setString(_managerId, id);
  }

  void setManagerToken(String token) {
    _preferences.setString(_managerToken, token);
  }

  void setManagerEmail(String email) {
    _preferences.setString(_managerEmail, email);
  }

  void setManagerPhone(String phone) {
    _preferences.setString(_managerPhone, phone);
  }

  void setShopId(String id) {
    _preferences.setString(_shopId, id);
  }

  void setManagerName(String name) {
    _preferences.setString(_managerName, name);
  }

  void setEmptyManager() {
    _preferences.setString(_managerName, '');
    _preferences.setString(_managerToken, '');
    _preferences.setString(_managerId, '');
    _preferences.setString(_managerEmail, '');
    _preferences.setString(_managerPhone, '');
    _preferences.setString(_managerStatus, '');
    _preferences.setString(_shopId, '');
  }
}

class DataProvider extends ChangeNotifier {
  DataProvider(
    this._courier,
    this._manager,
    this._token,
  );

  Courier _courier;
  ManagerClass _manager;
  String _token;

  Courier get courier => _courier;
  ManagerClass get manager => _manager;
  String get token => _token;

  bool get hasCourier => _token != '';
  bool get hasManager => _manager.managerId != '';

  static Future<DataProvider> getInstance() async {
    var courierPrefs = await CourierPrefsHandler.getInstance();
    var managerPrefs = await ManagerPrefsHandler.getInstance();

    return DataProvider(
        Courier(
          courierName: courierPrefs.getCourierName(),
          courierEmail: courierPrefs.getCourierEmail(),
          courierPhone: courierPrefs.getCourierPhone(),
          courierId: courierPrefs.getCourierId(),
          courierStatus: courierPrefs.getCourierStatus(),
        ),
        ManagerClass(
          managerEmail: managerPrefs.getManagerEmail(),
          managerId: managerPrefs.getManagerId(),
          managerPhone: managerPrefs.getManagerPhone(),
          managerStatus: managerPrefs.getManagerStatus(),
          managerName: managerPrefs.getManagerName(),
          shopId: managerPrefs.getShopId(),
        ),
        courierPrefs.getCourierToken());
  }

  void setCourier(Courier courier, String token) {
    _courier = courier;
    _token = token;
    notifyListeners();
    CourierPrefsHandler.getInstance().then(
      (value) {
        value.setCourierEmail(courier.courierEmail);
        value.setCourierName(courier.courierName);
        value.setCourierPhone(courier.courierPhone);
        value.setCourierToken(token);
        value.setCourierId(courier.courierId);
      },
    );
  }

  void setManager(Manager manager) {
    _manager = manager.manager;
    // _token = token;
    notifyListeners();
    ManagerPrefsHandler.getInstance().then(
      (value) {
        value.setManagerEmail(manager.manager.managerEmail);
        value.setManagerId(manager.manager.managerId);
        value.setManagerName(manager.manager.managerName);
        value.setManagerPhone(manager.manager.managerPhone);
        value.setManagerStatus(manager.manager.managerStatus);
        value.setShopId(manager.manager.shopId);
        value.setManagerToken(manager.jwt);
      },
    );
  }

  void setCourierToken(String newToken) {
    _token = newToken;
    notifyListeners();
    CourierPrefsHandler.getInstance().then(
      (value) => value.setCourierToken(newToken),
    );
  }

  void setCourierStatus(String newStatus) {
    _courier.courierStatus = newStatus;
    notifyListeners();
    CourierPrefsHandler.getInstance().then(
      (value) => value.setCourierStatus(newStatus),
    );
  }

  void setCourierUid(String newId) {
    _courier.courierId = newId;
    notifyListeners();
    CourierPrefsHandler.getInstance().then(
      (value) => value.setCourierId(newId),
    );
  }

  void setCourierName(String newName) {
    _courier.courierName = newName;
    notifyListeners();
    CourierPrefsHandler.getInstance().then(
      (value) => value.setCourierName(newName),
    );
  }

  void setCourierEmail(String newEmail) {
    _courier.courierEmail = newEmail;
    notifyListeners();
    CourierPrefsHandler.getInstance().then(
      (value) => value.setCourierEmail(newEmail),
    );
  }

  void setCourierPhone(String newPhone) {
    _courier.courierPhone = newPhone;
    notifyListeners();
    CourierPrefsHandler.getInstance().then(
      (value) => value.setCourierPhone(newPhone),
    );
  }

  void signOutCourier() {
    _courier = Courier(
        courierName: '',
        courierEmail: '',
        courierPhone: '',
        courierId: '',
        courierStatus: '');
    _token = '';
    notifyListeners();

    CourierPrefsHandler.getInstance().then((value) => value.setEmptyCourier());
  }

  void setManagerStatus(String status) {
    _manager.managerStatus = status;
    notifyListeners();
    ManagerPrefsHandler.getInstance().then(
      (value) => value.setManagerStatus(status),
    );
  }

  void signOutManager() {
    _manager = ManagerClass(
      managerEmail: '',
      managerPhone: '',
      managerId: '',
      managerName: '',
      managerStatus: '',
      shopId: '',
    );
    // _token = '';
    notifyListeners();

    ManagerPrefsHandler.getInstance().then((value) => value.setEmptyManager());
  }
}
