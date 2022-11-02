import 'dart:async';
import 'dart:convert';

import 'package:delivery/services/constants.dart';
import 'package:delivery/services/network.dart';
import 'package:delivery/services/objects.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/order_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:delivery/widgets/order_element_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> _orders = [];
  Shop? _shop;
  bool _loading = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getOrders();
    _getShop();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _getOrders();
    });
    super.didChangeDependencies();
  }

  void _getShop() async {
    var shopId = Provider.of<DataProvider>(context).manager.shopId;

    var result = await NetHandler.getCurrentShop(context, shopId);

    if (result != null) {
      // List<int> values = base64Decode(result.shopLogo).buffer.asUint8List();
      // var photo = img.decodeImage(values);
      setState(() {
        _shop = result;
      });
    }
  }

  void _getOrders() async {
    setState(() {
      _loading = true;
    });
    var shopId =
        Provider.of<DataProvider>(context, listen: false).manager.shopId;
    print(shopId);
    var result = await NetHandler.getManagerOrders(context, shopId);
    print(result);
    if (result != null) {
      setState(() {
        _orders = result
            .where((element) =>
                element.status != 'order_done' &&
                element.status != 'manager_done' &&
                element.status != 'courier_accept')
            .toList()
            .reversed
            .toList();
        _loading = false;
      });
      print(_orders.first.status);
    }
  }

  Future<void> _refresh() async {
    _getOrders();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  'Заказы',
                  style: accentFont.copyWith(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3),
                ),
                actions: [
                  if (_shop != null)
                    if (_shop!.shopLogo != null)
                      Container(
                        height: 50,
                        width: 60,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.memory(
                            base64Decode(_shop!.shopLogo),
                            fit: BoxFit.cover,
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                ],
                pinned: true,
                centerTitle: false,
                elevation: 0,
              ),
              CupertinoSliverRefreshControl(
                onRefresh: _refresh,
              ),
              if (_orders.isNotEmpty &&
                  !_loading &&
                  _shop != null &&
                  provider.manager.managerStatus == '1')
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => OrderElementStatusCard(
                      order: _orders[index],
                      shop: _shop!,
                      onChangeStatus: (order) {
                        setState(() {
                          _orders[index] = order;
                        });
                      },
                      onChangeProducts: (products) {
                        setState(() {
                          _orders[index].products = products;
                        });
                      },
                      onDelete: () {
                        setState(() {
                          _orders.removeAt(index);
                        });
                      },
                      changeProducts: _getOrders,
                    ),
                    childCount: _orders.length,
                  ),
                ),
              if (_orders.isEmpty &&
                  !_loading &&
                  provider.manager.managerStatus == '1')
                SliverToBoxAdapter(
                  child: Container(
                    height: 600,
                    alignment: Alignment.center,
                    child: Text(
                      'Заказов пока нет.',
                      style: accentFont.copyWith(fontSize: 16),
                    ),
                  ),
                ),
              if (provider.manager.managerStatus == '0')
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
          if (_orders.isEmpty &&
              _loading &&
              provider.manager.managerStatus == '1')
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(top: 30),
                child: const CupertinoActivityIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
