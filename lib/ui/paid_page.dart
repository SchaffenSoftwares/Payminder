import 'package:flutter/material.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:payminderapp/ui_components/reminder_panel.dart';

class PaidPage extends StatefulWidget {

  static String id='paid_page';

  @override
  _PaidPageState createState() => _PaidPageState();
}

class _PaidPageState extends State<PaidPage> {

  String firstName,lastName;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    settingName();

  }

  void settingName(){
  setState(() {
  firstName=FirstNameAndLastName.firstName;
  lastName=FirstNameAndLastName.lastName;
  });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MainBackground(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
            ),
            WelcomeMesssage('$firstName $lastName'),
            Flexible(
              child: ListView(
                children: <Widget>[
                  ReminderPanel(
                    days: '3',
                    rechargeName: 'DTH Recharge',
                    date: '26-7-2020',
                    paid: true,
                  ),
                  ReminderPanel(
                    days: '3',
                    rechargeName: 'Mobile Recharge',
                    date: '26-7-2020',
                    paid: true,
                  ),
                  ReminderPanel(
                    days: '3',
                    rechargeName: 'Mobile Recharge',
                    date: '26-7-2020',
                    paid: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
