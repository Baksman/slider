import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // shortcuts: ,
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primaryColor: Color(0xffff6688),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
          actions: <Widget>[_buildTextButtons("settings", true)],
        ),
        body: Column(
          children: <Widget>[
            new Expanded(
                child: SpringySlider(
              markCount: 12,
              positiveColor: Theme.of(context).primaryColor,
              negativeColor: Theme.of(context).scaffoldBackgroundColor,
            )),
            Container(
              color: Theme.of(context).primaryColor,
              child: Row(
                children: <Widget>[
                  _buildTextButtons("more", false),
                  Spacer(),
                  _buildTextButtons("stats", false),
                ],
              ),
              //  height: ,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextButtons(String title, bool isOnLight) {
    return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        onPressed: () {},
        child: Text(title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isOnLight ? Theme.of(context).primaryColor : Colors.white,
            )));
  }
}

class SpringySlider extends StatefulWidget {
  final int markCount;
  final Color positiveColor;
  final Color negativeColor;

  const SpringySlider(
      {Key key, this.markCount, this.positiveColor, this.negativeColor})
      : super(key: key);

  @override
  _SpringySliderState createState() => _SpringySliderState();
}

class _SpringySliderState extends State<SpringySlider> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SliderMark(
          markCount: widget.markCount,
          color: widget.positiveColor,
          paddingTop: 50,
          paddingBottom: 50,
        ),
        ClipPath(
          clipper: SliderClipper(),
          child: Stack(
            children: <Widget>[
              Container(
                color: widget.positiveColor,
              ),
              SliderMark(
                markCount: widget.markCount,
                color: widget.negativeColor,
                paddingTop: 50,
                paddingBottom: 50,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SliderMark extends StatelessWidget {
  final markCount;
  final Color color;
  final paddingTop;
  final paddingBottom;

  const SliderMark(
      {Key key,
      this.markCount,
      this.color,
      this.paddingTop,
      this.paddingBottom})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SliderMarkPainter(
          paddingTop: paddingTop,
          color: color,
          markThickness: 2,
          markCount: markCount,
          padingRight: 20,
          paddingBottom: paddingBottom),
      child: Container(),
    );
  }
}

class SliderMarkPainter extends CustomPainter {
  final double largeMarkWidth = 30;
  final double smallMarkWidth = 10;
  final int markCount;
  final Color color;
  final padingRight;
  final paddingTop;
  final paddingBottom;
  final markPaint;
  final markThickness;

  SliderMarkPainter(
      {this.markCount,
      this.padingRight,
      this.color,
      this.paddingTop,
      this.paddingBottom,
      this.markThickness})
      : markPaint = Paint()
          ..color = color
          ..strokeWidth = markThickness
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final paintHeight = size.height - paddingTop - paddingBottom;
    final gap = paintHeight / (markCount - 1);

    for (int i = 0; i < markCount; i++) {
      double markWidth = smallMarkWidth;
      if (i == 0 || i == markCount - 1) {
        markWidth = largeMarkWidth;
      } else if (i == 1 || i == markCount - 2) {
        markWidth = lerpDouble(smallMarkWidth, largeMarkWidth, 0.5);
      }
      final markY = i * gap + paddingTop;

      canvas.drawLine(Offset(size.width - padingRight - markWidth, markY),
          Offset(size.width - padingRight, markY), markPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw true;
  }
}

class SliderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path rect = Path();
    rect.addRect(
      Rect.fromLTWH(0, size.height/2, size.width, size.height/2)
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw true;
  }
}
