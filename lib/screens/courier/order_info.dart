import 'package:delivery/services/constants.dart';
import 'package:delivery/services/network.dart';
import 'package:delivery/services/objects.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/my_flushbar.dart';
import 'package:delivery/widgets/order_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/orders_bloc.dart';

class OrderInfoPage extends StatefulWidget {
  const OrderInfoPage({
    Key? key,
    required this.color,
    required this.order,
    required this.shop,
    required this.onChangeProduct,
    required this.onChangeStatus,
    required this.onChangeDelete,
    required this.onPressed,
  }) : super(key: key);

  final Color color;
  final Order order;
  final Shop shop;
  final VoidCallback onPressed;
  final Function(List<OrderElement>) onChangeProduct;
  final Function(Order) onChangeStatus;
  final Function() onChangeDelete;

  @override
  State<OrderInfoPage> createState() => _OrderInfoPageState();
}

class OrderStatus {
  String statusName;
  Color statusColor;
  OrderStatus({
    required this.statusName,
    required this.statusColor,
  });
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  String networkStatus = '';
  List<Widget> _status = [];
  User? _user;

  @override
  void initState() {
    _setStatusColor();
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    var result = await NetHandler.getOrderUser(context, widget.order.clientId);

    if (result != null) {
      setState(() {
        _user = result;
      });
    }
  }

  void _setStatusColor() {
    var provider = Provider.of<DataProvider>(context, listen: false);
    print('ok');
    setState(() {
      _status = [];
      _status = [
        _statusCard(
          OrderStatus(
            statusName: 'Новый заказ.',
            statusColor: _getCurrentCount() >= 1 ? Colors.green : Colors.grey,
          ),
        ),
        _statusCard(
          OrderStatus(
            statusName: 'Заказ принят, собирается.',
            statusColor: _getCurrentCount() >= 2 ? Colors.green : Colors.grey,
          ),
        ),
        _statusCard(
          OrderStatus(
            statusName: 'Заказ собран, ожидает курьера.',
            statusColor: _getCurrentCount() >= 3 ? Colors.green : Colors.grey,
          ),
        ),
        if (provider.hasCourier)
          _statusCard(
            OrderStatus(
              statusName: 'Курьер забрал заказ.',
              statusColor: _getCurrentCount() >= 4 ? Colors.green : Colors.grey,
            ),
          ),
        if (provider.hasCourier)
          _statusCard(
            OrderStatus(
              statusName: 'Заказ доставлен.',
              statusColor: _getCurrentCount() >= 5 ? Colors.green : Colors.grey,
            ),
            last: true,
          )
      ];
    });
  }

  void _changeCountProducts(DataProvider provider, BuildContext context) async {
    final bloc = context.read<OrderBloc>();
    var totalPrice = bloc.state.order!.totalPrice;
    var result = await NetHandler.changeProduct(
      context,
      provider.manager.managerId,
      bloc.state.order!.orderId,
      bloc.state.order!.fcmToken,
      bloc.state.order!.products,
      bloc.state.order!.totalPrice.toString(),
    );
    if (result != null) {}
  }

  void _setOrderStatus(DataProvider provider) async {
    var id = provider.hasCourier
        ? provider.courier.courierId
        : provider.manager.managerId;
    var result = await NetHandler.setOrderStatus(
      context,
      id,
      widget.order.orderId,
      provider.hasCourier ? true : false,
      _setStatus(),
      _getUserStatus(_setStatus()),
      widget.order.fcmToken,
    );

    if (result != null) {
      setState(() {
        widget.onChangeStatus(result
            .firstWhere((element) => element.orderId == widget.order.orderId));
        networkStatus = result
            .firstWhere((element) => element.orderId == widget.order.orderId)
            .status;
      });
      _setStatusColor();
      MyFlushbar.showFlushbar(context, 'Cтатус заказа', _getFlushbarStatus());
    }
  }

