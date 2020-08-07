import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';

class UpdateData{

  UpdateData(this._currentDocument);

  String email=FirstNameAndLastName.email;
  final dbRefernce = Firestore.instance;
  DocumentSnapshot _currentDocument;

  void updatePaidStatus() async{
    Timer(Duration(days: 3),() async{
      await dbRefernce
          .collection('${email}Data')
          .document(_currentDocument.documentID)
          .updateData({"bool":false});
    });
    await dbRefernce
        .collection('${email}Data')
        .document(_currentDocument.documentID)
        .updateData({"bool":true});
  }

  void updateMonthAndDay(String paymentType,int currentDay,int currentMonth) async{
    if(paymentType.compareTo('monthly')==0){
      if(currentMonth<12)
        {
          await dbRefernce
              .collection('${email}Data')
              .document(_currentDocument.documentID)
              .updateData({"event_Month":currentMonth+1});
        }
      else if(currentMonth==12){
        await dbRefernce
            .collection('${email}Data')
            .document(_currentDocument.documentID)
            .updateData({"event_Month":1});
      }
    }
    else if(paymentType.compareTo('weekly')==0){
      if(currentMonth!=4 && currentMonth!=6 && currentMonth!=9 && currentMonth!=11 && currentMonth!=2){
        int nextDay= (currentDay+7)%31;
        if(nextDay<8){
          await dbRefernce
              .collection('${email}Data')
              .document(_currentDocument.documentID)
              .updateData({"event_Month":currentMonth+1,
              "event_day":nextDay,
              });
        }
        else{
          await dbRefernce
              .collection('${email}Data')
              .document(_currentDocument.documentID)
              .updateData({"event_day":nextDay});
        }
      }
      else if(currentMonth==2){
        int nextDay= (currentDay+7)%28;
        if(nextDay<8){
          await dbRefernce
              .collection('${email}Data')
              .document(_currentDocument.documentID)
              .updateData({"event_Month":currentMonth+1,
            "event_day":nextDay,
          });
        }
        else{
          await dbRefernce
              .collection('${email}Data')
              .document(_currentDocument.documentID)
              .updateData({"event_day":nextDay});
        }
      }
      else{
        int nextDay= (currentDay+7)%30;
        if(nextDay<8){
          await dbRefernce
              .collection('${email}Data')
              .document(_currentDocument.documentID)
              .updateData({"event_Month":currentMonth+1,
            "event_day":nextDay,
          });
        }
        else{
          await dbRefernce
              .collection('${email}Data')
              .document(_currentDocument.documentID)
              .updateData({"event_day":nextDay});
        }
      }
    }
    else if(paymentType.compareTo('one-time-payment')==0){
      await dbRefernce
          .collection('${email}Data')
          .document(_currentDocument.documentID)
          .delete();
    }

  }

}