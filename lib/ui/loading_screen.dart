import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payminderapp/storing_data/first_name_and_last_name.dart';
import 'package:payminderapp/ui/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:flutter/material.dart';
import 'package:payminderapp/ui/tab_bar_view.dart';

class LoadingScreen extends StatefulWidget {

  static String id='loading_screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {

  AnimationController _loadindAnimationController;
  Animation _loadingAnimation;
  double animatedHeight;
  double logoSize;
  final _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationControl();
    _auth.currentUser()
        .then((currentUser) async{
      if(currentUser==null)
        {
          Timer(Duration(seconds: 2), ()=>navigatingUser(false));
        }
      else{
        await getData();
        Timer(Duration(seconds: 2), ()=>navigatingUser(true));

      }
    })
    .catchError((err){
      return AlertDialog(
        title: new Text("Email Already Used"),
        content: new Text("Please enter another email."),
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
    })
    ;

  }

  void getData() async{
    var user = await _auth.currentUser();
    var email = await user.email;
    var nameData=await databaseReference.collection('${email}Data').getDocuments();
    for(var name in nameData.documents){
      if(name.data['first_name']!=null && name.data['last_name']!=null)
        {
          FirstNameAndLastName.firstName=name.data['first_name'];
          FirstNameAndLastName.lastName=name.data['last_name'];
        }
    }
  }

  void navigatingUser(bool loggedIn){
      /*Timer(Duration(seconds: 3), (){
      });*/
        Navigator.pushReplacementNamed(context,loggedIn? TabBarViews.id:WelcomeScreen.id);
  }

  void animationControl(){
    _loadindAnimationController = AnimationController(duration: Duration(seconds: 3),
      vsync: this,
    );

    //_loadingAnimation=CurvedAnimation(parent: _loadindAnimationController, curve: Curves.easeIn);
    _loadindAnimationController.forward();

    _loadindAnimationController.addListener(() {
      setState(() {
        _loadindAnimationController.value;
        animatedHeight=_loadindAnimationController.value<0.3?_loadindAnimationController.value*150:animatedHeight;
        logoSize=MediaQuery.of(context).size.width.toDouble()/3.0+animatedHeight;
      });

    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _loadindAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MainBackground(
          //Main Background can be found in ui_components.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100.0,
              ),

              AnimatedOpacity(
                opacity: _loadindAnimationController.value>0.2?1.0:0.0,
                duration: Duration(milliseconds: 500),
                child: Hero(
                tag:'logo',
                  child: Container(
                    child: Image.asset('images/Payminder_logo.png'),
                    width: logoSize,
                    height: logoSize,
                  ),
                ),
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text('Loading, please stand by...',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
                    width: MediaQuery.of(context).size.width*_loadindAnimationController.value,
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: _loadindAnimationController.value<0.5?Color(0xffFDFD01):Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
