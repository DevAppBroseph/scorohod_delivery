import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import '../services/constants.dart';
import '../services/network.dart';
import '../services/objects.dart';
import '../services/orders_bloc.dart';
import '../services/prefs_handler.dart';

class ProductCard extends StatefulWidget {
  ProductCard({
    Key? key,
    required this.width,
    required this.item,
    required this.color,
    required this.orderElement,
    required this.quantity,
  }) : super(key: key);

  final double width;
  final Product item;
  final Color color;
  OrderElement orderElement;
  final int quantity;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isTake = false;
  bool wasAdded = false;
  int quantity = 0;
  StreamController<bool> _streamController = StreamController<bool>();
  StreamController<int> _countStreamController = StreamController<int>();

  void getVisibility() {

  }

  bool getId() {
    // for(int i = 0; i < bloc.products.length; i++) {
    //   if(bloc.products[i].id == id) {
    //     return true;
    //     break;
    //   }
    // }
    return false;
  }

  int getQuantity() {
    // for(int i = 0; i < bloc.products.length; i++) {
    //   if(bloc.products[i].id == id) {
    //     print(bloc.products[i].quantity.toString() + ' функция');
    //     return bloc.products[i].quantity;
    //     break;
    //   }
    // }
    return 0;
  }

  void _changeCountProducts(DataProvider provider, BuildContext context) async {
    final bloc = context.read<OrderBloc>();
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

  @override
  Widget build(BuildContext context) {
    //var bloc = BlocProvider.of<OrdersBloc>(context);
    var provider = Provider.of<DataProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: ScaleButton(
        duration: const Duration(milliseconds: 150),
        bound: 0.05,
        onTap: () {
          final bloc = context.read<OrderBloc>();
          Order order = Order(
              orderId: bloc.state.order!.orderId,
              date: bloc.state.order!.date,
              status: bloc.state.order!.status,
              products: [],
              totalPrice: bloc.state.order!.totalPrice,
              clientId: bloc.state.order!.clientId,
              address: bloc.state.order!.address,
              fcmToken: bloc.state.order!.fcmToken,
              userLatLng: bloc.state.order!.userLatLng,
              discount: bloc.state.order!.discount,
              receiptId: bloc.state.order!.receiptId,
              courierId: bloc.state.order!.courierId,
              shopId: bloc.state.order!.shopId,
              city: bloc.state.order!.city
          );
          double price = double.parse(order.totalPrice);
          for(int i = 0; i < bloc.state.order!.products.length; i++) {
            if (bloc.state.order!.products[i].id == bloc.state.id){
              order.products.add(OrderElement(
                  id: int.parse(widget.item.nomenclatureId),
                  quantity: widget.quantity,
                  price: widget.item.price*bloc.state.order!.products[i].quantity,
                  basePrice: widget.item.price,
                  weight: widget.item.measure,
                  image: widget.item.image,
                  name: widget.item.name
              ));
              price -= bloc.state.order!.products[i].basePrice * bloc.state.order!.products[i].quantity;
              print(bloc.state.order!.products[i].basePrice * bloc.state.order!.products[i].quantity);
              price += widget.item.price*bloc.state.order!.products[i].quantity;
              print(widget.item.price*bloc.state.order!.products[i].quantity);
            } else {
              order.products.add(bloc.state.order!.products[i]);
            }
          }
          order.totalPrice = price.toString();
          bloc.setOrder(order);
          print(bloc.state.order!.totalPrice);
          _changeCountProducts(provider, context);
          Navigator.of(context)..pop()..pop()..pop();
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 48) / 2,
          height: widget.width + 85,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: shadow,
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Image.network(
                    widget.item.image,
                    width: widget.width / 2,
                    height: widget.width / 2,
                  )),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name.length < 51
                            ? widget.item.name
                            : widget.item.name.substring(0, 50) + '...',
                        maxLines: 4,
                        // widget.item.name,
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.item.measure,
                        style: GoogleFonts.rubik(
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[100]),
                        height: 35,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                widget.item.price
                                    .toInt()
                                    .toString() +
                                    ' ₽',
                                style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              )
                            ),
                            StreamBuilder<bool>(
                                stream: _streamController.stream,
                                initialData: false,
                                builder: (context, snapshot) {
                                  if (snapshot.data!) {
                                    return Container(
                                      alignment: Alignment.centerRight,
                                      color: widget.color,
                                      height: 10,
                                      width: 10,
                                    );
                                  } else {
                                    return Container();
                                  }
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
