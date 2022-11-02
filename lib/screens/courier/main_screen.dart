import 'package:delivery/screens/bottom_nav/account_screen.dart';
import 'package:delivery/screens/bottom_nav/finance_screen.dart';
import 'package:delivery/screens/bottom_nav/orders_screen.dart';
import 'package:delivery/services/location.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

final List<BottomNavigationBarItem> _tabBar = [
  const BottomNavigationBarItem(
    icon: Icon(LineIcons.car),
    label: "Заказы",
  ),
  const BottomNavigationBarItem(
    icon: Icon(LineIcons.coins),
    label: "Финансы",
  ),
  const BottomNavigationBarItem(
    icon: Icon(LineIcons.user),
    label: "Аккаунт",
  ),
];

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  var _first = true;
  late Location _location;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabBar.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _location.stopLocation();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);

    if (_first) {
      _location = Location(context, provider.courier);
      _location.startLocation();
      _first = false;
    }

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).backgroundColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Color.fromRGBO(255, 87, 87, 1),
        onTap: (index) {
          setState(() {
            _tabController.index = index;
            _currentTabIndex = index;
          });
        },
        currentIndex: _currentTabIndex,
        items: _tabBar,
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [OrdersScreen(), FinanceScreen(), AccountScreen()],
      ),
    );
  }
}
