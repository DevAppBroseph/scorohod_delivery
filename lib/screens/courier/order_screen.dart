import 'dart:async';

import 'package:delivery/services/constants.dart';
import 'package:delivery/widgets/app_bar.dart';
import 'package:flutter/material.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key, required this.time}) : super(key: key);
  final String time;

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // late YandexMapController _mapController;
  bool isCreated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: CustomScrollView(
          slivers: [
            StandartAppBar(
              title: const Text('Заказ'),
              actions: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Text(
                    widget.time,
                    style: const TextStyle(
                        fontSize: 17, color: Color.fromRGBO(255, 87, 87, 1)),
                  ),
                ))
              ],
            ),
            // SliverToBoxAdapter(
            //   child: Container(
            //     height: 200,
            //     width: double.infinity,
            //     margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            //     child: ClipRRect(
            //       borderRadius: radius,
            //       child: YandexMap(
            //         mapObjects: [],
            //         liteModeEnabled: true,
            //         zoomGesturesEnabled: true,
            //         nightModeEnabled:
            //             Theme.of(context).backgroundColor == Colors.white
            //                 ? false
            //                 : true,
            //         onMapCreated: (controller) {
            //           setState(
            //             () {
            //               _mapController = controller;
            //               isCreated = true;
            //             },
            //           );
            //           controller.moveCamera(
            //             CameraUpdate.newCameraPosition(
            //               const CameraPosition(
            //                 target:
            //                     Point(latitude: 57.04945, longitude: 34.95638),
            //                 zoom: 11,
            //               ),
            //             ),
            //             animation: const MapAnimation(duration: 2.0),
            //           );
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            SliverToBoxAdapter(
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text('Г. Торжок, Осташковская улица, 26.'),
                ),
              ),
            )
          ],
        ));
  }
}
