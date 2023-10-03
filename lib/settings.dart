import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'utils/db_helper.dart';
class Settings extends StatefulWidget {
  final String empNameFn;
  final String location;
  Settings({Key key, @required this.empNameFn, this.location}) : super(key: key);
  @override
  _Settings createState() => _Settings();
}
class _Settings extends State<Settings>{

  final db = PayParkingDatabase();
  String name;
  String location;
  Future getData() async{

      name = widget.empNameFn;
      location = widget.location;
  }
  @override
  void initState(){
    super.initState();
    getData();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    new MaterialApp(
      routes: <String, WidgetBuilder> {
        '/login': (BuildContext context) => new SignInPage(),
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Settings',style: TextStyle(fontWeight: FontWeight.bold,fontSize: width/28, color: Colors.black),),
        textTheme: TextTheme(
              caption: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              )
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red),
            color: Colors.white,
            onPressed: () {
              showDialog(barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context)
              {
                return CupertinoAlertDialog(
                  title: new Text("Confirm Log Out"),
                  content: new Text("Are you sure you want to log out?"),
                  actions: [
                    new TextButton(
                      child: new Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new TextButton(
                        child: new Text("Yes"),
                        onPressed: ()async {
                          final dateTimeLogout = DateFormat("yyyy-MM-dd : H:mm:ss aaa").format(DateTime.now());
                          final dateLogOut= DateFormat("yyyy-MM-dd").format(DateTime.now());
                          final timeLogOut= DateFormat("hh:mm:ss aaa").format(DateTime.now());
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          print('Time Log Out: $timeLogOut');
                          db.saveLogOutData(dateTimeLogout);
                          Navigator.of(context).pop();
                          Navigator.push(context,

                            MaterialPageRoute(builder: (context) => SignInPage()),);
                          Fluttertoast.showToast(
                              msg: "You have been logged out",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIos: 3,
                              backgroundColor: Colors.black26,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                    )
                  ],
                );
              },);
              //logOut();
            },
         ),
        ],
      ),
      body:Column(
          children: <Widget>[
            Expanded(
              child:RefreshIndicator(
                  onRefresh:getData,
                  child:ListView(
                    children: <Widget>[
                      Divider(
                        color: Colors.transparent,
                        height: 100.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Divider(
                            color: Colors.transparent,
                            height: 40.0,
                          ),
                          new Text(name,textScaleFactor: 1.5),
                          new Text(location,textScaleFactor: 1.1),
                          Divider(
                            color: Colors.transparent,
                            height: 60.0,
                          ),
//                          FlatButton(
//                            child: new Text('Log Out'.toString(),style: TextStyle(fontSize: width/30.0, color: Colors.grey),),
//                            color: Colors.transparent,
//                            padding: EdgeInsets.symmetric(horizontal:width/150.0,vertical: 20.0),
//                            shape: RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(30.0),
//                                side: BorderSide(color: Colors.lightBlue)
//                            ),
//                            onPressed:(){
//                              Navigator.push(
//                                   context,
//                                    MaterialPageRoute(builder: (context) => SignInPage()),
//                                  );
////                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) =>  SignInPage()));
//                            },
//                          ),
                          Divider(
                            color: Colors.transparent,
                          ),
                          TextButton(
                            child: new Text('172.16.46.128'.toString(),style: TextStyle(fontSize: width/31.0, color: Colors.grey),),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                // foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                padding: EdgeInsets.symmetric(horizontal: width/150.0,vertical: 20.0),
                                shape: RoundedRectangleBorder(  borderRadius: new BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.lightBlue))
                            ),
                            onPressed:(){
//                              Navigator.popUntil(context, ModalRoute.withName('/login'));
//                              Navigator.popUntil(context, ModalRoute.withName('/SignInPage'));
                            },
                          ),
//                          FlatButton(
//                            child: new Text('Connect to a Printer'.toString(),style: TextStyle(fontSize: width/31.0, color: Colors.grey),),
//                            color: Colors.transparent,
//                            padding: EdgeInsets.symmetric(horizontal:width/15.0,vertical: 5.0),
//                            shape: RoundedRectangleBorder(
//                                borderRadius: new BorderRadius.circular(35.0),
//                                side: BorderSide(color: Colors.lightBlue)
//                            ),
//                            onPressed:(){
//                              _getDeviceItems();
//                            },
//                          ),
                        ],
                      )
                    ],
                  )
              ),
            ),
          ],
      ),
    );
  }

   logOut() async{
    return CupertinoAlertDialog(
      title: new Text("Are you sure you want to log out?"),
      content: new Text(""),
      actions: [
        new TextButton(
            child: new Text("No"),
            onPressed:(){
            Navigator.of(context).pop();
          },
        ),
        new TextButton(
            child: new Text("Yes"),
            onPressed:()async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.of(context).pop();
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),

    );}
    )],
    );
  }
}

