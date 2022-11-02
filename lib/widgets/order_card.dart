import 'package:delivery/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key? key, required this.onTap}) : super(key: key);
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      height: 100,
      width: 200,
      decoration: const BoxDecoration(
        borderRadius: radius,
      ),
      child: Material(
        color: Theme.of(context).backgroundColor,
        borderRadius: radius,
        child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Г. Торжок, Осташковская улица, 26.',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 87, 87, 1),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('6 товаров'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text('20:41'),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
