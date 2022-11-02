import 'package:delivery/services/objects.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/call_user_changed_order.dart';
import 'package:delivery/widgets/custom_dialog.dart';
import 'package:delivery/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../services/constants.dart';
import '../services/orders_bloc.dart';

class OrderElementCard extends StatelessWidget {
  const OrderElementCard(
      {Key? key,
      required this.user,
      required this.shop,
      required this.orderElement,
      required this.index,
      required this.quantity,
      required this.onChanged,
      required this.onDelete})
      : super(key: key);

  final OrderElement orderElement;
  final Function() onDelete;
  final Function(OrderElement) onChanged;
  final User user;
  final Shop shop;
  final int quantity;
  final int index;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    if (provider.hasManager) {
      return BlocBuilder<OrderBloc, OrderState>(
        builder: (context, snapshot) {
          final bloc = context.read<OrderBloc>();
          return Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  flex: 1,
                  onPressed: (context) {
                    var dialog = CustomAlertDialog(
                      title: "Введите количество.",
                      message: orderElement.quantity.toString(),
                      onPostivePressed: (value) {
                        Order order = Order(
                            orderId: bloc.state.order!.orderId,
                            date: bloc.state.order!.date,
                            status: bloc.state.order!.status,
                            products: bloc.state.order!.products,
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
                          if (bloc.state.order!.products[i].id == orderElement.id){
                            price -= bloc.state.order!.products[i].basePrice*bloc.state.order!.products[i].quantity;
                            print(bloc.state.order!.products[i].price);
                            price += bloc.state.order!.products[i].basePrice*double.parse(value);
                            print(bloc.state.order!.products[i].basePrice*double.parse(value));
                          }
                        }
                        order.products[index].quantity = int.parse(value);
                        order.totalPrice = price.toString();
                        bloc.setOrder(order);
                        onChanged(orderElement);
                      },
                      isText: false,
                      positiveBtnText: 'Сохранить',
                      negativeBtnText: 'Отмена',
                      onNegativePressed: () {},
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog,
                    );
                  },
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.mode_edit_outlined,
                  label: 'Редактировать',
                ),
                SlidableAction(
                  // flex: 1,
                  onPressed: (context) {
                    var dialog = CustomAlertDialog(
                      title: "Изменение заказа.",
                      message: orderElement.quantity.toString(),
                      onPostivePressed: (value) {
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
                        for(int i = 0; i < bloc.state.order!.products.length; i++) {
                          if (bloc.state.order!.products[i].id != orderElement.id){
                            order.products.add(bloc.state.order!.products[i]);
                          }
                        }
                        bloc.setOrder(order);
                      },
                      positiveBtnText: 'Удалить',
                      negativeBtnText: 'Отменить',
                      onNegativePressed: () {},
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog,
                    );
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Удалить',
                ),
                SlidableAction(
                  // flex: 1,
                  onPressed: (context) {
                    context.read<OrderBloc>().setId(orderElement.id);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => CallUserChangedOrder(
                              user: user,
                              shop: shop,
                              orderElement: orderElement,
                              quantity: quantity,
                          )
                      ),
                    );
                  },
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  icon: Icons.ad_units,
                  label: 'Редактировать',
                ),
              ],
            ),
            child: _card(context),
          );
        }
      );
    } else {
      return _card(context);
    }
  }

  showAlertDialog(BuildContext context) {
    var controller = TextEditingController();
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text(
        "Отмена",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Сохранить",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        print(controller.text);
        controller.dispose();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Введите количество.",
        style: accentFont.copyWith(fontSize: 18),
      ),
      content: TextFieldWidget(
        color: Colors.grey[200]!,
        controller: controller,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Container _card(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      width: double.infinity,
      height: 110,
      color: Colors.white,
      // decoration: BoxDecoration(
      //   boxShadow: shadow,
      //   borderRadius: radius,
      //   color: Colors.white,
      // ),
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, snapshot) {
          return Stack(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Image.network(
                    snapshot.order!.products[index].image!,
                    width: 70,
                    height: 70,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
                  child: Align(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 145,
                          child: Text(
                            snapshot.order!.products[index].name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.order!.products[index].weight,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  child: Text(
                    '${snapshot.order!.products[index].quantity} шт, ${snapshot.order!.products[index].basePrice} ₽',
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[200],
              )
            ],
          );
        }
      ),
    );
  }
}
