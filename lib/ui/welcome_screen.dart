import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payminderapp/ui/login_screen.dart';
import 'package:payminderapp/ui/registration_screen.dart';
import 'package:payminderapp/ui_components/main_background.dart';
import 'package:payminderapp/ui_components/sign_in_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  double heightLengthAnimation,animatedHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(vsync: this,duration: Duration(seconds: 1),);
    _controller.forward();
    _controller.addListener(() {
      setState(() {
        heightLengthAnimation=_controller.value*20;
        animatedHeight=70+heightLengthAnimation;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  child: Container(
                    child: Image.asset('images/Payminder_logo.png'),
                    width: MediaQuery.of(context).size.width / 3,
                  ),
                ),
              ),
              Opacity(
                opacity: _controller.value,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap:(){
                          _controller.animateBack(0.2);
                          Timer(Duration(milliseconds: 300), (){Navigator.pushNamed(context, LoginScreen.id);});

                          Timer(Duration(seconds: 1),(){_controller.forward();});

                      },
                        onDoubleTap: (){
                          _controller.forward();
                        },
                        child: LogInButton(
                          text: 'Log in',
                        ),
                      ),
                      GestureDetector(
                      onTap: (){
                        _controller.animateBack(0.2);
                        Navigator.pushNamed(context, RegistrationScreen.id);

                        Timer(Duration(seconds: 1),(){_controller.forward();});

                      },
                        child: LogInButton(
                          text: 'Sign up',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
