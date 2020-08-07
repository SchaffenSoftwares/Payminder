import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payminderapp/ui/details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payminderapp/ui_components/main_background.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double animatedHeight;
  String email, password, passwordConfirm;
  bool saveAttempted = false;
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _createUser({@required String email, @required String password}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password)
    .then((authResult){
      _animationController.animateBack(0.1,
          duration: Duration(milliseconds: 500));
      Timer(Duration(milliseconds: 500), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return DetailsPage();}));
      });
    })
    .catchError((err){
      print(err.code);
      if(err.code=='ERROR_INVALID_EMAIL'){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("In-valid Email"),
              content: new Text("Please enter valid email."),
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
      else if(err.code=='ERROR_EMAIL_ALREADY_IN_USE'){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
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
          },
        );

      }
      else if(err.code=='ERROR_TOO_MANY_REQUESTS'){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("Too many requests"),
              content: new Text("Please try after some time."),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
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
        key: formKey,
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
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.width / 3,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          'Enter Email:',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //email textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          autovalidate: saveAttempted,
                          validator: (email) {
                            if (email.isEmpty)
                              return 'This field is mandetory';
                            else
                              return null;
                          },
/*          autovalidate: widget.saveAttempted,
              validator:widget.validator,*/
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
                          onChanged: (enteredText) {
                            setState(() {
                              email = enteredText;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 10.0),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          'Enter Password:',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //password textfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          autovalidate: saveAttempted,
                          validator: (password) {
                            if (password.isEmpty) {
                              return 'This field is mandetoy.';
                            } else if (password.length < 8) {
                              return 'Please enter atleast 8 characters!';
                            } else
                              return null;
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
                          onChanged: (enteredText) {
                            setState(() {
                              password = enteredText;
                            });
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Text(
                          'Re-enter Password:',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //Confirm password textField
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          validator: (passwordConfirm) {
                            if (passwordConfirm != password) {
                              return 'The passwords did not match.';
                            } else
                              return null;
                          },
/*          autovalidate: widget.saveAttempted,
              validator:widget.validator,*/
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
                            hintText: 'Re-enter password',
                          ),
                          onChanged: (enteredText) {
                            setState(() {
                              passwordConfirm = enteredText;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      saveAttempted = true;
                    });
                    if (formKey.currentState.validate()) {

                      formKey.currentState.save();
                      _createUser(
                        email: email,
                        password: password,
                      );
                    }
                  },
                  onDoubleTap: () {
                    _animationController.forward();
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: Color(0xffFDFD01),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Center(
                      child: Text(
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
