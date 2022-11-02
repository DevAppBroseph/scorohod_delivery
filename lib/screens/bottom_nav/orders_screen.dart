import 'dart:async';

import 'package:collection/collection.dart';
import 'package:delivery/services/constants.dart';
import 'package:delivery/services/network.dart';
import 'package:delivery/services/objects.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/app_bar.dart';
import 'package:delivery/widgets/order_element_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _newOrders = [];
  List<Shop> _shops = [];
  late Timer timer;
  bool _loading = true;

  void _getNewOrders() async {
    var result = await NetHandler.getNewOrders(context);
    var shops = await NetHandler.getShops(context);
    var provider = Provider.of<DataProvider>(context, listen: false);

    if (result != null) {
      if (const IterableEquality().equals(_newOrders,
                  result.sortedBy((element) => element.status).reversed) ==
              false ||
          _newOrders.isEmpty) {
        setState(() {
          _loading = false;
          _newOrders = result
              .where((element) =>
                  element.status != 'order_done' &&
                  (element.courierId == '' ||
                      element.courierId == provider.courier.courierId))
              .toList()
              .reversed
              .toList();
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
    }

    if (shops != null) {
      if (_shops.isEmpty) {
        setState(() {
          _shops = shops;
        });
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _getNewOrders();
    });
    _getNewOrders();
    super.initState();
  }

  Future<void> _refresh() async {
    _getNewOrders();
  }

  @override
  Widget build(BuildContext context) {
    print(
      _newOrders.length,
    );
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Заказы',
              style: accentFont.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            pinned: true,
            elevation: 0,
            centerTitle: false,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _refresh,
          ),
          if (_newOrders.isNotEmpty && provider.courier.courierStatus == '1')
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return OrderElementStatusCard(
                    order: _newOrders[index],
                    shop: _shops.firstWhere((element) =>
                        element.shopId == _newOrders[index].shopId),
                    onChangeStatus: (Order order) {
                      setState(() {
                        _newOrders[index] = order;
                      });
                    },
                    onChangeProducts: (products) {},
                    onDelete: () {},
                    changeProducts: () {  },
                  );
                },
                childCount: _newOrders.length,
              ),
            ),
          if (_newOrders.isEmpty &&
              provider.courier.courierStatus != '0' &&
              _loading)
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(top: 30),
                    child: const CupertinoActivityIndicator(),
                  ),
                ),
              ),
            ),
          if (provider.courier.courierStatus == '0')
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Чтобы принимать заказы, необходимо включить активную смену.',
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