  void _openMap(BuildContext context, double latitude, double longitude) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await launch(
        "maps://?q=$latitude,$longitude",
      );
    } else {
      await launch(
        "geo:$latitude,$longitude",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    context.read<OrderBloc>().setOrder(widget.order);
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            // elevation: 0,
            foregroundColor: widget.color,
            // expandedHeight: 210,
            title: Text(
              'Заказ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.color,
              ),
            ),
          ),
          if (_user != null)
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, snapshot) {
                return SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => OrderElementCard(
                          orderElement: snapshot.order!.products[index],
                          quantity: snapshot.order!.products[index].quantity,
                          index: index,
                          user: _user!,
                          shop: widget.shop,
                          onChanged: (orderElement) {
                            _changeCountProducts(provider, context);
                          },
                          onDelete: () {
                            _changeCountProducts(provider, context);
                          },
                        ),
                    childCount: widget.order.products.length),
          );
              }
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Column(
                  children: _status,
                ),
                const SizedBox(height: 20),
                if (provider.hasCourier && _courierStatus())
                  ScaleButton(
                    duration: const Duration(milliseconds: 150),
                    bound: 0.05,
                    onTap: () {
                      _setOrderStatus(provider);
                    },
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: const BoxDecoration(
                          borderRadius: radius, color: Colors.red),
                      child: Center(
                        child: Text(
                          _getStatus(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                if (provider.hasManager && _managerStatus())
                  ScaleButton(
                    duration: const Duration(milliseconds: 150),
                    bound: 0.05,
                    onTap: () {
                      _setOrderStatus(provider);
                    },
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: const BoxDecoration(
                          borderRadius: radius, color: Colors.red),
                      child: Center(
                        child: Text(
                          _getStatus(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onPressed();
                  },
                  child: Text(
                    'Итого',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, snapshot) {
                    return Text(
                      (double.parse(snapshot.order!.totalPrice) + double.parse(widget.shop.shopPriceDelivery)).toStringAsFixed(2) +
                          ' ₽',
                      style: TextStyle(
                          color: Colors.grey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    );
                  }
                )
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                if (provider.hasCourier)
                  Container(
                    height: 80,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        boxShadow: shadow,
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Material(
                      color: Colors.white,
                      borderRadius: radius,
                      child: InkWell(
                        borderRadius: radius,
                        onTap: () => _openMap(
                          context,
                          widget.order.userLatLng.latitude,
                          widget.order.userLatLng.longitude,
                        ),
                        child: _bottomCard(
                          'Адрес доставки',
                          widget.order.address,
                          address: true,
                        ),
                      ),
                    ),
                  ),
                _bottomCard('Номер заказа', widget.order.orderId, height: 70),
                _bottomCard(
                  'Дата заказа',
                  DateFormat('dd.MM.yyyy в HH:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(widget.order.date) * 1000),
                  ),
                ),
                // _bottomCard(
                //   'Магазин',
                //   widget.shop.shopName,
                // ),
                if (provider.hasCourier)
                  _bottomCard(
                    'Адрес магазина',
                    widget.shop.shopAddress,
                  ),
                if (provider.hasCourier)
                  _bottomCard(
                    'Название магазина',
                    widget.shop.shopName,
                  ),
                if (provider.hasCourier)
                  _bottomCard(
                    'Информация о доставке',
                    _user != null
                        ? 'Подъезд ${_user!.entrance}, Этаж ${_user!.floor}, Квартира ${_user!.room}.'
                        : '',
                  ),
                _bottomCard(
                  'Телефон клиента',
                  _user != null ? _user!.phone : '',
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 50),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(OrderStatus status, {bool? last}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 1),
          decoration: BoxDecoration(
              boxShadow: shadow,
              // borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 15),
              Container(
                height: 17,
                width: 17,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: status.statusColor,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                status.statusName,
                style: accentFont.copyWith(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // const SizedBox(height: 5),
        // if (last == null) _point(),
        // const SizedBox(height: 5),
      ],
    );
  }

  Widget _point() {
    return Column(
      children: List.generate(
        3,
        (i) => Padding(
            padding:
                const EdgeInsets.only(left: 5, right: 0, top: 1, bottom: 1),
            child: Container(
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            )),
      ),
    );
  }

  Widget _bottomCard(String title, String subtitle,
      {double? height, bool? address}) {
    if (address == null) {
      return SizedBox(
        height: height ?? 80,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                fontSize: 15),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          ),
        ),
      );
    } else {
      return ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
              fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            subtitle,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      );
    }
  }

  bool _courierStatus() {
    switch (networkStatus != '' ? networkStatus : widget.order.status) {
      case 'new_order':
        return false;
      case 'manager_accept':
        return false;
      case 'manager_done':
        return true;
      case 'courier_accept':
        return true;
      case 'order_done':
        return false;
    }
    return false;
  }

  bool _managerStatus() {
    switch (networkStatus != '' ? networkStatus : widget.order.status) {
      case 'new_order':
        return true;
      case 'manager_accept':
        return true;
      case 'manager_done':
        return false;
      case 'order_done':
        return false;
    }
    return false;
  }

  int _getCurrentCount() {
    switch (networkStatus != '' ? networkStatus : widget.order.status) {
      case 'new_order':
        return 1;
      case 'manager_accept':
        return 2;
      case 'manager_done':
        return 3;
      case 'courier_accept':
        return 4;
      case 'order_done':
        return 5;
    }
    return 1;
  }

  String _getStatus() {
    switch (networkStatus != '' ? networkStatus : widget.order.status) {
      case 'new_order':
        return 'Собираю заказ.';
      case 'manager_accept':
        return 'Собрал заказ.';
      case 'manager_done':
        return 'Забрал заказ.';
      case 'courier_accept':
        return 'Доставил заказ.';
      case 'order_done':
        return 'Доставил.';
    }
    return '';
  }

  String _getUserStatus(String status) {
    switch (status) {
      case 'new_order':
        return 'Новый заказ.';
      case 'manager_accept':
        return 'Заказ принят, собирается';
      case 'manager_done':
        return 'Заказ собран, ожидает курьера.';
      case 'courier_accept':
        return 'Курьер забрал заказ.';
      case 'order_done':
        return 'Заказ доставлен.';
    }
    return '';
  }

  String _getFlushbarStatus() {
    switch (networkStatus != '' ? networkStatus : widget.order.status) {
      case 'new_order':
        return 'Заказ принят.';
      case 'manager_accept':
        return 'Набор продуктов.';
      case 'manager_done':
        return 'Продукты собраны.';
      case 'courier_accept':
        return 'Доставка.';
      case 'order_done':
        return 'Заказ выполнен.';
    }
    return '';
  }

  String _setStatus() {
    switch (networkStatus != '' ? networkStatus : widget.order.status) {
      case 'new_order':
        return 'manager_accept';
      case 'manager_accept':
        return 'manager_done';
      case 'manager_done':
        return 'courier_accept';
      case 'courier_accept':
        return 'order_done';
    }
    return '';
  }
}
