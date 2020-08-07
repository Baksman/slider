import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    return Scaffold(
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
          new Expanded(child: Container(

          )),
          Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              children: <Widget>[
                _buildTextButtons("more",false),
                Spacer(),
                  _buildTextButtons("stats",false),
              ],
            ),
          //  height: ,
          )
        ],
      ),
    );
  }

  Widget _buildTextButtons(String title, bool isOnLight) {
    return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        onPressed: (){

        },
        child: Text(
          title.toUpperCase(), 
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isOnLight ? Theme.of(context).primaryColor : Colors.white,)
        ));
  }
}
