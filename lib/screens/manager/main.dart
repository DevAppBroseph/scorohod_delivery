import 'package:delivery/screens/manager/fragments/finance.dart';
import 'package:delivery/screens/manager/fragments/orders.dart';
import 'package:delivery/screens/manager/fragments/settings.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final List<BottomNavigationBarItem> _tabBar = [
    const BottomNavigationBarItem(
      icon: Icon(LineIcons.car),
      label: "Заказы",
    ),
    // const BottomNavigationBarItem(
    //   icon: Icon(LineIcons.coins),
    //   label: "Финансы",
    // ),
    const BottomNavigationBarItem(
      icon: Icon(LineIcons.user),
      label: "Аккаунт",
    ),
  ];

  late TabController _tabController;
  int _currentTabIndex = 0;

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
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
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
        children: const [
          OrdersPage(),
          // FinancePage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
