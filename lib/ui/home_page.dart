import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:payminderapp/storing_data/database_factors.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';
import 'package:payminderapp/storing_data/updateData.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:payminderapp/ui_components/reminder_panel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payminderapp/main.dart';

class HomePage extends StatefulWidget {

  static String id = 'homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String firstName,lastName,email;
  final databaseReference=Firestore.instance;
  String supposedDate;
  int currentDay,currentMonth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingDate();
    setState(() {
      settingName();
    });

  }

  void scheduleAlarm(String rechargeName,int daysLeft) async {
    var scheduledNotificationDateTime =
    DateTime.now().add(Duration(seconds: 10,days: daysLeft));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Reminder',
        'Time for $rechargeName payment.',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  void settingName(){
    firstName=FirstNameAndLastName.firstName;
    lastName=FirstNameAndLastName.lastName;
    email=FirstNameAndLastName.email;
  }

  void gettingDate(){
    var date= DateTime.now();
    currentDay=date.day;
    currentMonth=date.month;
  }

  updateTimeStamp()
  {

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

                    StreamBuilder<QuerySnapshot>(

                      stream: databaseReference.collection('${email}Data')
                      .orderBy(DatabaseFactors.timeStamp)
                          .snapshots(),
                      // ignore: missing_return
                      builder: (context,snapshot){
                        if(!snapshot.hasData){
                          print('in strembuildeer');
                          return Center(child:Text('Loading'),);
                        }
                        final rechargeDetails=snapshot.data.documents;
                        List<ReminderPanel> reminderPanels=[];
                        for(var rechargeDetail in rechargeDetails)
                          {
                            final rechargeDay=rechargeDetail[DatabaseFactors.eventDay];
                            final rechargeMonth=rechargeDetail[DatabaseFactors.eventMonth];
                            final rechargeName=rechargeDetail[DatabaseFactors.eventName];
                            final rechargeDone=rechargeDetail[DatabaseFactors.paid];
                            final rechargeType=rechargeDetail[DatabaseFactors.paymentPeriod];
                            //final date=currentDate(rechargeDay, rechargeMonth);
                            if(rechargeDone==false)
                              {
                                //Changing rechargeDay and RechargeMonth to date format
                                  String payDay=rechargeDay.toString();
                                  String payMonth = rechargeMonth.toString();
                                  if(rechargeDay<10)
                                  {
                                    payDay='0'+payDay;
                                  }
                                  if(rechargeMonth<10)
                                  {
                                    payMonth='0'+payMonth;
                                  }
                                  String currentDate1='$payDay / $payMonth';

                                  //Finding days left
                                  String daysLeft='';
                                  if(currentMonth==rechargeMonth)
                                    {
                                      daysLeft=(rechargeDay-currentDay).toString();
                                      if(currentDay==rechargeDay)
                                        if(currentDay<=rechargeDay)
                                          {if(rechargeDay-currentDay<4)
                                      scheduleAlarm(rechargeName,(rechargeDay-currentDay));
                                          else{
                                            scheduleAlarm(rechargeName,(rechargeDay-currentDay)-3);

                                          }
                                          }
                                    }
                                  if(currentMonth<rechargeMonth)
                                    {
                                      daysLeft='${(rechargeDay-currentDay)} days and ${rechargeMonth-currentMonth} months';

                                    }
                                  if(currentMonth>rechargeMonth)
                                    {
                                      daysLeft='${(rechargeDay-currentDay)} days and ${12-(currentMonth-rechargeMonth)} months';
                                    }

                                final reminderPanel=ReminderPanel(
                                  days: daysLeft,
                                  rechargeName: rechargeName,
                                  date: currentDate1,
                                  paid: rechargeDone,
                                  deleteFunction: (){
                                    UpdateData updateData= UpdateData(rechargeDetail);
                                    updateData.updateMonthAndDay('one-time-payment', rechargeDay, rechargeMonth);
                                  },
                                  onTap: (){
                                    UpdateData updateData= UpdateData(rechargeDetail);
                                    updateData.updatePaidStatus();
                                    updateData.updateMonthAndDay(rechargeType, rechargeDay, rechargeMonth);
                                  },
                                );
                                reminderPanels.add(reminderPanel);
                              }
                          }
                        return Expanded(
                          child: ListView(
                            children: reminderPanels,

                          ),
                        );
                      },
                    ),

            ],
          ),
        ),
      ),
    );
  }
}





