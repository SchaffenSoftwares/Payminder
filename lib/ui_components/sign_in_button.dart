import 'package:flutter/material.dart';

class LogInButton extends StatelessWidget {

  final String text;

  const LogInButton({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:12.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width/2,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(1.0,4.0),
            end: Alignment(-1.0,-4.0),
            colors: [
              Color(0xff7470a3),
              Color(0xff8a85c2),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),

        ),
        child: Center(
          child: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),),
        ),
      ),
    );
  }
}
