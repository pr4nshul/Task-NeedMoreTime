import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:need_more_time/dynamic_overlay.dart';

class StaticTimeOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            counter(context),
            Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(3),
              width: width * 0.80,
              height: height * 0.025,
            ),
            Container(
              color: Theme.of(context).primaryColor,
              width: width * 0.80,
              height: height * 0.35,
              margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, height * 0.01),
            ),
            PlayAndLoad(),
          ],
        ),
      ),
    );
  }
}

Container counter(BuildContext context) {
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
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "00",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: height * 0.15),
          ),
          Text(
            "00",
            style: TextStyle(
                color: Color(0xffefefef),
                fontWeight: FontWeight.bold,
                fontSize: height * 0.08),
          ),
        ],
      ),
    ),
  );
}

class PlayAndLoad extends StatefulWidget {
  @override
  _PlayAndLoadState createState() => _PlayAndLoadState();
}

class _PlayAndLoadState extends State<PlayAndLoad> {
  bool fetch = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.80,
      height: height * 0.18,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).accentColor,
          elevation: 0,
        ),
        child: fetch
            ? Icon(
                Icons.more_horiz_sharp,
                size: height * 0.1,
              )
            : Center(
                child: Icon(
                Icons.play_arrow_rounded,
                size: height * 0.18,
              )),
        onPressed: () async {
          if(mounted){
            setState(() {
              fetch = true;
            });
          }
          int counter = await getTime();
          if (counter != 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DynamicTimeOverlay(initialCounter: counter,),
              ),
            );
          } else {
            setState(() {
              fetch = false;
            });
          }
        },
      ),
    );
  }

  Future<int> getTime() async {
    final url = Uri.parse("https://cricinshots.com/sde/moretimeplease.php");
    try {
      final response = await http.get(url);
      print('Status:${response.statusCode}');
      final body = jsonDecode(response.body);
      print(body['time']);
      return body['time'];
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }
}
