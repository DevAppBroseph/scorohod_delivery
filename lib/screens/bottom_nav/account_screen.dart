import 'package:delivery/screens/change_pass_screen.dart';
import 'package:delivery/services/constants.dart';
import 'package:delivery/services/network.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/account_card.dart';
import 'package:delivery/widgets/app_bar.dart';
import 'package:delivery/services/router.dart';
import 'package:delivery/widgets/settings_card.dart';
import 'package:delivery/widgets/settings_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void _changeCourierStatus(bool status, DataProvider provider) async {
    var result = await NetHandler.setCourierStatus(
      context,
      provider.courier.courierId,
      status ? 1 : 0,
    );

    if (result) {
      print(true);
      provider.setCourierStatus(status ? '1' : '0');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Аккаунт',
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
            child: AccountCard(
              email: provider.courier.courierEmail,
              name: provider.courier.courierName,
              phone: provider.courier.courierPhone,
              onTap: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: SettingsSwitch(
              icon: Icons.man_rounded,
              text: 'Активная смена',
              switchValue: provider.courier.courierStatus == '1' ? true : false,
              onChanged: (value) {
                _changeCourierStatus(value, provider);
              },
            ),
          ),
          // SliverToBoxAdapter(
          //   child: SettingsCard(
          //     icon: Icons.vpn_key_sharp,
          //     text: 'Изменить пароль',
          //     onTap: () {
          //       const Navigator().nextPage(context, const ChangePassScreen());
          //     },
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: SettingsCard(
                icon: Icons.logout,
                text: 'Выйти',
                onTap: () => provider.signOutCourier(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
