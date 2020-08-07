import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';
import 'package:payminderapp/ui/welcome_screen.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {

  static String id = 'settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final databaseReference=Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String firstName,lastName,userEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getemail();
    firstName=FirstNameAndLastName.firstName;
    lastName=FirstNameAndLastName.lastName;
    userEmail=FirstNameAndLastName.email;

  }

  void _logOutUser(){
    _auth.signOut().then((loggedOutUser){
      Navigator.pushNamedAndRemoveUntil(context, WelcomeScreen.id, (route) => false);
    });
  }

//  void getemail() async{
//    var user = await _auth.currentUser();
//    var email = await user.email;
//    setState(() {
//      userEmail=email;
//    });
//  }

  void getData() async{
    var user = await _auth.currentUser();
    var email = await user.email;
    var nameData=await databaseReference.collection('${email}Data').getDocuments();
    for(var name in nameData.documents){
      setState(() {
        firstName=name.data['first_name'];
        lastName=name.data['last_name'];
        userEmail=email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MainBackground(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top:10.0,right: 10.0,left: 10.0),
                      child: Text('$firstName $lastName',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 35.0,
                          letterSpacing: 2.0,
                        ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:1,right: 10.0,left: 10.0),
                      child: Text(userEmail,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Container(
                      height: 5.0,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.all(Radius.circular(5.0),),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 10.0),
                          child: GestureDetector(
                            child: Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text('Contact Us',
                                  style:TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                  ),),
                              ),
                            ),
                            onTap: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title:  Text('Contact Us:'),
                                    content:  Text('''Email: askSchaffen@gmail.com
                                                      Website: schaffensofts.com
                                    '''),
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
                            },
                          ),
                        ),
                        Container(
                          height: 3.0,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.all(Radius.circular(3.0),),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:8.0,horizontal: 10.0),
                          child: GestureDetector(
                            onTap: _logOutUser,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text('Log Out',
                                style:TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              ),

              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
