import 'package:flutter/material.dart';
import 'package:payminderapp/ui/add_field_page.dart';
import 'package:payminderapp/ui/home_page.dart';
import 'package:payminderapp/ui/paid_page.dart';
import 'package:payminderapp/ui/settings_page.dart';
import 'package:payminderapp/ui_components/main_background.dart';

class TabBarViews extends StatefulWidget {

  static String id='tabBarViews';
  @override
  _TabBarViewsState createState() => _TabBarViewsState();
}

class _TabBarViewsState extends State<TabBarViews> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.pushNamed(context, AddFieldPage.id);
            },
            backgroundColor: Color(0xffA396D1),
            child: Icon(Icons.add,
              color: Colors.white,),
          ),
          appBar: AppBar(
            leading: Container(),
            backgroundColor: Color(0xffA396D1),
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.home),text: 'Home',),
                Tab(icon: Icon(Icons.done_outline),text: 'paid',),
                Tab(icon: Icon(Icons.settings),text: 'settings',),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              HomePage(),
              PaidPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
