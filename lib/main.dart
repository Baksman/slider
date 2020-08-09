import 'dart:ui';

import 'package:flutter/material.dart';

//stopped at 30 min
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
  final double markCount;
  final Color positiveColor;
  final Color negativeColor;

  const SpringySlider(
      {Key key, this.markCount, this.positiveColor, this.negativeColor})
      : super(key: key);

  @override
  _SpringySliderState createState() => _SpringySliderState();
}

class _SpringySliderState extends State<SpringySlider> {
  final double paddingTop = 50;
  final double paddingBottom = 50;
  final sliderPercent = .85;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SliderMark(
          markCount: widget.markCount,
          color: widget.positiveColor,
          paddingTop: paddingTop,
          paddingBottom: paddingBottom,
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
        ),
        Padding(
          padding: EdgeInsets.only(
            top: paddingTop,
            bottom: paddingBottom,
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final height = constraints.maxHeight;

              final sliderY = height * (1 - sliderPercent);
              final pointsYouNeed = (100 * (1 - sliderPercent)).round();
              final pointsYouHave = 100 - pointsYouNeed; 

              return Stack(
                children: <Widget>[
                  Positioned(
                      left: 30,
                      top: sliderY - 50,
                      child: FractionalTranslation(
                          translation: Offset(0, -1),
                          child: Points(
                            points: pointsYouNeed,
                            color: Theme.of(context).primaryColor,
                            isAboveSlider: true,
                            isPointYouNeed: true,
                          ))),
                  Positioned(
                      left: 30,
                      top: sliderY + 50,
                      child: new Points(
                        points: pointsYouHave,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        isAboveSlider: false,
                        isPointYouNeed: false,
                      ))
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class SliderMark extends StatelessWidget {
  final double markCount;
  final Color color;
  final double paddingTop;
  final double paddingBottom;

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
          paddingRight: 20,
          paddingBottom: paddingBottom),
      child: Container(),
    );
  }
}

class SliderMarkPainter extends CustomPainter {
  final double largeMarkWidth = 30;
  final double smallMarkWidth = 10;
  final double markCount;
  final Color color;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final Paint markPaint;
  final double markThickness;

  SliderMarkPainter(
      {this.markCount,
      this.paddingRight,
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

      canvas.drawLine(Offset(size.width - paddingRight - markWidth, markY),
          Offset(size.width - paddingRight, markY), markPaint);
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
        Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2));
    return rect;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Points extends StatelessWidget {
  final int points;
  final bool isAboveSlider;
  final bool isPointYouNeed;
  final Color color;

  const Points(
      {Key key,
      this.points,
      this.isAboveSlider = true,
      this.isPointYouNeed = true,
      this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final percent = points / 100;
    final pointTextSize = 30 + (70 * percent);
    return Row(
      crossAxisAlignment: isAboveSlider ? CrossAxisAlignment.end  : CrossAxisAlignment.start,
      children: <Widget>[
        FractionalTranslation(
           translation: Offset(
             0,
             isAboveSlider ? 0.18 : -0.18
           ),
                  child: Text(
            "$points",
            style: TextStyle(fontSize: pointTextSize,color: color),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    "POINTS",
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                Text(
                  isPointYouNeed ? "YOU NEED" : "YOU HAVE",
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
