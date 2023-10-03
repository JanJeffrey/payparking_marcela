import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'utils/db_helper.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
//import 'parkingTransList.dart';

class UpdateTrans extends StatefulWidget {
  final int id;
  final String plateNo;


  final String username;

  UpdateTrans({Key key, @required this.id, this.plateNo, this.username}) : super(key: key);
  @override
  _UpdateTrans createState() => _UpdateTrans();
}
class _UpdateTrans extends State<UpdateTrans>{


  final db = PayParkingDatabase();
  File pickedImage;
//  bool pressed = true;
  String locationA = "Location";
  var wheel = 0;
  Color buttonBackColorA;
  Color textColorA = Colors.black45;
  Color buttonBackColorB;
  Color textColorB = Colors.black45;
  setWheelA() {
    setState(() {
      buttonBackColorA = Colors.lightBlue;
      buttonBackColorB = Colors.transparent;
      textColorA = Colors.black45;
      wheel = 50;
    });
  }

  setWheelB() {
    setState(() {
      buttonBackColorB = Colors.lightBlue;
      buttonBackColorA = Colors.transparent;
      textColorB = Colors.black45;
      wheel = 100;
    });
  }

//  List<Widget> _getList() {
//    String location = widget.location;
//    var locCount = location.split(",").length;
//    var locSplit = location.split(",");
//    var counter  = locCount;
//
//    counter = counter-1;
//
//    List<Widget> temp = [];
//    for(var q = 0; q < locCount; q++) {
//      temp.add(
//        FlatButton(
//          child: new Text(locSplit[q]),
//          onPressed: () {
//            setState(() {
//              Navigator.of(context, rootNavigator: true).pop('dialog');
//              locationA = locSplit[q];
//            });
//          },
//        ),
//      );
//      if(q >= counter){
//
//        temp.add(
//          FlatButton(
//            child: new Text("Close "),
//            onPressed: () {
//              setState(() {
//                Navigator.of(context, rootNavigator: true).pop('dialog');
//                locationA = 'Location';
//              });
//            },
//          ),
//        );
//      }
//    }
//    return temp;
//  }


//  void addLocation(){
//    showDialog(
//      barrierDismissible: true,
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return CupertinoAlertDialog(
//          title: Text('Add Location'),
//          actions:  _getList(),
//        );
//      },
//    );
//  }
  TextEditingController plateNoController = TextEditingController();

  void confirmed(){
    if(plateNoController.text == "" ){

    }
    else {
        saveData();
    }
  }

  void saveData() async{

    bool result = await DataConnectionChecker().hasConnection;
    String plateNumber = plateNoController.text;
    var id = widget.id;

 //   if(result == true){
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text(plateNoController.text),
            content: new Text("Successfully Updated"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed:(){
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  plateNoController.text = "";
                },
              ),
            ],
          );
        },
      );
//      await db.olUpdateTransaction(id,plateNumber,wheel,locationA);
      await db.ofUpdateTransaction(id,plateNumber);
//      await db.addTrans(plateNumber,dateToday,dateTimeToday,dateUntil,amount,user,stat);
      locationA = "Location";
    //}
    // else{
    //   showDialog(
    //     barrierDismissible: true,
    //     context: context,
    //     builder: (BuildContext context) {
    //       // return object of type Dialog
    //       return CupertinoAlertDialog(
    //         title: new Text("Connection Problem"),
    //         content: new Text("Please Connect to the wifi hotspot or turn the wifi on"),
    //         actions: <Widget>[
    //           // usually buttons at the bottom of the dialog
    //           new FlatButton(
    //             child: new Text("Close"),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  String name;
  @override
  void initState(){
    super.initState();
    plateNoController.text = widget.plateNo;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,

        title: Text('Edit',style: TextStyle(fontWeight: FontWeight.bold,fontSize: width/28, color: Colors.black),),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {},
            child: Text(widget.username.toString(),style: TextStyle(fontSize: width/36,color: Colors.black),),
          ),
        ],
        textTheme: TextTheme(
            caption: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
            )
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),

          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
            child: new TextFormField(
              controller:plateNoController,
              autofocus: false,
//               enabled: false,
              style: TextStyle(fontSize: width/15),
              decoration: InputDecoration(
                hintText: 'Plate Number',
                contentPadding: EdgeInsets.all(width/15.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                suffixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 30.0),
                  child:  Icon(Icons.format_list_numbered, color: Colors.grey,size: 40.0,),
                ),
              ),
            ),
          ),

          Padding( padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20.0),
            child: Container(
//              width: 400.0,
              child: ConfirmationSlider(
                shadow:BoxShadow(color: Colors.black38, offset: Offset(1, 0),blurRadius: 1,spreadRadius: 1,),
                foregroundColor:Colors.blue,
                height: height/6,
                width : width-50,
                onConfirmation: () => confirmed(),
              ),),
          ),
        ],
      ),
    );
  }
}