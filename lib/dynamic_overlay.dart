import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:need_more_time/static_overlay.dart';
import 'package:http/http.dart' as http;

class DynamicTimeOverlay extends StatefulWidget {
  final int initialCounter; //contains the initial time

  const DynamicTimeOverlay({@required this.initialCounter});

  @override
  _DynamicTimeOverlayState createState() => _DynamicTimeOverlayState();
}

class _DynamicTimeOverlayState extends State<DynamicTimeOverlay> {
  int seconds;
  int milliseconds;
  int current;
  int initial;
  Timer _timer;
  List<int> _elapsed = []; //to store the lap time
  List<int> _total = []; //to store the total elapsed time
  Color greyish = Color(0xffefefef);

  void startTimer() {
    //timer function
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (current > 0) {
            current -= 1;
            seconds = current ~/ 1000;
            milliseconds = (current % 1000) ~/ 10;
          } else {
            _timer.cancel();
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    current = widget.initialCounter;
    initial = widget.initialCounter;
    seconds = widget.initialCounter ~/ 1000;
    milliseconds = (widget.initialCounter % 1000) ~/ 10;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    startTimer();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            countDown(height, width), //counter widget
            Container(
              //to display lap time & elapsed titles
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border.all(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              padding: EdgeInsets.all(3),
              width: width * 0.80,
              child: lte(height, width, "LAP", "TIME", "ELAPSED", Colors.white),
            ),
            Container(
              // to display the time laps
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  border: Border.all(
                      color: Theme.of(context).accentColor, width: 0),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              width: width * 0.80,
              height: height * 0.35,
              margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, height * 0.01),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      lte(
                          height,
                          width,
                          (index + 1).toString(),
                          convertTime(_elapsed[index]),
                          convertTime(_total[index]),
                          greyish),
                      Divider(
                        color: greyish,
                        thickness: height * 0.002,
                      ),
                    ],
                  );
                },
                itemCount: _elapsed.length,
              ),
            ),
            Container(
              width: width * 0.80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  button(context, height, width, Icons.stop, height, () async {
                    //on pressed function for stop button
                    setState(() {
                      if (initial > 0) {
                        _timer.cancel();
                      }
                    });
                    await postTime();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StaticTimeOverlay(),
                      ),
                    );
                  }),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  button(context, height, width, Icons.circle, height * 0.60,
                      () {
                    //on pressed function for lap button
                    if (mounted) {
                      setState(() {
                        _total.add(initial - current);
                        if (_elapsed.length == 0) {
                          _elapsed.add(initial - current);
                        } else {
                          _elapsed.add(_total[_total.length - 1] -
                              _total[_total.length - 2]);
                        }
                        //print(_total);
                        //print(_elapsed);
                      });
                    }
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container countDown(double height, double width) {
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
              seconds.toString().padLeft(2, '0'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.15),
            ),
            Text(
              milliseconds.toString().padLeft(2, '0'),
              style: TextStyle(
                  color: greyish,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.08),
            ),
          ],
        ),
      ),
    );
  }

  Row lte(double height, double width, String lap, String time, String elapsed,
      Color color) {
    //l: lap, t:time , e:elapsed
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              lap,
              style: TextStyle(
                  color: color,
                  fontSize: height * 0.025,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            width: width * 0.018,
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              time,
              style: TextStyle(
                color: color,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              elapsed,
              style: TextStyle(
                color: color,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }

  Center button(BuildContext context, double height, double width,
      IconData shape, double iconSize, Function func) {
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
            onPressed: func,
            child: Center(
                child: Icon(
              shape,
              color: Colors.white,
              size: iconSize * 0.18,
            )),
          ),
        ),
      ),
    );
  }

  String convertTime(int time) {
    // a function to convert the int to 00:00 format
    int secondsStr = time ~/ 1000;
    int millisecondsStr = (time % 1000) ~/ 10;
    String str = secondsStr.toString().padLeft(2, '0');
    str = str + ":";
    str = str + millisecondsStr.toString().padLeft(2, '0');
    return str;
  }

  Future<void> postTime() async {
    // async function for the post query
    final url = Uri.parse("https://cricinshots.com/sde/takeyourtime.php");
    List<Map<String, int>> laps = [];
    for (int i = 0; i < _elapsed.length; i++) {
      laps.add({"id": (i + 1), "time": _elapsed[i], "elapsed": _total[i]});
    }
    try {
      final response = await http.post(url,
          body: jsonEncode({
            "time": initial,
            "laps": laps,
            "remaining": current,
            "repo": "https://github.com/pr4nshul/Task-NeedMoreTime"
          }));
      print('Status:${response.statusCode}');
      print(response.body);
    } catch (e) {
      print(e.toString());
    }
  }
}
