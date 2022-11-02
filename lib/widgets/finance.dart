import 'package:delivery/services/constants.dart';
import 'package:flutter/material.dart';

enum FinanceType { order, finance }

class FinanceValues {
  final int dayValue;
  final int weekValue;
  final int monthValue;

  FinanceValues({
    required this.dayValue,
    required this.weekValue,
    required this.monthValue,
  });
}

class FinanceWidget extends StatelessWidget {
  final FinanceValues values;
  final FinanceType type;
  const FinanceWidget({
    Key? key,
    required this.values,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          color: Colors.white,
          boxShadow: shadow,
        ),
        margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'За день',
                style: accentFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              trailing: Text(
                type == FinanceType.order
                    ? convertOrders(values.dayValue.toString())
                    : '${values.dayValue} ₽',
                style: accentFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'За неделю',
                style: accentFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              trailing: Text(
                type == FinanceType.order
                    ? convertOrders(values.weekValue.toString())
                    : '${values.weekValue} ₽',
                style: accentFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'За месяц',
                style: accentFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              trailing: Text(
                type == FinanceType.order
                    ? convertOrders(values.monthValue.toString())
                    : '${values.monthValue} ₽',
                style: accentFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
