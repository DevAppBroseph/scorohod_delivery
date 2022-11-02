import 'package:delivery/services/constants.dart';
import 'package:delivery/services/network.dart';
import 'package:delivery/services/prefs_handler.dart';
import 'package:delivery/widgets/account_card.dart';
import 'package:delivery/widgets/settings_card.dart';
import 'package:delivery/widgets/settings_switch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _changeManagerStatus(bool status, DataProvider provider) async {
    var result = await NetHandler.setManagerStatus(
      context,
      provider.manager.managerId,
      status ? 1 : 0,
    );

    if (result) {
      print(true);
      provider.setManagerStatus(status ? '1' : '0');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    print(provider.manager.managerStatus);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Аккаунт',
              style: accentFont.copyWith(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3),
            ),
            pinned: true,
            centerTitle: false,
            elevation: 0,
          ),
          SliverToBoxAdapter(
            child: AccountCard(
              email: provider.manager.managerEmail,
              name: provider.manager.managerName,
              phone: provider.manager.managerPhone,
              onTap: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: SettingsSwitch(
              icon: Icons.work,
              text: 'Активная смена',
              switchValue: provider.manager.managerStatus == '1' ? true : false,
              onChanged: (value) {
                _changeManagerStatus(value, provider);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SettingsCard(
              icon: Icons.logout_outlined,
              text: 'Выйти из аккаунта',
              onTap: () {
                provider.signOutManager();
              },
            ),
          )
        ],
      ),
    );
  }
}
