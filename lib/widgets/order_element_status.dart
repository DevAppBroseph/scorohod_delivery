import 'dart:convert';

import 'package:delivery/screens/courier/order_info.dart';
import 'package:delivery/services/objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import '../services/constants.dart';
import '../services/network.dart';
import '../services/orders_bloc.dart';
import '../services/prefs_handler.dart';

class OrderElementStatusCard extends StatelessWidget {
  OrderElementStatusCard(
      {Key? key,
      required this.order,
      required this.shop,
      required this.changeProducts,
      required this.onChangeStatus,
      required this.onChangeProducts,
      required this.onDelete})
      : super(key: key);

  late final Order order;
  final Shop shop;
  final Function(Order order) onChangeStatus;
  final Function(List<OrderElement>) onChangeProducts;
  final Function() onDelete;
  final VoidCallback changeProducts;

  // img.Image? getShopLogo() {
  //   List<int> values = base64Decode(shop.shopLogo).buffer.asUint8List();
  //   var photo = img.decodeImage(values);
  //   return photo;
  // }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OrderBloc>();
    //context.read<OrderBloc>().setOrder(order);
    //print(bloc.state.order!.totalPrice + 'цена');
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, snapshot) {
        return ScaleButton(
          duration: const Duration(milliseconds: 150),
          bound: 0.05,
          onTap: () {
            context.read<OrderBloc>().setOrder(order);
            //order = bloc.state.order!;
            print(bloc.state.order!.totalPrice);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderInfoPage(
                  color: Colors.red,
                  order: bloc.state.order!,
                  shop: shop,
                  onChangeStatus: (order) {
                    onChangeStatus(order);
                  },
                  onChangeProduct: (products) {
                    onChangeProducts(products);
                  },
                  onChangeDelete: () {
                    onDelete;
                  },
                  onPressed: () {
                  }
                ),
              ),
            ).then((value) => changeProducts());
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15),
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              boxShadow: shadow,
              borderRadius: radius,
              color: Colors.white,
            ),
            // color: Colors.white,
            child: Stack(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  // Container(
                  //   width: 80,
                  //   height: 70,
                  //   padding: const EdgeInsets.only(left: 15),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           if (order.products.length > 0)
                  //             Image.network(
                  //               order.products[0].image!,
                  //               width: 30,
                  //               height: 30,
                  //             ),
                  //           if (order.products.length > 1)
                  //             Image.network(
                  //               order.products[1].image!,
                  //               width: 30,
                  //               height: 30,
                  //             ),
                  //         ],
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           if (order.products.length > 2)
                  //             Image.network(
                  //               order.products[2].image!,
                  //               width: 30,
                  //               height: 30,
                  //             ),
                  //           if (order.products.length > 3)
                  //             Image.network(
                  //               order.products[3].image!,
                  //               width: 30,
                  //               height: 30,
                  //             ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10, right: 15),
                    child: Align(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 145,
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 7),
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      borderRadius: radius, color: _getColor()),
                                ),
                                Text(
                                    getStatus(order.status),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: accentFont.copyWith(
                                        fontSize: 14, letterSpacing: 0.2)
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat('dd.MM.yyyy в HH:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(order.date) * 1000),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: Padding(
                    //     padding: EdgeInsets.only(right: 15, top: 15),
                    //     child: ClipRRect(
                    //       borderRadius: const BorderRadius.all(
                    //         Radius.circular(10),
                    //       ),
                    //       child: Image.memory(
                    //         base64Decode(shop.shopLogo),
                    //         fit: BoxFit.cover,
                    //         width: 40,
                    //         height: 40,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, bottom: 15),
                        child: Text(
                          (double.parse(order.totalPrice) + double.parse(shop.shopPriceDelivery)).toStringAsFixed(2) + ' ₽',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                // Container(
                //   width: double.infinity,
                //   height: 1,
                //   color: Colors.grey[200],
                // ),
              ],
            ),
          ),
        );
      }
    );
  }

  Color? _getColor() {
    switch (order.status) {
      case 'new_order':
        return Colors.yellow[300];
      case 'manager_accept':
        return Colors.yellow[500];
      case 'manager_done':
        return Colors.yellow[700];
      case 'courier_accept':
        return Colors.yellow[900];
      case 'order_done':
        return Colors.green[300];
    }
    return Colors.white;
  }

  String getStatus(String status) {
    var newStatus = '';
    switch (status) {
      case 'new_order':
        return 'Новый заказ.';
      case 'manager_accept':
        return 'Заказ принят, собирается.';
      case 'manager_done':
        return 'Заказ собран, ожидает курьера.';
      case 'courier_accept':
        return ' Курьер забрал заказ.';
      case 'order_done':
        return 'Заказ доставлен.';
    }
    return newStatus;
  }
}
