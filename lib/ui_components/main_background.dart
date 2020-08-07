import 'package:flutter/material.dart';

class MainBackground extends StatefulWidget {
  final Widget child;

  const MainBackground({this.child});

  @override
  _MainBackgroundState createState() => _MainBackgroundState();
}

class _MainBackgroundState extends State<MainBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/payminder_background.png'),
            fit: BoxFit.cover,
          )
      ),
      child: widget.child,
    );
  }
}
