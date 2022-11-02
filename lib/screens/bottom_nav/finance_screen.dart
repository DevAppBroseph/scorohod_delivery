import 'package:delivery/services/constants.dart';
import 'package:delivery/services/network.dart';
import 'package:delivery/services/objects.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/app_bar.dart';
import 'package:delivery/widgets/finance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({Key? key}) : super(key: key);

  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  List<Order> _orders = [];
  Courier? _courier;
  bool _loading = false;
  FinanceValues? _orderValues;
  FinanceValues _financeValues =
      FinanceValues(dayValue: 0, weekValue: 0, monthValue: 0);
  String _countrySum = '';
  String _outsideSum = '';
  String _settlementDate = "";

  @override
  void didChangeDependencies() {
    _getOrders();
    super.didChangeDependencies();
  }

  int _getCourierCountOrders(DateTime isBefore) {
    var result = _orders
        .where(
          (element) =>
              element.status == 'order_done' &&
              isBefore.isBefore(
                DateTime.fromMillisecondsSinceEpoch(
                  int.parse(element.date) * 1000,
                ),
              ),
        )
        .length;
    print(_orders.length);
    return result;
  }

  void _getInfo() async {
    var result = await NetHandler().getDeliveryInfo(context);

    if (result != null) {
      setState(() {
        _countrySum = result.countrySum;
        _outsideSum = result.outsideSum;
        _settlementDate = result.settlementDate;
        _setPay();
        _setValues(_orders);
      });
    }
    print(_countrySum);
  }

  int _getPay(DateTime isBefore) {
    var countryLength = (_orders
            .where(
              (element) =>
                  element.status == 'order_done' &&
                  element.city == '0' &&
                  isBefore.isBefore(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.date) * 1000,
                    ),
                  ),
            )
            .length *
        int.parse(_countrySum));
    print('THIS INSIDE DAY ${isBefore.day} ' + countryLength.toString());
    var outsideLength = 0;
    _orders
        .where(
      (element) =>
          element.status == 'order_done' &&
          element.city != '0' &&
          isBefore.isBefore(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(element.date) * 1000,
            ),
          ),
    )
        .forEach((element) {
      outsideLength += int.parse(element.city) * int.parse(_outsideSum);
      // print('CITY IS ' + int.tryParse(element.city).toString());
    });
    print('THIS OUTSIDE ' + outsideLength.toString());
    return ((countryLength + outsideLength) -
            (countryLength + outsideLength) / 100 * int.parse(_settlementDate))
        .toInt();
  }

  void _getOrders() async {
    setState(() => _loading = true);

    var courierId =
        Provider.of<DataProvider>(context, listen: false).courier.courierId;
    var result = await NetHandler.getCourierOrders(context, courierId);

    if (result != null) {
      setState(() {
        _orders = result;
        _loading = false;
      });
      _getInfo();
    }
  }

  void _setValues(List<Order> result) {
    var now = DateTime.now();
    _orderValues = FinanceValues(
      dayValue:
          _getCourierCountOrders(DateTime(now.year, now.month, now.day - 1)),
      weekValue:
          _getCourierCountOrders(DateTime(now.year, now.month, now.day - 8)),
      monthValue: _getCourierCountOrders(DateTime(now.year, now.month - 1, 1)),
    );
  }

  void _setPay() {
    var now = DateTime.now();

    setState(() {
      _financeValues = FinanceValues(
        dayValue: _getPay(
          DateTime(now.year, now.month, now.day - 1),
        ),
        weekValue: _getPay(
          DateTime(now.year, now.month, now.day - 8),
        ),
        monthValue: _getPay(
          DateTime(now.year, now.month, 1),
        ),
      );
    });
  }

  Future<void> _refresh() async {
    _getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Выполненные заказы',
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
          CupertinoSliverRefreshControl(
            onRefresh: _refresh,
          ),
          if (_orderValues != null)
            FinanceWidget(
              values: _orderValues!,
              type: FinanceType.order,
            ),
          if (_orderValues == null)
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
          if (_orderValues != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 40),
                child: Text(
                  'Финансы',
                  style: accentFont.copyWith(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          if (_orderValues != null)
            FinanceWidget(
              values: _financeValues,
              type: FinanceType.finance,
            ),
        ],
      ),
    );
  }
}
