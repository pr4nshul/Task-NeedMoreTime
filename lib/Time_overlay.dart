import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TimeOverlay extends StatefulWidget {
  @override
  _TimeOverlayState createState() => _TimeOverlayState();
}

class _TimeOverlayState extends State<TimeOverlay> {
  int seconds = 0;
  int milliseconds = 0;
  int current;
  int initial;
  bool fetch = false;
  bool change = false;
  Timer _timer;
  List<int> _elapsed = []; //to store the lap time
  List<int> _total = []; //to store the total elapsed time
  Color greyish = Color(0xffefefef);

  void startTimer() {
    //timer function
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (mounted) {
        setState(() {
          if (current > 0) {
            current -= 10;
            seconds = current ~/ 1000;
            milliseconds = (current % 1000) ~/ 10;
          } else {
            current = 0;
            timer.cancel();
            stopTimer();
          }
        });
      }
    });
  }

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
            countDown(height, width), //counter widget
            Container(
              //to display lap time & elapsed titles
              decoration: BoxDecoration(
                  color: change? Theme.of(context).accentColor: Theme.of(context).primaryColor,
                  border: Border.all(color: change?Theme.of(context).accentColor:Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              padding: EdgeInsets.all(3),
              width: width * 0.80,
              child: change
                  ? lte(height, width, "LAP", "TIME", "ELAPSED", Colors.white)
                  : null,
            ),
            Container(
              // to display the time laps
              decoration: BoxDecoration(
                  color: change?Theme.of(context).accentColor:Theme.of(context).primaryColor,
                  border: Border.all(
                      color: change?Theme.of(context).accentColor:Theme.of(context).primaryColor, width: 0),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              width: width * 0.80,
              height: height * 0.35,
              margin: EdgeInsets.fromLTRB(0, height * 0.01, 0, height * 0.01),
              child: change
                  ? ListView.builder(
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
                    )
                  : null,
            ),
            change
                ? Container(
                    width: width * 0.80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        button(context, height, width, Icons.stop, height,
                            () async {
                          //on pressed function for stop button
                          setState(() {
                            if (current > 0) {
                              _timer.cancel();
                            }
                          });
                          stopTimer();
                        }),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        button(
                            context, height, width, Icons.circle, height * 0.60,
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
                : playAndLoad(width,height),
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
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              seconds.toString().padLeft(2, '0'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.16),
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
                  fontSize: height * 0.022,
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
                fontSize: height * 0.022,
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
                fontSize: height * 0.022,
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

  Container playAndLoad(double width,double height){
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
        child: fetch //checking whether the query has been called or not
            ? Icon(
                Icons.more_horiz_sharp, //if yes then loading three dots
                size: height * 0.1,
              )
            : Center(
                child: Icon(
                //else the play button
                Icons.play_arrow_rounded,
                size: height * 0.18,
              )),
        onPressed: () async {
          //created a function onPressed here itself as it is relatively a small application
          if (mounted) {
            print("entered");
            setState(() {
              fetch = true;

            });
          }
          final counter = await getTime();
          if (counter != 0) {
            setState(() {
              current = counter;
              initial = counter;
              seconds = counter ~/ 1000;
              milliseconds = (counter % 1000) ~/ 10;
              startTimer();
              change = true;
            });
          } else {
            setState(() {
              fetch = false;
            });
          }
        },
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

  void stopTimer() {
    postTime().then((_) {
      setState(() {
        change=false;
        seconds=0;
        milliseconds=0;
        _elapsed.clear();
        _total.clear();
        fetch=false;

      });
    });
  }
  Future<int> getTime() async {
    //function to get query
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
  Future<void> postTime() async {
    // async function for the post query
    final url = Uri.parse("https://cricinshots.com/sde/takeyourtime.php");
    List<Map<String, int>> laps = [];
    for (int i = 0; i < _elapsed.length; i++) {
      laps.add({"id": (i + 1), "time": _elapsed[i], "elapsed": _total[i]});
    }
    final json = jsonEncode({
      "time": initial,
      "laps": laps,
      "remaining": current,
      "repo": "https://github.com/pr4nshul/Task-NeedMoreTime"
    });
    print(json);
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
