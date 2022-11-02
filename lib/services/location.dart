import 'dart:async';
import 'dart:io';
import 'package:delivery/services/network.dart';
import 'package:delivery/services/objects.dart';
import 'package:delivery/widgets/settings_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  Location(
    this.context,
    this.courier,
  );

  final BuildContext context;
  final Courier courier;
  Timer? _timer;

  void startLocation() async {
    var perm = await checkPermission();
    print(perm);

    if (perm) {
      var location = await Geolocator.getCurrentPosition();

      if (courier.courierStatus == '1') sendLocation(location);
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        if (courier.courierStatus == '1') sendLocation(location);
      });
    }
  }

  void stopLocation() async {
    _timer?.cancel();
  }

  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      if (Platform.isAndroid) {
        if (!(await showUserRequest())) {
          return false;
        }
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  void sendLocation(Position location) {
    NetHandler.updateCourierLocation(
      context,
      courier.courierId,
      Coordinates(latitude: location.latitude, longitude: location.longitude),
    );
  }

  Future<bool> showUserRequest() async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => UserLocationMessage(),
      ),
    );
  }
}

class UserLocationMessage extends StatelessWidget {
  const UserLocationMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
          false,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text("Местоположение"),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  "assets/your-location.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(25, 40, 25, 40),
                child: Text(
                  "Разрешите доступ к Вашему местоположению. Ваше местоположение будет передаваться при активных заявках, для отслеживания прогресса выполнения. Если Вы не разрешите доступ к Вашему местоположению сейчас, это можно будет сделать позже в настройках.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SettingsCard(
                icon: null,
                text: "Разрешить",
                onTap: () => Navigator.pop(context, true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
