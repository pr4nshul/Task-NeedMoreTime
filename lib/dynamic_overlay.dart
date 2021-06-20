import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Countdown(),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                border: Border.all(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            padding: EdgeInsets.all(3),
            width: width * 0.80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "LAP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height*0.025,
                  ),
                ),
                SizedBox(
                  width: width*0.018,
                ),
                Text(
                  "TIME",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height*0.025,
                  ),
                ),
                Text(
                  "ELAPSED",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height*0.025,
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                border: Border.all(color: Theme.of(context).accentColor),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            width: width * 0.80,
            height: height * 0.35,
            margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, height * 0.01),
          ),
          Container(
            width: width * 0.80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                button(context, height, width,Icons.stop, height),
                SizedBox(
                  width: width * 0.02,
                ),
                button(context, height, width,Icons.circle, height*0.60),
              ],
            ),
          )
        ],
      ),
    );
  }

  Center button(BuildContext context, double height, double width, IconData shape, double iconSize) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            border: Border.all(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        height: height * 0.18,
        width: width * 0.39,
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).accentColor,
              elevation: 0,
            ),
            onPressed: (){},
            child: Center(child: Icon(shape,color: Colors.white,size:iconSize*0.18,)),
          ),
        ),
      ),
    );
  }
}

class Countdown extends StatefulWidget {
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          border: Border.all(color: Theme.of(context).accentColor),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      width: width * 0.80,
      margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, height * 0.01),
      height: height * 0.23,
      child: Center(child: Text("uhca")),
    );
  }
}
