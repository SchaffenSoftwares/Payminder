import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payminderapp/storing_data/database_factors.dart';
import 'package:payminderapp/ui/tab_bar_view.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payminderapp/ui_components/sign_in_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const kLabelStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 15.0,
);

class AddFieldPage extends StatefulWidget {
  static String id = 'add_field_page';
  @override
  _AddFieldPageState createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  String selectedDay = '1';
  String defaultPaymentMethod = 'monthly';
  final _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;
  String eventName, eventDay, eventMonth, eventPeriod;
  bool autoValidate = false;
  final formKey = GlobalKey<FormState>();
  String defaultMonth='1',defaultDay='1';
  int timeStamp(int eventDay,int eventMonth){
    String day=eventDay.toString(),
        month=eventMonth.toString();
    var now =DateTime.now();
    //int currentDay=now.day;
    String timeStamp='';
    int currentMonth=now.day;
    int currentyear=now.year;
    if(eventDay<10){
      day='0'+day;
    }
    if(eventMonth<10){
      month='0'+month;
    }
    if(eventMonth>currentMonth){
    timeStamp='$currentyear$month$day';
    }else{
      timeStamp='${currentyear+1}$month$day';
    }
    return int.parse(timeStamp);
  }
  void setData({String eventName,int eventDay,int eventMonth,String eventPeriod}) async{
    var user = await _auth.currentUser();
    var email = user.email;
    if(eventName!=null && eventMonth!=null && eventDay!=null && eventPeriod!=null)
      {
        var currentTimeStamp=timeStamp(eventDay, eventMonth);
        print("data is being sent");
    await databaseReference.collection('${email}Data').add({
      DatabaseFactors.eventName:eventName,
      DatabaseFactors.eventDay:eventDay,
      DatabaseFactors.eventMonth:eventMonth,
      DatabaseFactors.paymentPeriod:eventPeriod,
      DatabaseFactors.paid:false,
      DatabaseFactors.timeStamp:currentTimeStamp,
    })
        .then((value){
          Navigator.of(context).pop();
    }).catchError((err) {
      if(err.code!=null){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Some error occured"),
            content: new Text(
                "Please check your connection or try fter some time."),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    })
        ;
      }
  }

    List<String> paymentPeriodList = [
      'weekly',
      'monthly',
      'yearly',
      'one-time-payment'
    ];
    List<String> listOfDays() {
      List<String> days = [];
      for (int i = 1; i <= 31; i++) {
        days.add(i.toString());
      }
      return days;
    }

    List<String> listOfMonths() {
      List<String> days = [];
      for (int i = 1; i <= 12; i++) {
        days.add(i.toString());
      }
      return days;
    }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffA396D1),
          leading: Container(
            width: 0,
          ),
          title: Text(
            'Adding new Field',
            textAlign: TextAlign.center,
            style: GoogleFonts.patuaOne(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        body: Form(
          key: formKey,
          child: MainBackground(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Event Name : ',
                            style: kLabelStyle,
                          ),
                        ),
                      ),
                      TextFormField(
                        autovalidate: autoValidate,
                        validator: (text) {
                          if (text.isEmpty) {
                            return 'This field is mandetory';
                          } else
                            return null;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.yellow,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'This should be unique',
                        ),
                        onChanged: (enteredText) {
                          setState(() {
                            eventName=enteredText;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Enter date:",
                        style: kLabelStyle,
                      ),
                      // Days and month DropDown Buttons
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                        Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Color(0xffA396D1),
                        ),
                        child: Container(


                          width: 70.0,
                          child: DropdownButton(
                            hint: Text('day',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            value: defaultDay,
                            icon: Icon(Icons.arrow_drop_down),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (newValue){
                              setState(() {
                                defaultDay=newValue;
                              });
                              print('$newValue newValue, $defaultDay defaultDay');
                            },
                            items: listOfDays()
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                                Text('Day'),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                            Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: Color(0xffA396D1),
                            ),
                  child: Container(
                    width: 72.0,
                    child: DropdownButton(
                      hint: Text('month',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      value: defaultMonth,
                      icon: Icon(Icons.arrow_drop_down),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (newValue){
                        setState(() {
                          defaultMonth=newValue;
                        });
                      },
                      items: listOfMonths()
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                                Text('Month'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //Payment period drop down button
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Payment period:',
                              style: kLabelStyle,
                            ),
                            Theme(
                              data: Theme.of(context)
                                  .copyWith(canvasColor: Color(0xffA396D1)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: DropdownButton(
                                  hint: Text(
                                    'period',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: defaultPaymentMethod,
                                  icon: Icon(Icons.arrow_drop_down),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      defaultPaymentMethod = newValue;
                                    });
                                  },
                                  items: paymentPeriodList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          print('$eventName is name, $defaultMonth month, $defaultDay day, $defaultPaymentMethod period');
                          setState(() {

                            autoValidate = true;
                          });

                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            if(eventName!=null && defaultMonth!=null && defaultDay!=null && defaultPaymentMethod!=null)
                              {
                                print('Data ready to send');
                            setData(
                              eventName: eventName,
                              eventMonth: int.parse(defaultMonth),
                              eventDay: int.parse(defaultDay),
                              eventPeriod: defaultPaymentMethod,
                            );
                             Navigator.pop(context);
                              }

                          }
                        },
                        child: LogInButton(
                          text: 'Done',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
