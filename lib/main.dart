import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:need_more_time/dynamic_overlay.dart';
import 'package:need_more_time/static_overlay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Need More Time',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: Color(0xff38cd97),
        accentColor: Color(0xff2da67a),
        textTheme:  GoogleFonts.publicSansTextTheme(
            Theme.of(context).textTheme,
        ),
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: StaticTimeOverlay(),
      ),
    );
  }
}
