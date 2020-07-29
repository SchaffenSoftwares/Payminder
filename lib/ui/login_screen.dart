import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';
import 'package:payminderapp/ui/loading_screen.dart';
import 'package:payminderapp/ui/registration_screen.dart';
import 'package:payminderapp/ui/tab_bar_view.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {

  static String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _databaseReference = Firestore.instance;
  String email,password;
  final formKey = GlobalKey<FormState>();
  bool autoValidate= false;
  void _signIn({String email,String password}) async{
    //logging in method
    await _auth.signInWithEmailAndPassword(email: email, password: password)
    .then((value) async{
      await getData(email);
       //navigating to home screen with tab bar
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (BuildContext context) => TabBarViews()),
          ModalRoute.withName(TabBarViews.id));
    })
    .catchError((err){
      //showing dialog box if found error in entries
      if(err.code=='ERROR_INVALID_EMAIL'){
        showDialog(
          context: context,
          builder: (BuildContext context) {

            // return object of type Dialog
            return AlertDialog(
              title: new Text("Invalid Email"),
              content: new Text("Please make sure email is right"),
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
      else if(err.code=='ERROR_WRONG_PASSWORD'){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Wrong password"),
              content: new Text("Password entered is incorrect"),
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
      else if(err.code=='ERROR_USER_NOT_FOUND'){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: Text("User not found"),
                content: Text("User not found"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Sign Up"),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
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

  void getData(String email) async{
    var nameData = await _databaseReference.collection('${email}Data').getDocuments();
    for(var name in nameData.documents)
      if(name.data['first_name']!=null && name.data['last_name']!=null)
      {
        FirstNameAndLastName.firstName=name.data['first_name'];
        FirstNameAndLastName.lastName=name.data['last_name'];
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: Scaffold(
          body: MainBackground(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                ),
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/Payminder_logo.png'),
                    width: MediaQuery.of(context).size.width/3,
                    height: MediaQuery.of(context).size.width/3,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                      child: Text('Enter Email:',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                      ),),
                    ),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                     child: TextFormField(
                       validator: (enteredText){
                           if(enteredText.isEmpty){
                             return 'This field is mandetory';
                           }else
                             return null;
                       },
                       autovalidate: autoValidate,
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
                hintText: 'Enter Email',
              ),
              onChanged: (enteredText){
                setState(() {
                email=enteredText;
                });
              },
            ),
          ),

                    SizedBox(height: 10.0),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                      child: Text('Enter Password:',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          //fontWeight: FontWeight.bold,
                        ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        autovalidate: autoValidate,
                        validator: (enteredText){
                          if(enteredText.isEmpty)
                            return 'This field is mandetory';
                          else return null;
                        },
                        obscureText: true,
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
                          hintText: 'Enter password',
                        ),
                        onChanged: (enteredText){
                          setState(() {
                          password=enteredText;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      autoValidate=true;
                    });
                    if (formKey.currentState.validate()) {

                      formKey.currentState.save();
                      _signIn(email: email,password: password);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                      color: Color(0xffFDFD01),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Center(child: Text(
                        'Login',
                      style: TextStyle(
                        color: Color(0xffA396D1),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                     ),
                    ),
                  ),
                ),

                Flexible(
                  child: SizedBox(
                    height: 5.0,
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
