import 'package:flutter/material.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payminderapp/ui_components/reminder_panel.dart';

class HomePage extends StatefulWidget {

  static String id = 'homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String firstName,lastName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      settingName();
    });

  }
  void settingName(){
    firstName=FirstNameAndLastName.firstName;
    lastName=FirstNameAndLastName.lastName;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: MainBackground(
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
                      paid: false,
                    ),
                    ReminderPanel(
                      days: '3',
                      rechargeName: 'Mobile Recharge',
                      date: '26-7-2020',
                      paid: false,
                    ),
                    ReminderPanel(
                      days: '3',
                      rechargeName: 'Mobile Recharge',
                      date: '26-7-2020',
                      paid: false,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}





