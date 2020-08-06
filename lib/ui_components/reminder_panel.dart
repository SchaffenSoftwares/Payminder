import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReminderPanel extends StatelessWidget {

  final String days,rechargeName;
  final String date;
  final bool paid;
  final Function onTap,deleteFunction;

  const ReminderPanel({this.days='',this.rechargeName='N/A', this.date='N/A', this.paid=false, this.onTap, this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.0,right: 15.0,left: 15.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(1.0,4.0),
              end: Alignment(-1.0,-4.0),
              colors: [
                Color(0xff7470a3),
                Color(0xff8a85c2),
              ]
          ),
          boxShadow: [
            BoxShadow(
              color:Color(0xff6e699a),
              offset: Offset(20.0, 20.0),
              blurRadius: 40.0,
              spreadRadius: 10.0,
            ),
            BoxShadow(
              color:Color(0xff48fd0),
              offset: Offset(-20.0, -20.0),
              blurRadius: 40.0,
              spreadRadius: 10.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(rechargeName,
                    style:TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10.0,),
                  GestureDetector(
                    child: Icon(Icons.delete,
                    color: Colors.white,),
                    onTap: deleteFunction,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Text('Days left:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),),
                    Text(' $days',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Text('Payment date:',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),),
                    Text(' $date',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Text('Status:',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                      ),),
                    Text(paid?' PAID':' UNPAID',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: paid?Color(0xff006400):Colors.red,
                      ),),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                  child: Container(
                    height: 40.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      color: paid? Colors.grey: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    child: Center(child: Text('Paid',
                      style: TextStyle(
                          color:Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),),),
                  ),
                  onTap: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeMesssage extends StatelessWidget {

  final String userName;
  const WelcomeMesssage(this.userName);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:10.0,horizontal: 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text('Hello, $userName',
          style: GoogleFonts.courgette(
            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
      ),

    );
  }
}