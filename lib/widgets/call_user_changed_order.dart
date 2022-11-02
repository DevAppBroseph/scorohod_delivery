import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/choose_product_to_changed.dart';
import 'package:delivery/widgets/settings_card.dart';
import 'package:delivery/widgets/settings_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';

import '../services/constants.dart';
import '../services/objects.dart';
import 'account_card.dart';

class CallUserChangedOrder extends StatelessWidget {
  const CallUserChangedOrder(
      {Key? key,
      required this.user,
      required this.shop,
      required this.orderElement,
      required this.quantity,
      })
      : super(key: key);

  final User user;
  final Shop shop;
  final OrderElement orderElement;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Позвоните клиенту',
              style: accentFont.copyWith(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            elevation: 0,
            pinned: true,
            centerTitle: false,
          ),
          SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                child: Column(
                  children: [
                    Text(user.userName, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 24),),
                    const SizedBox(width: 20,),
                    Text(user.phone, style: const TextStyle(color: Colors.black38, fontSize: 16),)
                  ],
                ),
              )
          ),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ScaleButton(
                  duration: const Duration(milliseconds: 150),
                  bound: 0.05,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ChooseProductToChanged(
                              shop: shop,
                              orderElement: orderElement,
                              quantity: quantity
                          )
                      ),
                    );
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: const BoxDecoration(
                        borderRadius: radius, color: Colors.red),
                    child: const Center(
                      child: Text(
                        "Продолжить",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}
