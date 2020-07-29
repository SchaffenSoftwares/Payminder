import 'package:flutter/material.dart';

class MonthsDaysDropDownList extends StatefulWidget {

  final List<String> dropDownList;
  MonthsDaysDropDownList({@required this.dropDownList});


  @override
  _MonthsDaysDropDownListState createState() => _MonthsDaysDropDownListState();
}

class _MonthsDaysDropDownListState extends State<MonthsDaysDropDownList> {

  String defaultValue='1';

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xffA396D1),
      ),
      child: Container(
        width: 70.0,
        child: DropdownButton(
          hint: Text('month',
          style: TextStyle(
            color: Colors.white,
           ),
          ),
          value: defaultValue,
          icon: Icon(Icons.arrow_drop_down),
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
          ),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue){
            setState(() {
              defaultValue=newValue;
            });
          },
          items: widget.dropDownList
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
