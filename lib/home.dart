import 'package:flutter/cupertino.dart';
import 'parkingtrans.dart';
import 'parkingTransList.dart';
import 'history.dart';
import  'settings.dart';
import 'utils/db_helper.dart';
import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:flutter_blue/flutter_blue.dart';


class HomeT extends StatefulWidget {
  final logInData;
  HomeT({Key key, @required this.logInData}) : super(key: key);
  @override
  _Home createState() => _Home();
}

class _Home extends State<HomeT> {
  final db = PayParkingDatabase();

  //bluetooth var
//  BluetoothDevice device;
//  BluetoothState state;
//  BluetoothDeviceState deviceState;
  //end bluetooth var

  List userData;
  List getUsernameList;
  List userData1;
  String empId;
  String name;
  String empNameFn;
  String location;
  String loc = " ";
  String data;
  Timer timer;
  int counter;

  Future getCounter() async {
    var res = await db.getCounter();
    setState(() {
      if (counter == null) {
        counter = 0;
      } else {
        counter = res;
      }
    });
  }

  Future getUserData() async{
    print(widget.logInData+"hllo");
//    var res = await db.olFetchUserData(widget.logInData);
    var getLoc = await db.ofCountFetchUserData();
    var getUsername = await db.ofGetUsername(widget.logInData);
    userData = getLoc;
    getUsernameList = getUsername;
    int count = userData[0]['count'];
//    var locId = userData[0]['location_id'];
    var res = await db.ofFetchUserData();
    userData1 = res;
    print(userData1);

    setState(() {
      print(userData1);
      for(var q = 0; q < count; q++) {
        loc = (userData1[q]['location'])+","+loc;
        if(count>1){
          loc = loc.substring(0, loc.length - 1);
        }else{
          loc = loc.substring(0, loc.length - 1);
        }
      }
      name = getUsernameList[0]['username'];
      empNameFn = getUsernameList[0]['fullname'];
      location = loc;
      empId = getUsernameList[0]['empid'];
      print(name);
      print(empNameFn);
      print(location);
      print(empId);
    });
  }

  @override
  void initState(){
    super.initState();
    if(empId == null || name == null || location == null || empNameFn == null)
    {
      empId = "";
      name = "";
      empNameFn = "";
      location = "";

      print("di pwde kai walai location");
//      Navigator.of(context).pop();

    }else{
      empId = empId;
      name = name;
      empNameFn = empNameFn;
      location = location;
    }
    getUserData();
    super.initState();
    getCounter();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getCounter());
//    if (state == BluetoothState.off) {
//      print("bluetooth is off");
//    }
 // asdasdasd
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    var  defFontSize = 12.0;
    if(width <= 400){
      defFontSize = 10.0;
    }
    else{
      defFontSize = 12.0;
    }
    return WillPopScope(
        onWillPop: () async {
      return false;
    },
    child:
     CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home,size: 25.0),
            label: 'Park Me'
            // title: Text('Park me',style: TextStyle(
            //   fontSize: defFontSize, // insert your font size here
            // ),),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.collections,size: 25.0),
            label: 'Transactions',
            // title: Text('Transactions',style: TextStyle(
            //   fontSize:  defFontSize, // insert your font size here
            // ),),
          ),
          BottomNavigationBarItem(
            icon: new Stack(
              children: <Widget>[
                new Icon(Icons.notifications),
                new Positioned(
                  right: 0,
                  child: new Container(
                    padding: EdgeInsets.all(3),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: new Text(
                      '$counter',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            label: 'History'
            // title: Text('History',style: TextStyle(
            //   fontSize: defFontSize, // insert your font size here
            // ),),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person,size: 25.0),
            label: 'User'
            // title: Text('User',style: TextStyle(
            //   fontSize: defFontSize, // insert your font size here
            // ),),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
//                child: ParkTrans(id:id,nameL:nameL,nameF:nameF,location:location),
                child: ParkTrans(empId:empId, name:name, empNameFn:empNameFn, location:location),
              );
            });
            break;
          case 1:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: ParkTransList(empId:empId, name:name, location:location, empNameFn:empNameFn),
              );
            });
            break;
          case 2:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HistoryTransList(empId:empId,location:location),
              );
            });
            break;
          case 3:
            returnValue = CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Settings(empNameFn:empNameFn, location:location),
              );
            });
            break;
        }
        return returnValue;
      },
     )
    );
  }
}
