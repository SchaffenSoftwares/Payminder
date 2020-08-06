import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:payminderapp/storing_data/database_factors.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';
import 'package:payminderapp/storing_data/updateData.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:payminderapp/ui_components/reminder_panel.dart';

class PaidPage extends StatefulWidget {

  static String id='paid_page';

  @override
  _PaidPageState createState() => _PaidPageState();
}

class _PaidPageState extends State<PaidPage> {

  String firstName,lastName,email;
  final databaseReference = Firestore.instance;

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
  email=FirstNameAndLastName.email;
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
                final rechargeDetails=snapshot.data.documents.reversed;
                List<ReminderPanel> reminderPanels=[];
                for(var rechargeDetail in rechargeDetails)
                {
                  final rechargeDay=rechargeDetail[DatabaseFactors.eventDay];
                  final rechargeMonth=rechargeDetail[DatabaseFactors.eventMonth];
                  final rechargeName=rechargeDetail[DatabaseFactors.eventName];
                  final rechargeDone=rechargeDetail[DatabaseFactors.paid];
                  print(rechargeDetail[DatabaseFactors.timeStamp]);
                  DocumentSnapshot _currentSnapshot;
                  print('rechargeDone= $rechargeDone, rechargeName=$rechargeName,rechargeMonth=$rechargeMonth');
                  if(rechargeDone==true)
                  {
                    final reminderPanel=ReminderPanel(
                      days: '',
                      rechargeName: rechargeName,
                      date: '$rechargeDay/$rechargeMonth',
                      paid: rechargeDone,
                      deleteFunction: (){
                        UpdateData updateData= UpdateData(rechargeDetail);
                        updateData.updateMonthAndDay('one-time-payment', rechargeDay, rechargeMonth);
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
    );
  }
}
