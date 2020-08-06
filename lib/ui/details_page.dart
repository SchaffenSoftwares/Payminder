import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payminderapp/ui/tab_bar_view.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';

class DetailsPage extends StatefulWidget {

  static String id='details_page';

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> with SingleTickerProviderStateMixin{


    AnimationController _animationController;
    double animatedHeight;
    bool autoValidate=false;
    final databaseReference=Firestore.instance;
    final _auth=FirebaseAuth.instance;
    String firstName,lastName;

    void getDetails(String firstName,String lastName) async{
      var user=await _auth.currentUser();
      var email=await user.email;
      databaseReference.collection('${email}Data')
      .document('${email}PersonalData')
      .setData({
        'first_name':firstName,
        'last_name':lastName,
      })
      .then((value){
        getData(email);

        _animationController.animateBack(0.1,duration: Duration(milliseconds: 500));
        Timer(Duration(milliseconds: 500), (){Navigator.pushNamed(context, TabBarViews.id);});
      })
      ;
      print('dataCreated');
    }

    void getData(String email)async {
      FirstNameAndLastName.email=email;
      var nameData=await databaseReference.collection('${email}Data').getDocuments();
      for(var name in nameData.documents)
      {
        if(name.data['first_name']!=null && name.data['last_name']!=null)
        {
          FirstNameAndLastName.firstName=name.data['first_name'];
          FirstNameAndLastName.lastName=name.data['last_name'];
        }
      }
    }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      controlAnimation();
    }

    void controlAnimation(){
      _animationController=AnimationController(vsync: this,duration: Duration(seconds: 1));
      _animationController.forward();
      _animationController.addListener(() {
        setState(() {
        });
      });
    }

    @override
    void dispose() {
      // TODO: implement dispose
      _animationController.dispose();
      super.dispose();
    }


    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Form(
          child: Scaffold(
            body: MainBackground(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Flexible(
                    child: Hero(
                      tag: 'logo',
                      child: Opacity(
                        opacity: _animationController.value,
                        child: Container(
                          child: Image.asset('images/Payminder_logo.png'),
                          width: MediaQuery.of(context).size.width/3,
                          height: MediaQuery.of(context).size.width/3,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: _animationController.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                          child: Text('First Name:',
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
                              }else return null;
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
                              hintText: 'first name',
                            ),
                            onChanged: (enteredText){
                              setState(() {
                                firstName=enteredText;
                              });
                            },
                          ),
                        ),

                        SizedBox(height: 10.0),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                          child: Text('Last Name',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              //fontWeight: FontWeight.bold,
                            ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextFormField(
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
                              hintText: 'last name',
                            ),
                            onChanged: (enteredText){
                              setState(() {
                                if(enteredText.isEmpty){
                                  lastName='';
                                }else
                                  lastName=enteredText;
                              });
                            },
                          ),
                        ),

                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      getDetails(firstName,lastName);
                    },
                    onDoubleTap: (){
                      _animationController.forward();
                    },
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width/2,
                      decoration: BoxDecoration(
                        color: Color(0xffFDFD01),
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: Center(child: Text(
                        'Sign Up',
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
