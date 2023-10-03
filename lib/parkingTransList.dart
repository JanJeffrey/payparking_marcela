import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'utils/db_helper.dart';
import 'utils/file_creator.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'update.dart';
import 'delinquent.dart';

//import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:device_apps/device_apps.dart';

class ParkTransList extends StatefulWidget {
  final String empId;
  final String name;
  final String empNameFn;
  final String location;

  ParkTransList(
      {Key key, @required this.name, this.empNameFn, this.location, this.empId})
      : super(key: key);

  @override
  _ParkTransList createState() => _ParkTransList();
}

class _ParkTransList extends State<ParkTransList> {
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  final db = PayParkingDatabase();
  final fileCreate = PayParkingFileCreator();
  List plateData;
  List plateData2;
  List data;
  TextEditingController _managerKeyUserPass;
  TextEditingController _managerKeyUser;
  TextEditingController _textController;

//  Timer timer;
//  Future getTransData() async {
//    var res = await db.fetchAll();
//    setState((){
//      plateData = res;
//    });
//  }
  Future getTransData() async {
    listStat = false;
    var res = await db.ofFetchAll();
    setState(() {
      plateData = res;
    });
  }

  Future updateStat(id) async {
    print(id);
    await db.updatePayTranStat(id);
  }

  Future passDataToHistoryWithOutPay(
      id,
      uid,
      checkDigit,
      plateNo,
      dateTimeIn,
      dateTimeNow,
      amount,
      user,
      empNameIn,
      outBy,
      empNameOut,
      location,
      penaltyAmount,
      totalHrs,
      lostOfTicket) async {
    String plateNumber = plateNo;
    final dateIn = DateFormat("yyyy-MM-dd : H:mm").format(dateTimeIn);
    final dateNow = DateFormat("yyyy-MM-dd : H:mm").format(dateTimeNow);
    var amountPay = amount;
    var penalty = 0;
//     await db.olAddTransHistory(id,uid,checkDigit,plateNumber,dateIn,dateNow,amountPay.toString(),penalty.toString(),user.toString(),outBy.toString(),location.toString());
    await db.addTransHistory(
        uid,
        checkDigit,
        plateNumber,
        dateIn,
        dateNow,
        amountPay.toString(),
        penalty.toString(),
        user.toString(),
        empNameIn.toString(),
        outBy.toString(),
        empNameOut.toString(),
        location.toString(),
        penaltyAmount.toString(),
        penaltyAmount.toString(),
        penaltyAmount.toString(),
        '0',
        totalHrs.toString(),
        lostOfTicket.toString());
    await db.updatePayTranStat(id);
    getTransData();
    Fluttertoast.showToast(
        msg: "Successfully added to history",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future passDataToHistoryWithPay(
      id,
      uid,
      checkDigit,
      plateNo,
      dateTimeIn,
      dateTimeNow,
      amount,
      penalty,
      user,
      empNameIn,
      outBy,
      empNameOut,
      location,
      penaltyOT,
      totalChargeAmount,
      totalNoOfExcessHours,
      totalNoOfHours,
      lostOfTicket) async {
    String plateNumber = plateNo;
    final dateIn = DateFormat("yyyy-MM-dd : H:mm").format(dateTimeIn);
    final dateNow = DateFormat("yyyy-MM-dd : H:mm").format(dateTimeNow);
    var amountPay = amount;
    //  int totalPenalty=penaltyOT+lostOfTicket;
//      await db.olAddTransHistory(id,uid,checkDigit,plateNumber,dateIn,dateNow,amountPay.toString(),penalty.toString(),user.toString(),outBy.toString(),location.toString());
    await db.addTransHistory(
        uid,
        checkDigit,
        plateNumber,
        dateIn,
        dateNow,
        amountPay.toString(),
        penalty.toString(),
        user.toString(),
        empNameIn.toString(),
        outBy.toString(),
        empNameOut.toString(),
        location.toString(),
        penaltyOT.toString(),
        totalNoOfExcessHours.toString(),
        totalChargeAmount.toString(),
        '0',
        totalNoOfHours.toString(),
        lostOfTicket.toString());
    await db.updatePayTranStat(id);
    await fileCreate.transactionTypeFunc('print_penalty');
    await fileCreate.transPenaltyFunc(
        uid,
        checkDigit,
        plateNumber,
        dateIn,
        dateNow,
        amountPay.toString(),
        penalty.toString(),
        user.toString(),
        empNameIn.toString(),
        outBy.toString(),
        empNameOut.toString(),
        location.toString(),
        penaltyOT.toString(),
        totalNoOfExcessHours.toString(),
        totalChargeAmount.toString(),
        totalNoOfHours.toString(),
        lostOfTicket.toString());
    getTransData();
//      await db.olSendTransType(widget.empId,'penalty');
    DeviceApps.openApp("com.example.cpcl_test_v1").then((_) {});
    Fluttertoast.showToast(
        msg: "Successfully added to history",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  bool listStat = false;

  Future _onChanged(text) async {
    listStat = true;
    var res = await db.ofFetchSearch(text);
    setState(() {
      plateData2 = res;
    });
  }

//  managerLoginReprint(plateData[index]['d_uid'],plateData[index]["d_chkdigit"],plateData[index]["d_Plate"],plateData[index]['d_dateToday'],plateData[index]["d_dateTimeToday"],plateData[index]['d_amount'],plateData[index]["d_emp_id"],plateData[index]['d_location']);
  Future managerLoginReprint(uid, checkDigit, plateNo, dateToday, dateTimeToday,
      dateUntil, amount, empId, location) async {
//    bool result = await DataConnectionChecker().hasConnection;
    print(plateNo);
//      var res = await db.olManagerLogin(_managerKeyUser.text,_managerKeyUserPass.text);

    var res =await db.ofManagerLogin(_managerKeyUser.text, _managerKeyUserPass.text);
//          print(res);
    setState(() {
      data = res;
    });
    if (data.isNotEmpty) {
      _managerKeyUser.clear();
      _managerKeyUserPass.clear();
//        await db.olSendTransType(widget.empId,'reprint');
//        await db.olReprintCouponTicket(uid,checkDigit,plateNo,dateToday,dateTimeToday,dateUntil,amount,empId,location);
      await fileCreate.transactionTypeFunc('reprint_coupon');
      await fileCreate.transactionsFunc(uid, checkDigit, plateNo, dateToday,
          dateTimeToday, dateUntil, amount, empId, location);

      DeviceApps.openApp("com.example.cpcl_test_v1").then((_) {});
    }
    if (data.isEmpty) {
      _managerKeyUser.clear();
      _managerKeyUserPass.clear();
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text("Wrong credentials"),
            content: new Text("Please check your username and password"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Transactions List',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: width / 28,
              color: Colors.black),
        ),
        leading: new IconButton(
          icon: new Icon(Icons.search, color: Colors.black),
          onPressed: () {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return CupertinoAlertDialog(
                  title: new Text("Search Plate#"),
                  content: new CupertinoTextField(
                    controller: _textController,
                    autofocus: true,
//                   onChanged: _onChanged,
                  ),
                  actions: <Widget>[
                    new TextButton(
                      child: new Text("Search"),
                      onPressed: () {
//                       print(_textController.text);
                      if(_textController.text.isEmpty){
                        Fluttertoast.showToast(
                            msg: "Empty Field",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{
                        _onChanged(_textController.text);
                        _textController.clear();
                        Navigator.of(context).pop();
                      }
                      },
                    ),
                    new TextButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        actions: <Widget>[
           TextButton(
            style: TextButton.styleFrom(
              surfaceTintColor: Colors.white,
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
            onPressed: (){},
            child: Text(widget.name.toString(),style: TextStyle(fontSize: width/36,color: Colors.black),),

          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
//            color: Colors.transparent,
//            margin: EdgeInsets.all(5),
//            elevation: 0.0,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                Text('  Above 2 Hours:',
                  style: TextStyle(fontSize: width / 32, color: Colors.black),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 20.0,
                  width: 20.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.redAccent.withOpacity(.3),
                    ),
                  ),
                ),
                Text('Almost 2 Hours:',
                  style: TextStyle(fontSize: width / 32, color: Colors.black),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 20.0,
                  width: 20.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.blueAccent.withOpacity(.3),
                    ),
                  ),
                ),
                Text('New Entry:',
                  style: TextStyle(fontSize: width / 32, color: Colors.black),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 20.0,
                  width: 20.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: getTransData,
              child: Scrollbar(
                child: listStat == true
                    ? ListView.builder(
                  //physics: BouncingScrollPhysics(),
                  itemCount: plateData2 == null ? 0 : plateData2.length,
                  itemBuilder: (BuildContext context, int index) {
                    var f = index;
                    f++;
                    var trigger;
                    int penalty = 0;
                    int lostOfTicket = 250;
                    String alertButton;
                    Color cardColor;
                    var dateString = plateData2[index]["dateToday"]; //getting time
                    var date = dateString.split("-"); //split time
                    var hrString = plateData2[index]["dateTimeToday"]; //getting time
                    var hour = hrString.split(":"); //split time
                    var vType = plateData2[index]["amount"];

                    final dateTimeIn = DateTime(
                        int.parse(date[0]),
                        int.parse(date[1]),
                        int.parse(date[2]),
                        int.parse(hour[0]),
                        int.parse(hour[1]));
                    final dateTimeNow = DateTime.now();
                    final difference = dateTimeNow.difference(dateTimeIn).inMinutes;
                    final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: difference));
                    final timeAg = timeAgo.format(fifteenAgo);
                    bool enabled = false;
                    print(difference);
                    var vtype2='';
                    if(vType=='100'){
                      vtype2=' 4-wheeled';
                    }
                    if(vType=='50'){
                      vtype2=' 2-wheeled';
                    }
                    if (difference >= 6) {
//                         enabled = false;
                    }
                    if (difference < 70) {
                      alertButton = "Logout";
                      trigger = 0;
                      cardColor = Colors.white;
//                        enabled = false;
                    }
                    if (difference >= 120) {
                      alertButton = "Logout & Print receipt";
                      trigger = 1;
                      enabled = true;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("23");
                    }
                    if (difference >= 120 && vType == '100') {
                      penalty = 20;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("22");
                    }
                    if (difference >= 240 && vType == '100') {
                      penalty = 40;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("21");
                    }
                    if (difference >= 300 && vType == '100') {
                      penalty = 60;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("20");
                    }
                    if (difference >= 360 && vType == '100') {
                      penalty = 80;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("19");
                    }
                    if (difference >= 420 && vType == '100') {
                      penalty = 100;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("18");
                    }
                    if (difference >= 480 && vType == '100') {
                      penalty = 120;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("17");
                    }
                    if (difference >= 540 && vType == '100') {
                      penalty = 140;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("16");
                    }
                    if (difference >= 600 && vType == '100') {
                      penalty = 160;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("15");
                    }
                    if (difference >= 660 && vType == '100') {
                      penalty = 180;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("14");
                    }
                    if (difference >= 720 && vType == '100') {
                      penalty = 200;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("13");
                    }
                    if (difference >= 780 && vType == '100') {
                      penalty = 220;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("12");
                    }
                    if (difference >= 840 && vType == '100') {
                      penalty = 240;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("11");
                    }
                    if (difference >= 900 && vType == '100') {
                      penalty = 260;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("10");
                    }
                    if (difference >= 960 && vType == '100') {
                      penalty = 280;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("9");
                    }
                    if (difference >= 1020 && vType == '100') {
                      penalty = 300;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("8");
                    }
                    //for 2 wheels
                    if (difference >= 120 && vType == '50') {
                      penalty = 10;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print('if (difference >120 && vType == 50)');
                      print("7");
                    }
                    if (difference >= 240 && vType == '50') {
                      penalty = 20;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("6");
                    }
                    if (difference >= 300 && vType == '50') {
                      penalty = 30;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("5");
                    }
                    if (difference >= 360 && vType == '50') {
                      penalty = 40;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("4");
                    }
                    if (difference >= 420 && vType == '50') {
                      penalty = 50;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("3");
                    }
                    if (difference >= 480 && vType == '50') {
                      penalty = 60;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("2");
                    }
                    if (difference >= 540 && vType == '50') {
                      penalty = 70;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("1");
                    }
                    if (difference >= 600 && vType == '50') {
                      penalty = 80;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 600 && vType == '50'");
                    }
                    if (difference >= 660 && vType == '50') {
                      penalty = 90;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 660 && vType == '50'");
                    }
                    if (difference >= 720 && vType == '50') {
                      penalty = 100;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 720 && vType == '50'");
                    }
                    if (difference >= 780 && vType == '50') {
                      penalty = 110;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 780 && vType == '50'");
                    }
                    if (difference >= 840 && vType == '50') {
                      penalty = 120;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 840 && vType == '50'");
                    }
                    if (difference >= 900 && vType == '50') {
                      penalty = 130;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 900 && vType == '50'");
                    }
                    if (difference >= 960 && vType == '50') {
                      penalty = 140;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 960 && vType == '50'");
                    }
                    if (difference >= 1020 && vType == '50') {
                      penalty = 150;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 1020 && vType == '50'");
                    }
                    if (difference >= 70 && difference <= 120) {
                      alertButton = "Logout";
                      trigger = 0;
                      cardColor = Colors.blueAccent.withOpacity(.3);
                      print('difference == $difference');
                      print('if (difference >= 70 && difference <= 119)');
                      print('dateTimeIn == $dateTimeIn');
//                        enabled = false;
                    }
//                    if(DateFormat("H:mm").format(new DateTime.now()) == 18 && vType == '50'){
//                      violation = 500;
//                    }
                    int strvechicleCharge;
                    //   int penaltyAmount=0, excessNoOfHoursFirstDay, excessNoOfHoursLastDay, excessNoOfHoursInBetween, totalNoOfExcessHours, totalChargeAmount=0, excessNoOfHours=0;
                    if (vType == '50') {
                      strvechicleCharge = 10;
                    } else if (vType == '100') {
                      strvechicleCharge = 20;
                    } else {}
                    DateTime now = new DateTime.now();
                    String timeNowHrs = DateFormat.H().format(now);
                    int intTimeNowHrs = int.parse(timeNowHrs);
                    String timeNowMin = DateFormat.m().format(now);
                    int intTimeNowMin = int.parse(timeNowMin);
                    String strTimeNowDay = DateFormat.d().format(now);
                    int intTimeNowDay = int.parse(strTimeNowDay);
                    final diffInHours = dateTimeNow.difference(dateTimeIn).inHours;
                    final diffInDays = dateTimeNow.difference(dateTimeIn).inDays;
                    DateTime dateNow = new DateTime(now.year, now.month, now.day);
                    DateTime timeInDateNow = new DateTime(dateTimeIn.year, dateTimeIn.month, dateTimeIn.day);
                    String strTimeInHrs = DateFormat.H().format(dateTimeIn);
                    int intTimeInHrs = int.parse(strTimeInHrs);
                    String strTimeInMin = DateFormat.m().format(dateTimeIn);
                    int intTimeInMin = int.parse(strTimeInMin);
                    String strTimeInDay = DateFormat.d().format(dateTimeIn);
                    int intTimeInDay = int.parse(strTimeInDay);
                    //final numberOfDays = now.difference(dateTimeIn).inDays;
                    final numberOfDays = intTimeNowDay - intTimeInDay;
                    int penaltyAmount = 0,
                        excessNoOfHoursFirstDay = 0,
                        excessNoOfHoursLastDay = 0,
                        excessNoOfHoursInBetween = 0,
                        totalNoOfExcessHours = 0,
                        totalChargeAmount = 0,
                        totalNoOfHours = 0,
                        excessNoOfHours = 0;
                    if (dateNow.isAfter(timeInDateNow)) {
                      if (intTimeNowHrs >= 25) //Compare if Time IN is greater than 7pm(cut-off time)...
                          {
                        if (intTimeNowMin > 0) {
                          penaltyAmount = (numberOfDays + 1) * 500;
                          print("intTimeNowMin > 0 || intTimeNow >= 19 == TRUE || ubos");
                        } else {
                          penaltyAmount = numberOfDays * 500;
                          print("intTimeNowMin !> 0 || intTimeNow >= 19 == TRUE || ubos");
                        }
                      } else {
                        if (numberOfDays == 0) {
                          penaltyAmount = 1 * 500;
                          print("numberOfDays == 0 TRUE");
                        } else {
                          print("numberOfDays == 0 FALSE");
                          // if(intTimeNowHrs >= 0 && intTimeNowHrs < 8)
                          // {
                          penaltyAmount = (numberOfDays) * 500;
                          //   print("intTimeNowHrs >= 0 && intTimeNowHrs < 8 TRUE");
                          // }
                          // else
                          // {
                          //   penaltyAmount = numberOfDays * 500;
                          //   print("intTimeNowHrs >= 0 && intTimeNowHrs < 8 FALSE");
                          // }
                        }
                      }
                      if (numberOfDays > 2) {
                        // excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                        // excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                        // excessNoOfHoursInBetween = (numberOfDays - 1) * 12;
                        // totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay + excessNoOfHoursInBetween) - 2;
                        // totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                        // print("numberOfDays >= 2 TRUE");
                        if (intTimeNowHrs < 8) {
                          excessNoOfHours = 19 - intTimeInHrs;
                          if (excessNoOfHours >= 2) {
                            print("excessNoOfHours >= 2 TRUE || numberOfDays > 2");
                            excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                            excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                            excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                            totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween) -2;
                            totalNoOfHours= (excessNoOfHoursFirstDay + excessNoOfHoursInBetween);
                            totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                          } else {
                            print("excessNoOfHours >= 2 FALSE || numberOfDays > 2");
                            totalChargeAmount = 0; //ok na
                          }
                        } else {
                          if (intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                              {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 TRUE || numberOfDays > 2");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            } else {
                              print("intTimeNowHrs >= 19 TRUE || numberOfDays > 2");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) ;
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('totalNoOfExcessHours = $totalNoOfExcessHours');
                            }
                          } else {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 FALSE || numberOfDays > 2 && intTimeNowMin > 0 TRUE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours= (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('\t\t OKKK');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursInBetween = $excessNoOfHoursInBetween');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                              // print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                            } else {
                              print("intTimeNowHrs >= 19 FALSE || numberOfDays > 2 && intTimeNowMin > 0 FALSE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('\t\t OKKKKKKK');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursInBetween = $excessNoOfHoursInBetween');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                            }
                          }
                        }
                      }
                      else if (numberOfDays == 2) {
                        if (intTimeNowHrs < 8) {
                          excessNoOfHours = 19 - intTimeInHrs;
                          if (excessNoOfHours > 2) {
                            print("excessNoOfHours >= 2 TRUE || numberOfDays == 2");
                            print('else if (numberOfDays == 2)');
                            totalNoOfExcessHours = (excessNoOfHours + 11) - 2;
                            totalNoOfHours=excessNoOfHours+11;
                            totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            print('totalNoOfExcessHours = $totalNoOfExcessHours');
                            print('totalNoOfHours = $totalNoOfHours');
                            //  print('totalNoOfExcessHours = $totalNoOfExcessHours');
                          } else {
                            print("excessNoOfHours >= 2 FALSE || numberOfDays == 2");
                            totalChargeAmount = 0; //ok na
                          }
                        } else {
                          if (intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                              {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 TRUE || numberOfDays == 2 && intTimeNowMin > 0 TRUE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              excessNoOfHoursInBetween = 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            } else {
                              print("intTimeNowHrs >= 19 TRUE || numberOfDays == 2 && intTimeNowMin > 0 FALSE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              excessNoOfHoursInBetween = 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('\t\t\t!OK');
                            }
                          } else {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 FALSE || numberOfDays == 2"); //ok
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              excessNoOfHoursInBetween = 11;
                              if(excessNoOfHoursFirstDay <= 2)
                              {
                                totalNoOfExcessHours = (excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              }
                              else
                              {
                                totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              }
                              totalNoOfHours= (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('\t\t\tOK');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                              print('totalNoOfHours           = $totalNoOfHours');
                              print('totalChargeAmount        = $totalChargeAmount');
                            } else {
                              print("intTimeNowHrsS >= 19 FALSE || numberOfDays == 2"); //ok
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              excessNoOfHoursInBetween = 11;
                              if(excessNoOfHoursFirstDay <= 2)
                              {
                                totalNoOfExcessHours = (excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              }
                              else
                              {
                                totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              }

                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('OKKKKKKKKKKKK');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                              print('totalNoOfHours           = $totalNoOfHours');
                              print('totalChargeAmount        = $totalChargeAmount');
                            }
                          }
                        }
                      }
                      else {
                        if (intTimeNowHrs < 8) {
                          excessNoOfHours = 19 - intTimeInHrs;
                          if (excessNoOfHours > 2) {
                            print("excessNoOfHours >= 2 TRUE");
                            totalNoOfExcessHours = excessNoOfHours - 2;
                            totalNoOfHours=excessNoOfHours;
                            totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                          } else {
                            print("excessNoOfHours >= 2 FALSE");
                            totalChargeAmount = 0; //ok na
                          }
                        } else {
                          if (intTimeNowHrs >= 25) //Compare if Time IN is greater than 7pm(cut-off time)...
                              {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 && intTimeNowMin > 0 TRUE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            } else {
                              print("intTimeNowHrs >= 19 && intTimeNowMin > 0 FALSE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours= (excessNoOfHoursFirstDay + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            }
                          } else {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowMin > 0 TRUE wwww || ubos");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours =(excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours *strvechicleCharge; //Depende sa no. of wheels
                              print('OKKKKK');
                              print('totalNoOfExcessHours = $totalNoOfExcessHours');
                              print('totalNoOfHours       = $totalNoOfHours');
                              //  print('totalNoOfExcessHours= $totalNoOfExcessHours');
                            } else {
                              print("intTimeNowMin > 10 FALSE || UBOS");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              if(excessNoOfHoursFirstDay <= 2)
                              {
                                totalNoOfExcessHours = excessNoOfHoursLastDay;
                              }
                              else
                              {
                                totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                              }
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('OKKKKK');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfHours           = $totalNoOfHours');
                            }
                          }
                        }
                      }
                    }
                    else {
                      if (intTimeNowHrs >= 25 && intTimeNowMin >= 1) //Compare if Time IN is greater than 7pm(cut-off time)...
                          {
                        if ((25 - intTimeInHrs) >= 2) {
                          print("19 - intTimeInHrs) >= 2 TRUE || ubos");
                          penaltyAmount = 500;
                          excessNoOfHours = 21 - intTimeInHrs;
                          totalNoOfExcessHours = excessNoOfHours - 2;
                          totalNoOfHours=excessNoOfHours;
                          totalChargeAmount = totalNoOfExcessHours *strvechicleCharge; //Depende sa no. of wheels
                        } else {
                          print("19 - intTimeInHrs) >= 2 FALSE");
                          penaltyAmount = 500;
                          totalChargeAmount = 0;
                        }
                      } else {
                        penaltyAmount = 0;
                        excessNoOfHours = intTimeNowHrs - intTimeInHrs;
                        if (excessNoOfHours >= 2) {
                          if (intTimeNowMin > intTimeInMin) {
                            if (intTimeNowMin > intTimeInMin) {
                              print("intTimeNowMin > intTimeInMin TRUE UBOS");
                              totalNoOfExcessHours = excessNoOfHours - 1;
                              totalNoOfHours=excessNoOfHours+1;
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge;
                              print('KKKKKKKK');
                              print('totalNoOfExcessHours = $totalNoOfExcessHours');
                              print('excessNoOfHours      = $excessNoOfHours');
                              print('totalNoOfHours       = $totalNoOfHours');
                              //Depende sa no. of wheels
                            } else {
                              print("intTimeNowMin > intTimeInMin FALSE UBOS");
                              print('sfsfsdf');
                              totalNoOfExcessHours = excessNoOfHours - 1;
                              totalNoOfHours=excessNoOfHours+1;
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('excessNoOfHours       = $excessNoOfHours');
                              print('totalNoOfExcessHours  = $totalNoOfExcessHours');
                              print('totalNoOfHours        = $totalNoOfHours');
                            }
                          } else {
                            print("intTimeNowMin >= intTimeInMin FALSE UBOS");
                            totalNoOfExcessHours = excessNoOfHours - 2;
                            totalNoOfHours=excessNoOfHours;
                            totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            print('okkkk');
                            print('totalNoOfExcessHours = $totalNoOfExcessHours');
                            print('totalNoOfHours       = $totalNoOfHours');
                            print('excessNoOfHours      = $excessNoOfHours');
                          }
                        } else {
                          totalChargeAmount = 0;
                          print('okay');
                          print("excessNoOfHours >= 2 FALSE ubos");
                        }
                      }
                    }
                    // if(intTimeNowMin > intTimeInMin)
                    // {

                    // }
                    // else
                    // {
                    //   totalNoOfHours = diffInHours;
                    // }
                    // print('Different in Hours: $diffInHours');
                    // print('Total No. Of Hours: $totalNoOfHours');
                    // print("Date Now: ");
                    // print(dateNow);
                    // print("Date Time In: ");
                    // print(timeInDateNow);
                    // print("Time Now: ");
                    // print(timeNow);
                    // print("Time IN Now: ");
                    // print(strTimeIn);
                    // print("No of Days: ");
                    // print(numberOfDays);
                    // print("Penalty: ");
                    // print(penaltyAmount);
                    // print("Excess No Of Hours First Day: ");
                    // print(excessNoOfHoursFirstDay);
                    // print("Excess No Of Hours Last Day: ");
                    // print(excessNoOfHoursLastDay);
                    // print("Excess No Of Hours In Between: ");
                    // print(excessNoOfHoursInBetween);
                    // print("Int Time Now: ");
                    // print(intTimeNowHrs);
                    // print("Int Time In: ");
                    // print(intTimeInHrs);
                    // print("Excess No Of Hours: ");
                    // print(excessNoOfHours);
                    // print("strvechicleCharge: ");
                    // print(strvechicleCharge);
                    // print("Total No Of Excess Hours: ");
                    // print(totalNoOfExcessHours);
                    // print("Total Charge Amount: ");
                    // print(totalChargeAmount);
                    var totalAmount = penalty + num.parse(vType);
                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return CupertinoAlertDialog(
//                                 title: new Text(plateData[index]["d_Plate"]),
//                                 content: new Text(alertText),
                              title: new Text(plateData2[index]["plateNumber"]),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text(alertButton),
                                  onPressed: () {
//                                       if(trigger == 0){
//                                         passDataToHistoryWithOutPay(int.parse(plateData[index]["d_id"]),plateData[index]["d_Plate"],dateTimeIn,DateTime.now(),plateData[index]["d_amount"],plateData[index]["d_emp_id"],plateData[index]['d_user'],widget.empId,widget.name,plateData[index]["d_location"]);
//                                       }
//                                       if(trigger == 1){
//                                         passDataToHistoryWithPay(int.parse(plateData[index]["d_id"]),plateData[index]["d_Plate"],dateTimeIn,DateTime.now(),plateData[index]["d_amount"],penalty,plateData[index]["d_emp_id"],plateData[index]['d_user'],widget.empId,widget.name,plateData[index]["d_location"]);
//                                       }
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return CupertinoAlertDialog(
                                          title:
                                          new Text("Are you sure?"),
                                          content: new Text(
                                              "Do you want to log out this plate # ${plateData2[index]["plateNumber"]}"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new TextButton(
                                              child: new Text("Yes"),
                                              onPressed: () {
                                                print('WITH PAY UBOS');
                                                if (trigger == 0) {
                                                  passDataToHistoryWithOutPay(
                                                      plateData2[index]["id"],
                                                      plateData2[index]['uid'],
                                                      plateData2[index]["checkDigit"],
                                                      plateData2[index]["plateNumber"],
                                                      dateTimeIn,
                                                      DateTime.now(),
                                                      plateData2[index]["amount"],
                                                      plateData2[index]["empId"],
                                                      plateData2[index]["fname"],
                                                      widget.empId,
                                                      widget.empNameFn,
                                                      plateData2[index]["location"],
                                                      '0',
                                                      totalNoOfHours,
                                                      '0');
                                                  print('WITHOUT PAY UBOS');
                                                }
                                                if (trigger == 1) {
                                                  //  int p = penaltyAmount + 0;
                                                  passDataToHistoryWithPay(
                                                      plateData2[index]['id'],
                                                      plateData2[index]['uid'],
                                                      plateData2[index]["checkDigit"],
                                                      plateData2[index]['plateNumber'],
                                                      dateTimeIn,
                                                      DateTime.now(),
                                                      plateData2[index]['amount'],
                                                      penalty.toString(),
                                                      plateData2[index]["empId"],
                                                      plateData2[index]['fname'],
                                                      widget.empId,
                                                      widget.empNameFn,
                                                      plateData2[index]['location'],
                                                      penaltyAmount.toString(),
                                                      totalChargeAmount.toString(),
                                                      totalNoOfExcessHours.toString(),
                                                      totalNoOfHours.toString(),
                                                      '0');
                                                  print('WITH PAY UBOSS');
                                                }
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            new TextButton(
                                              child: new Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              }
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                new TextButton(
                                  child: new Text("Edit"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print(plateData2[index]["id"]);
                                    print(plateData2[index]["plateNumber"]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateTrans(
                                              id: plateData2[index]["id"],
                                              plateNo: plateData2[index]["plateNumber"],
                                              username: widget.name)),
                                    );
                                  },
                                ),
                                new TextButton(
                                  child: new Text("Escapee"),
                                  onPressed: enabled
                                      ? () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder:
                                          (BuildContext context) {
                                        // return object of type Dialog
                                        return CupertinoAlertDialog(
                                          title: new Text("Manager's key"),
                                          content: new Column(
                                            children: <Widget>[
                                              new CupertinoTextField(
                                                autofocus: true,
                                                placeholder: "Username",
                                                controller: _managerKeyUser,
                                              ),
                                              Divider(),
                                              new CupertinoTextField(
                                                autofocus: true,
                                                placeholder: "Password",
                                                controller: _managerKeyUserPass,
                                                obscureText: true,
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            new TextButton(
                                              child: new Text("Proceed"),
                                              onPressed: () async {
                                                int totalp=penaltyAmount+500;
//                                                    var res = await db.olManagerLogin(_managerKeyUser.text,_managerKeyUserPass.text);
//                                                    print(res);
                                                var res = await db.ofManagerLogin(_managerKeyUser.text, _managerKeyUserPass.text);
                                                setState(() {
                                                  data = res;
                                                });
                                                if (data.isNotEmpty) {
                                                  _managerKeyUser.clear();
                                                  _managerKeyUserPass.clear();
                                                  Navigator.of(context).pop();
                                                  Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Delinquent(
                                                            id: plateData2[index]["id"],
                                                            uid: plateData2[index]['uid'],
                                                            checkDigit: plateData2[index]["checkDigit"],
                                                            plateNo: plateData2[index]["plateNumber"],
                                                            username: widget.name,
                                                            dateTimeIn: dateTimeIn,
                                                            dateTimeNow: DateTime.now(),
                                                            amount: plateData2[index]["amount"],
                                                            penalty: penalty,
                                                            empId: plateData2[index]["empId"],
                                                            fname: plateData2[index]['fname'],
                                                            empIDwid: widget.empId,
                                                            fullName: widget.empNameFn,
                                                            location: plateData2[index]["location"],
                                                            penaltyA: 500,
                                                            totCharge: 0,
                                                            excessHr: excessNoOfHours,
                                                            totafHours: totalNoOfHours,
                                                            lostTicket: 0)),
                                                  );
                                                  //   MaterialPageRoute(builder: (context) => Delinquent(id:plateData[index]["id"],fullName:widget.empNameFn,username:widget.name,uid:plateData[index]["uid"],plateNo:plateData[index]["plateNumber"])),
                                                  //
                                                  //   //  passDataToHistoryWithPay(plateData[index]["id"],plateData[index]['uid'],plateData[index]["checkDigit"],plateData[index]["plateNumber"],dateTimeIn,DateTime.now(),plateData[index]["amount"],penalty,plateData[index]["empId"],plateData[index]['fname'],widget.empId,widget.empNameFn,plateData[index]["location"],penaltyAmount,totalChargeAmount,totalNoOfExcessHours);
                                                  //
                                                  // );
                                                }
                                                if (data.isEmpty) {_managerKeyUser.clear();_managerKeyUserPass.clear();
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext
                                                  context) {
                                                    // return object of type Dialog
                                                    return CupertinoAlertDialog(
                                                      title: new Text("Wrong credentials"),
                                                      content:
                                                      new Text("Please check your username and password"),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        new TextButton(
                                                          child: new Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                }
                                              },
                                            ),
                                            new TextButton(
                                              child:
                                              new Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                      : null,
                                ),
                                new TextButton(
                                  child: new Text("Reprint"),
                                  onPressed: () {
//                                        couponPrint.sample(plateData[index]["d_Plate"],DateFormat("yyyy-MM-dd").format(dateTimeIn),DateFormat("hh:mm a").format(dateTimeIn),DateFormat("yyyy-MM-dd").format(dateTimeIn.add(new Duration(days: 7))),plateData[index]['d_amount'],"ppd","12","location");
//                                          Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => Reprint(id:plateData[index]["d_id"],fullName:widget.empNameFn,username:widget.name,uid:plateData[index]["d_uid"],plateNo:plateData[index]["d_Plate"])),
//                                          );
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return CupertinoAlertDialog(
                                          title:
                                          new Text("Manager's key"),
                                          content: new Column(
                                            children: <Widget>[
                                              new CupertinoTextField(
                                                autofocus: true,
                                                placeholder: "Username",
                                                controller: _managerKeyUser,
                                              ),
                                              Divider(),
                                              new CupertinoTextField(
                                                autofocus: true,
                                                placeholder: "Password",
                                                controller: _managerKeyUserPass, obscureText: true,
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            new TextButton(
                                              child: new Text("Proceed"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                managerLoginReprint(
                                                    plateData2[index]['uid'],
                                                    plateData2[index]["checkDigit"],
                                                    plateData2[index]["plateNumber"],
                                                    plateData2[index]['dateToday'],
                                                    plateData2[index]["dateTimeToday"],
                                                    plateData2[index]['dateUntil'],
                                                    plateData2[index]['amount'],
                                                    plateData2[index]["empId"],
                                                    plateData2[index]['location']);
                                              },
                                            ),
                                            new TextButton(
                                              child: new Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                new TextButton(
                                  child:
                                  new Text("Logout/Lost of Ticket"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return CupertinoAlertDialog(
                                          title:
                                          new Text("Are you sure?"),
                                          content: new Text(
                                              "Do you want to tag as lost of ticket & log out this plate # ${plateData[index]["plateNumber"]}"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new TextButton(
                                              child: new Text("Yes"),
                                              onPressed: () {
                                                print('LOST TICKET');
                                                passDataToHistoryWithPay(
                                                    plateData2[index]["id"],
                                                    plateData2[index]['uid'],
                                                    plateData2[index]["checkDigit"],
                                                    plateData2[index]["plateNumber"],
                                                    dateTimeIn,
                                                    DateTime.now(),
                                                    plateData2[index]["amount"],
                                                    penalty,
                                                    plateData2[index]["empId"],
                                                    plateData2[index]['fname'],
                                                    widget.empId,
                                                    widget.empNameFn,
                                                    plateData2[index]["location"],
                                                    penaltyAmount,
                                                    totalChargeAmount,
                                                    totalNoOfExcessHours,
                                                    totalNoOfHours,
                                                    lostOfTicket);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            new TextButton(
                                              child: new Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
//                                  new FlatButton(
//                                    child: new Text("Cancellation"),
//                                    onPressed: enabled ? () {
//                                      Navigator.of(context).pop();
//                                      showDialog(
//                                        barrierDismissible: true,
//                                        context: context,
//                                        builder: (BuildContext context) {
//                                          // return object of type Dialog
//                                          return CupertinoAlertDialog(
//                                            title: new Text("Manager's key"),
//                                            content: new Column(
//                                              children: <Widget>[
//
//                                                new CupertinoTextField(
//                                                  autofocus: true,
//                                                  placeholder: "Username",
//                                                  controller: _managerKeyUser,
//                                                ),
//                                                Divider(),
//                                                new CupertinoTextField(
//                                                  autofocus: true,
//                                                  placeholder: "Password",
//                                                  controller: _managerKeyUserPass,
//                                                  obscureText: true,
//                                                ),
//
//                                              ],
//                                            ),
//                                            actions: <Widget>[
//                                              new FlatButton(
//                                                child: new Text("Proceed"),
//                                                onPressed:(){
//                                                  Navigator.of(context).pop();
//                                                  managerCancel(plateData[index]['plateNumber'],plateData[index]["id"]);
//                                                },
//                                              ),
//                                              new FlatButton(
//                                                child: new Text("Close"),
//                                                onPressed:(){
//                                                  Navigator.of(context).pop();
//                                                },
//                                              ),
//                                            ],
//                                          );
//                                        },
//                                      );
//                                    } : null,
//                                  ),
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        color: cardColor,
                        margin: EdgeInsets.all(5),
                        elevation: 0.0,
                        child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              title: Text('$f.Plt No : ${plateData2[index]["plateNumber"]}'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: width / 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('     Time In : ' + DateFormat("yyyy-MM-dd hh:mm a").format(dateTimeIn), style: TextStyle(fontSize: width / 32),),
                                  Text('     Time lapse : $timeAg', style: TextStyle(fontSize: width / 32),),
                                  Text('     Vehicle Type : $vtype2', style: TextStyle(fontSize: width / 32),),
                                  Text('     Charge : ' + oCcy.format(totalChargeAmount), style: TextStyle(fontSize: width / 32),),
                                  Text('     Penalty : ' + oCcy.format(penaltyAmount), style: TextStyle(fontSize: width / 32),),
                                  Text('     Trans Code : ' + plateData2[index]["checkDigit"], style: TextStyle(fontSize: width / 32),),
                                  Text('     In By : ' + plateData2[index]["fname"], style: TextStyle(fontSize: width / 32),),
                                  Text('     Location : ' + plateData2[index]["location"], style: TextStyle(fontSize: width / 32),
                                  ),
                                  Text('     Total : '+oCcy.format(totalAmount),style: TextStyle(fontSize: width/32),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ) //folded
//================================================================= UBOSSS
                    : ListView.builder(
//                   physics: BouncingScrollPhysics(),
                  itemCount: plateData == null ? 0 : plateData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var f = index;
                    f++;
                    var trigger;
                    int penalty = 0;
                    int lostOfTicket = 250;
                    String alertButton;
                    Color cardColor;
                    var dateString = plateData[index]["dateToday"]; //getting time
                    var date = dateString.split("-"); //split time
                    var hrString = plateData[index]["dateTimeToday"]; //getting time
                    var hour = hrString.split(":"); //split time
                    var vType = plateData[index]["amount"];
                    final dateTimeIn = DateTime(
                        int.parse(date[0]),
                        int.parse(date[1]),
                        int.parse(date[2]),
                        int.parse(hour[0]),
                        int.parse(hour[1]));
                    final dateTimeNow = DateTime.now();
                    final difference = dateTimeNow.difference(dateTimeIn).inMinutes;
                    final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: difference));
                    final timeAg = timeAgo.format(fifteenAgo);
                    bool enabled = false;
                    print(difference);
                    var vtype2='';
                    if(vType=='100'){
                      vtype2=' 4-wheeled';
                    }
                    if(vType=='50'){
                      vtype2=' 2-wheeled';
                    }
                    if (difference >= 6) {
//                         enabled = false;
                    }
                    if (difference < 70) {
                      alertButton = "Logout";
                      trigger = 0;
                      cardColor = Colors.white;
//                        enabled = false;
                    }

                    if (difference >= 120) {
                      alertButton = "Logout & Print receipt";
                      trigger = 1;
                      enabled = true;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("23");
                    }
                    if (difference >= 120 && vType == '100') {
                      penalty = 20;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("22");
                    }
                    if (difference >= 240 && vType == '100') {
                      penalty = 40;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("21");
                    }
                    if (difference >= 300 && vType == '100') {
                      penalty = 60;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("20");
                    }
                    if (difference >= 360 && vType == '100') {
                      penalty = 80;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("19");
                    }
                    if (difference >= 420 && vType == '100') {
                      penalty = 100;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("18");
                    }
                    if (difference >= 480 && vType == '100') {
                      penalty = 120;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("17");
                    }
                    if (difference >= 540 && vType == '100') {
                      penalty = 140;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("16");
                    }
                    if (difference >= 600 && vType == '100') {
                      penalty = 160;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("15");
                    }
                    if (difference >= 660 && vType == '100') {
                      penalty = 180;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("14");
                    }
                    if (difference >= 720 && vType == '100') {
                      penalty = 200;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("13");
                    }
                    if (difference >= 780 && vType == '100') {
                      penalty = 220;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("12");
                    }
                    if (difference >= 840 && vType == '100') {
                      penalty = 240;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("11");
                    }
                    if (difference >= 900 && vType == '100') {
                      penalty = 260;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("10");
                    }
                    if (difference >= 960 && vType == '100') {
                      penalty = 280;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("9");
                    }
                    if (difference >= 1020 && vType == '100') {
                      penalty = 300;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("8");
                    }
                    //for 2 wheels
                    if (difference >= 120 && vType == '50') {
                      penalty = 10;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print('if (difference >120 && vType == 50)');
                      print("7");
                    }
                    if (difference >= 240 && vType == '50') {
                      penalty = 20;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("6");
                    }
                    if (difference >= 300 && vType == '50') {
                      penalty = 30;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("5");
                    }
                    if (difference >= 360 && vType == '50') {
                      penalty = 40;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("4");
                    }
                    if (difference >= 420 && vType == '50') {
                      penalty = 50;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("3");
                    }
                    if (difference >= 480 && vType == '50') {
                      penalty = 60;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("2");
                    }
                    if (difference >= 540 && vType == '50') {
                      penalty = 70;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("1");
                    }
                    if (difference >= 600 && vType == '50') {
                      penalty = 80;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 600 && vType == '50'");
                    }
                    if (difference >= 660 && vType == '50') {
                      penalty = 90;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 660 && vType == '50'");
                    }
                    if (difference >= 720 && vType == '50') {
                      penalty = 100;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 720 && vType == '50'");
                    }
                    if (difference >= 780 && vType == '50') {
                      penalty = 110;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 780 && vType == '50'");
                    }
                    if (difference >= 840 && vType == '50') {
                      penalty = 120;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 840 && vType == '50'");
                    }
                    if (difference >= 900 && vType == '50') {
                      penalty = 130;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 900 && vType == '50'");
                    }
                    if (difference >= 960 && vType == '50') {
                      penalty = 140;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 960 && vType == '50'");
                    }
                    if (difference >= 1020 && vType == '50') {
                      penalty = 150;
                      cardColor = Colors.redAccent.withOpacity(.3);
                      print("difference >= 1020 && vType == '50'");
                    }
                    if (difference >= 70 && difference <= 120) {
                      alertButton = "Logout";
                      trigger = 0;
                      cardColor = Colors.blueAccent.withOpacity(.3);
                      print('difference == $difference');
                      print('if (difference >= 70 && difference <= 119)');
                      print('dateTimeIn == $dateTimeIn');
//                        enabled = false;
                    }
//                    if(DateFormat("H:mm").format(new DateTime.now()) == 18 && vType == '50'){
//                      violation = 500;
//                    }
                    int strvechicleCharge;
                    //   int penaltyAmount=0, excessNoOfHoursFirstDay, excessNoOfHoursLastDay, excessNoOfHoursInBetween, totalNoOfExcessHours, totalChargeAmount=0, excessNoOfHours=0;
                    if (vType == '50') {
                      strvechicleCharge = 10;
                    } else if (vType == '100') {
                      strvechicleCharge = 20;
                    } else {}
                    DateTime now = new DateTime.now();
                    String timeNowHrs = DateFormat.H().format(now);
                    int intTimeNowHrs = int.parse(timeNowHrs);
                    String timeNowMin = DateFormat.m().format(now);
                    int intTimeNowMin = int.parse(timeNowMin);
                    String strTimeNowDay = DateFormat.d().format(now);
                    int intTimeNowDay = int.parse(strTimeNowDay);
                    final diffInHours = dateTimeNow.difference(dateTimeIn).inHours;
                    final diffInDays = dateTimeNow.difference(dateTimeIn).inDays;
                    DateTime dateNow = new DateTime(now.year, now.month, now.day);
                    DateTime timeInDateNow = new DateTime(dateTimeIn.year, dateTimeIn.month, dateTimeIn.day);
                    String strTimeInHrs = DateFormat.H().format(dateTimeIn);
                    int intTimeInHrs = int.parse(strTimeInHrs);
                    String strTimeInMin = DateFormat.m().format(dateTimeIn);
                    int intTimeInMin = int.parse(strTimeInMin);
                    String strTimeInDay = DateFormat.d().format(dateTimeIn);
                    int intTimeInDay = int.parse(strTimeInDay);
                    //final numberOfDays = now.difference(dateTimeIn).inDays;
                    final numberOfDays = intTimeNowDay - intTimeInDay;
                    int penaltyAmount = 0,
                        excessNoOfHoursFirstDay = 0,
                        excessNoOfHoursLastDay = 0,
                        excessNoOfHoursInBetween = 0,
                        totalNoOfExcessHours = 0,
                        totalChargeAmount = 0,
                        totalNoOfHours = 0,
                        excessNoOfHours = 0;
                    if (dateNow.isAfter(timeInDateNow)) {
                      if (intTimeNowHrs >= 25) //Compare if Time IN is greater than 7pm(cut-off time)...
                          {
                        if (intTimeNowMin > 0) {
                          penaltyAmount = (numberOfDays + 1) * 500;
                          print("intTimeNowMin > 0 || intTimeNow >= 19 == TRUE || ubos");
                        } else {
                          penaltyAmount = numberOfDays * 500;
                          print("intTimeNowMin !> 0 || intTimeNow >= 19 == TRUE || ubos");
                        }
                      } else {
                        if (numberOfDays == 0) {
                          penaltyAmount = 1 * 500;
                          print("numberOfDays == 0 TRUE");
                        } else {
                          print("numberOfDays == 0 FALSE");
                          // if(intTimeNowHrs >= 0 && intTimeNowHrs < 8)
                          // {
                          penaltyAmount = (numberOfDays) * 500;
                          //   print("intTimeNowHrs >= 0 && intTimeNowHrs < 8 TRUE");
                          // }
                          // else
                          // {
                          //   penaltyAmount = numberOfDays * 500;
                          //   print("intTimeNowHrs >= 0 && intTimeNowHrs < 8 FALSE");
                          // }
                        }
                      }
                      if (numberOfDays > 2) {
                        // excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                        // excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                        // excessNoOfHoursInBetween = (numberOfDays - 1) * 12;
                        // totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay + excessNoOfHoursInBetween) - 2;
                        // totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                        // print("numberOfDays >= 2 TRUE");
                        if (intTimeNowHrs < 8) {
                          excessNoOfHours = 19 - intTimeInHrs;
                          if (excessNoOfHours >= 2) {
                            print("excessNoOfHours >= 2 TRUE || numberOfDays > 2");
                            excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                            excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                            excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                            totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween) -2;
                            totalNoOfHours= (excessNoOfHoursFirstDay + excessNoOfHoursInBetween);
                            totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                          } else {
                            print("excessNoOfHours >= 2 FALSE || numberOfDays > 2");
                            totalChargeAmount = 0; //ok na
                          }
                        } else {
                          if (intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                              {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 TRUE || numberOfDays > 2");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            } else {
                              print("intTimeNowHrs >= 19 TRUE || numberOfDays > 2");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) ;
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('totalNoOfExcessHours = $totalNoOfExcessHours');
                            }
                          } else {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 FALSE || numberOfDays > 2 && intTimeNowMin > 0 TRUE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours= (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('\t\t OKKK');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursInBetween = $excessNoOfHoursInBetween');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                              // print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                            } else {
                              print("intTimeNowHrs >= 19 FALSE || numberOfDays > 2 && intTimeNowMin > 0 FALSE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('\t\t OKKKKKKK');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursInBetween = $excessNoOfHoursInBetween');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                            }
                          }
                        }
                      }
                      else if (numberOfDays == 2) {
                        if (intTimeNowHrs < 8) {
                          excessNoOfHours = 19 - intTimeInHrs;
                          if (excessNoOfHours > 2) {
                            print("excessNoOfHours >= 2 TRUE || numberOfDays == 2");
                            print('else if (numberOfDays == 2)');
                            totalNoOfExcessHours = (excessNoOfHours + 11) - 2;
                            totalNoOfHours=excessNoOfHours+11;
                            totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            print('totalNoOfExcessHours = $totalNoOfExcessHours');
                            print('totalNoOfHours = $totalNoOfHours');
                            //  print('totalNoOfExcessHours = $totalNoOfExcessHours');
                          } else {
                            print("excessNoOfHours >= 2 FALSE || numberOfDays == 2");
                            totalChargeAmount = 0; //ok na
                          }
                        } else {
                          if (intTimeNowHrs >= 19) //Compare if Time IN is greater than 7pm(cut-off time)...
                              {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 TRUE || numberOfDays == 2 && intTimeNowMin > 0 TRUE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              excessNoOfHoursInBetween = 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            } else {
                              print("intTimeNowHrs >= 19 TRUE || numberOfDays == 2 && intTimeNowMin > 0 FALSE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              excessNoOfHoursInBetween = 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('\t\t\t!OK');
                            }
                          } else {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 FALSE || numberOfDays == 2"); //ok
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              excessNoOfHoursInBetween = 11;
                              if(excessNoOfHoursFirstDay <= 2)
                              {
                                totalNoOfExcessHours = (excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              }
                              else
                              {
                                totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              }
                              totalNoOfHours= (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('\t\t\tOK');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                              print('totalNoOfHours           = $totalNoOfHours');
                              print('totalChargeAmount        = $totalChargeAmount');
                            } else {
                              print("intTimeNowHrsS >= 19 FALSE || numberOfDays == 2"); //ok
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              excessNoOfHoursInBetween = 11;
                              if(excessNoOfHoursFirstDay <= 2)
                              {
                                totalNoOfExcessHours = (excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              }
                              else
                              {
                                totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay) - 2;
                              }

                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursInBetween + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('OKKKKKKKKKKKK');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                              print('totalNoOfHours           = $totalNoOfHours');
                              print('totalChargeAmount        = $totalChargeAmount');
                            }
                          }
                        }
                      }
                      else {
                        if (intTimeNowHrs < 8) {
                          excessNoOfHours = 19 - intTimeInHrs;
                          if (excessNoOfHours > 2) {
                            print("excessNoOfHours >= 2 TRUE");
                            totalNoOfExcessHours = excessNoOfHours - 2;
                            totalNoOfHours=excessNoOfHours;
                            totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                          } else {
                            print("excessNoOfHours >= 2 FALSE");
                            totalChargeAmount = 0; //ok na
                          }
                        } else {
                          if (intTimeNowHrs >= 25) //Compare if Time IN is greater than 7pm(cut-off time)...
                              {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowHrs >= 19 && intTimeNowMin > 0 TRUE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            } else {
                              print("intTimeNowHrs >= 19 && intTimeNowMin > 0 FALSE");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours= (excessNoOfHoursFirstDay + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            }
                          } else {
                            if (intTimeNowMin > 0) {
                              print("intTimeNowMin > 0 TRUE wwww || ubos");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 7);
                              //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              totalNoOfExcessHours =(excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours *strvechicleCharge; //Depende sa no. of wheels
                              print('OKKKKK');
                              print('totalNoOfExcessHours = $totalNoOfExcessHours');
                              print('totalNoOfHours       = $totalNoOfHours');
                              //  print('totalNoOfExcessHours= $totalNoOfExcessHours');
                            } else {
                              print("intTimeNowMin > 10 FALSE || UBOS");
                              excessNoOfHoursFirstDay = 19 - intTimeInHrs;
                              excessNoOfHoursLastDay = (intTimeNowHrs - 8);
                              //excessNoOfHoursInBetween = (numberOfDays - 1) * 11;
                              if(excessNoOfHoursFirstDay <= 2)
                              {
                                totalNoOfExcessHours = excessNoOfHoursLastDay;
                              }
                              else
                              {
                                totalNoOfExcessHours = (excessNoOfHoursFirstDay + excessNoOfHoursLastDay) - 2;
                              }
                              totalNoOfHours=(excessNoOfHoursFirstDay + excessNoOfHoursLastDay);
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('OKKKKK');
                              print('totalNoOfExcessHours     = $totalNoOfExcessHours');
                              print('excessNoOfHoursFirstDay  = $excessNoOfHoursFirstDay');
                              print('excessNoOfHoursLastDay   = $excessNoOfHoursLastDay');
                              print('totalNoOfHours           = $totalNoOfHours');
                            }
                          }
                        }
                      }
                    }
                    else {
                      if (intTimeNowHrs >= 25 && intTimeNowMin >= 1) //Compare if Time IN is greater than 7pm(cut-off time)...
                          {
                        if ((25 - intTimeInHrs) >= 2) {
                          print("19 - intTimeInHrs) >= 2 TRUE || ubos");
                          penaltyAmount = 500;
                          excessNoOfHours = 21 - intTimeInHrs;
                          totalNoOfExcessHours = excessNoOfHours - 2;
                          totalNoOfHours=excessNoOfHours;
                          totalChargeAmount = totalNoOfExcessHours *strvechicleCharge; //Depende sa no. of wheels
                        } else {
                          print("19 - intTimeInHrs) >= 2 FALSE");
                          penaltyAmount = 500;
                          totalChargeAmount = 0;
                        }
                      } else {
                        penaltyAmount = 0;
                        excessNoOfHours = intTimeNowHrs - intTimeInHrs;
                        if (excessNoOfHours >= 2) {
                          if (intTimeNowMin > intTimeInMin) {
                            if (intTimeNowMin > intTimeInMin) {
                              print("intTimeNowMin > intTimeInMin TRUE UBOS");
                              totalNoOfExcessHours = excessNoOfHours - 1;
                              totalNoOfHours=excessNoOfHours+1;
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge;
                              print('KKKKKKKK');
                              print('totalNoOfExcessHours = $totalNoOfExcessHours');
                              print('excessNoOfHours      = $excessNoOfHours');
                              print('totalNoOfHours       = $totalNoOfHours');
                              //Depende sa no. of wheels
                            } else {
                              print("intTimeNowMin > intTimeInMin FALSE UBOS");
                              print('sfsfsdf');
                              totalNoOfExcessHours = excessNoOfHours - 1;
                              totalNoOfHours=excessNoOfHours+1;
                              totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                              print('excessNoOfHours       = $excessNoOfHours');
                              print('totalNoOfExcessHours  = $totalNoOfExcessHours');
                              print('totalNoOfHours        = $totalNoOfHours');
                            }
                          } else {
                            print("intTimeNowMin >= intTimeInMin FALSE UBOS");
                            totalNoOfExcessHours = excessNoOfHours - 2;
                            totalNoOfHours=excessNoOfHours;
                            totalChargeAmount = totalNoOfExcessHours * strvechicleCharge; //Depende sa no. of wheels
                            print('okkkk');
                            print('totalNoOfExcessHours = $totalNoOfExcessHours');
                            print('totalNoOfHours       = $totalNoOfHours');
                            print('excessNoOfHours      = $excessNoOfHours');
                          }
                        } else {
                          totalChargeAmount = 0;
                          print('okay');
                          print("excessNoOfHours >= 2 FALSE ubos");
                        }
                      }
                    }
                    // if(intTimeNowMin > intTimeInMin)
                    // {

                    // }
                    // else
                    // {
                    //   totalNoOfHours = diffInHours;
                    // }
                    // print('Different in Hours: $diffInHours');
                    // print('Total No. Of Hours: $totalNoOfHours');
                    // print("Date Now: ");
                    // print(dateNow);
                    // print("Date Time In: ");
                    // print(timeInDateNow);
                    // print("Time Now: ");
                    // print(timeNow);
                    // print("Time IN Now: ");
                    // print(strTimeIn);
                    // print("No of Days: ");
                    // print(numberOfDays);
                    // print("Penalty: ");
                    // print(penaltyAmount);
                    // print("Excess No Of Hours First Day: ");
                    // print(excessNoOfHoursFirstDay);
                    // print("Excess No Of Hours Last Day: ");
                    // print(excessNoOfHoursLastDay);
                    // print("Excess No Of Hours In Between: ");
                    // print(excessNoOfHoursInBetween);
                    // print("Int Time Now: ");
                    // print(intTimeNowHrs);
                    // print("Int Time In: ");
                    // print(intTimeInHrs);
                    // print("Excess No Of Hours: ");
                    // print(excessNoOfHours);
                    // print("strvechicleCharge: ");
                    // print(strvechicleCharge);
                    // print("Total No Of Excess Hours: ");
                    // print(totalNoOfExcessHours);
                    // print("Total Charge Amount: ");
                    // print(totalChargeAmount);
                    var totalAmount = penalty + num.parse(vType);
                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return CupertinoAlertDialog(
//                                 title: new Text(plateData[index]["d_Plate"]),
//                                 content: new Text(alertText),
                              title: new Text(plateData[index]["plateNumber"]),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text(alertButton),
                                  onPressed: () {
//                                       if(trigger == 0){
//                                         passDataToHistoryWithOutPay(int.parse(plateData[index]["d_id"]),plateData[index]["d_Plate"],dateTimeIn,DateTime.now(),plateData[index]["d_amount"],plateData[index]["d_emp_id"],plateData[index]['d_user'],widget.empId,widget.name,plateData[index]["d_location"]);
//                                       }
//                                       if(trigger == 1){
//                                         passDataToHistoryWithPay(int.parse(plateData[index]["d_id"]),plateData[index]["d_Plate"],dateTimeIn,DateTime.now(),plateData[index]["d_amount"],penalty,plateData[index]["d_emp_id"],plateData[index]['d_user'],widget.empId,widget.name,plateData[index]["d_location"]);
//                                       }
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return CupertinoAlertDialog(
                                          title:
                                          new Text("Are you sure?"),
                                          content: new Text(
                                              "Do you want to log out this plate # ${plateData[index]["plateNumber"]}"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new TextButton(
                                              child: new Text("Yes"),
                                              onPressed: () {
                                                print('WITH PAY UBOS');
                                                if (trigger == 0) {
                                                  passDataToHistoryWithOutPay(
                                                      plateData[index]["id"],
                                                      plateData[index]['uid'],
                                                      plateData[index]["checkDigit"],
                                                      plateData[index]["plateNumber"],
                                                      dateTimeIn,
                                                      DateTime.now(),
                                                      plateData[index]["amount"],
                                                      plateData[index]["empId"],
                                                      plateData[index]["fname"],
                                                      widget.empId,
                                                      widget.empNameFn,
                                                      plateData[index]["location"],
                                                      '0',
                                                      totalNoOfHours,
                                                      '0');
                                                  print('WITHOUT PAY UBOS');
                                                }
                                                if (trigger == 1) {
                                                  //  int p = penaltyAmount + 0;
                                                  passDataToHistoryWithPay(
                                                      plateData[index]['id'],
                                                      plateData[index]['uid'],
                                                      plateData[index]["checkDigit"],
                                                      plateData[index]['plateNumber'],
                                                      dateTimeIn,
                                                      DateTime.now(),
                                                      plateData[index]['amount'],
                                                      penalty.toString(),
                                                      plateData[index]["empId"],
                                                      plateData[index]['fname'],
                                                      widget.empId,
                                                      widget.empNameFn,
                                                      plateData[index]['location'],
                                                      penaltyAmount.toString(),
                                                      totalChargeAmount.toString(),
                                                      totalNoOfExcessHours.toString(),
                                                      totalNoOfHours.toString(),
                                                      '0');
                                                  print('WITH PAY UBOSS');
                                                }
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            new TextButton(
                                              child: new Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                new TextButton(
                                  child: new Text("Edit"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    print(plateData[index]["id"]);
                                    print(plateData[index]["plateNumber"]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateTrans(
                                              id: plateData[index]["id"],
                                              plateNo: plateData[index]["plateNumber"],
                                              username: widget.name)),
                                    );
                                  },
                                ),
                                new TextButton(
                                  child: new Text("Escapee"),
                                  onPressed: enabled
                                      ? () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder:
                                          (BuildContext context) {
                                        // return object of type Dialog
                                        return CupertinoAlertDialog(
                                          title: new Text("Manager's key"),
                                          content: new Column(
                                            children: <Widget>[
                                              new CupertinoTextField(
                                                autofocus: true,
                                                placeholder: "Username",
                                                controller: _managerKeyUser,
                                              ),
                                              Divider(),
                                              new CupertinoTextField(
                                                autofocus: true,
                                                placeholder: "Password",
                                                controller: _managerKeyUserPass,
                                                obscureText: true,
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            new TextButton(
                                              child: new Text("Proceed"),
                                              onPressed: () async {
                                                int totalp=penaltyAmount+500;
//                                                    var res = await db.olManagerLogin(_managerKeyUser.text,_managerKeyUserPass.text);
//                                                    print(res);
                                                var res = await db.ofManagerLogin(_managerKeyUser.text, _managerKeyUserPass.text);
                                                setState(() {
                                                  data = res;
                                                });
                                                if (data.isNotEmpty) {
                                                  _managerKeyUser.clear();
                                                  _managerKeyUserPass.clear();
                                                  Navigator.of(context).pop();
                                                  Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Delinquent(
                                                            id: plateData[index]["id"],
                                                            uid: plateData[index]['uid'],
                                                            checkDigit: plateData[index]["checkDigit"],
                                                            plateNo: plateData[index]["plateNumber"],
                                                            username: widget.name,
                                                            dateTimeIn: dateTimeIn,
                                                            dateTimeNow: DateTime.now(),
                                                            amount: plateData[index]["amount"],
                                                            penalty: penalty,
                                                            empId: plateData[index]["empId"],
                                                            fname: plateData[index]['fname'],
                                                            empIDwid: widget.empId,
                                                            fullName: widget.empNameFn,
                                                            location: plateData[index]["location"],
                                                            penaltyA: 500,
                                                            totCharge: 0,
                                                            excessHr: excessNoOfHours,
                                                            totafHours: totalNoOfHours,
                                                            lostTicket: 0)),
                                                  );
                                                  //   MaterialPageRoute(builder: (context) => Delinquent(id:plateData[index]["id"],fullName:widget.empNameFn,username:widget.name,uid:plateData[index]["uid"],plateNo:plateData[index]["plateNumber"])),
                                                  //
                                                  //   //  passDataToHistoryWithPay(plateData[index]["id"],plateData[index]['uid'],plateData[index]["checkDigit"],plateData[index]["plateNumber"],dateTimeIn,DateTime.now(),plateData[index]["amount"],penalty,plateData[index]["empId"],plateData[index]['fname'],widget.empId,widget.empNameFn,plateData[index]["location"],penaltyAmount,totalChargeAmount,totalNoOfExcessHours);
                                                  //
                                                  // );
                                                }
                                                if (data.isEmpty) {_managerKeyUser.clear();_managerKeyUserPass.clear();
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder:
                                                      (BuildContext
                                                  context) {
                                                    // return object of type Dialog
                                                    return CupertinoAlertDialog(
                                                      title: new Text("Wrong credentials"),
                                                      content:
                                                      new Text("Please check your username and password"),
                                                      actions: <Widget>[
                                                        // usually buttons at the bottom of the dialog
                                                        new TextButton(
                                                          child: new Text("Close"),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                }
                                              },
                                            ),
                                            new TextButton(
                                              child:
                                              new Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                      : null,
                                ),
                                new TextButton(
                                  child: new Text("Reprint"),
                                  onPressed: () {
//                                        couponPrint.sample(plateData[index]["d_Plate"],DateFormat("yyyy-MM-dd").format(dateTimeIn),DateFormat("hh:mm a").format(dateTimeIn),DateFormat("yyyy-MM-dd").format(dateTimeIn.add(new Duration(days: 7))),plateData[index]['d_amount'],"ppd","12","location");
//                                          Navigator.push(
//                                             context,
//                                             MaterialPageRoute(builder: (context) => Reprint(id:plateData[index]["d_id"],fullName:widget.empNameFn,username:widget.name,uid:plateData[index]["d_uid"],plateNo:plateData[index]["d_Plate"])),
//                                          );
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return CupertinoAlertDialog(
                                          title:
                                          new Text("Manager's key"),
                                          content: new Column(
                                            children: <Widget>[
                                              new CupertinoTextField(
                                                autofocus: true,
                                                placeholder: "Username",
                                                controller: _managerKeyUser,
                                              ),
                                              Divider(),
                                              new CupertinoTextField(
                                                autofocus: true,
                                                placeholder: "Password",
                                                controller: _managerKeyUserPass, obscureText: true,
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            new TextButton(
                                              child: new Text("Proceed"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                managerLoginReprint(
                                                    plateData[index]['uid'],
                                                    plateData[index]["checkDigit"],
                                                    plateData[index]["plateNumber"],
                                                    plateData[index]['dateToday'],
                                                    plateData[index]["dateTimeToday"],
                                                    plateData[index]['dateUntil'],
                                                    plateData[index]['amount'],
                                                    plateData[index]["empId"],
                                                    plateData[index]['location']);
                                              },
                                            ),
                                            new TextButton(
                                              child: new Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                new TextButton(
                                  child:
                                  new Text("Logout/Lost of Ticket"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return CupertinoAlertDialog(
                                          title:
                                          new Text("Are you sure?"),
                                          content: new Text(
                                              "Do you want to tag as lost of ticket & log out this plate # ${plateData[index]["plateNumber"]}"),
                                          actions: <Widget>[
                                            // usually buttons at the bottom of the dialog
                                            new TextButton(
                                              child: new Text("Yes"),
                                              onPressed: () {
                                                print('LOST TICKET');
                                                passDataToHistoryWithPay(
                                                    plateData[index]["id"],
                                                    plateData[index]['uid'],
                                                    plateData[index]["checkDigit"],
                                                    plateData[index]["plateNumber"],
                                                    dateTimeIn,
                                                    DateTime.now(),
                                                    plateData[index]["amount"],
                                                    penalty,
                                                    plateData[index]["empId"],
                                                    plateData[index]['fname'],
                                                    widget.empId,
                                                    widget.empNameFn,
                                                    plateData[index]["location"],
                                                    penaltyAmount,
                                                    totalChargeAmount,
                                                    totalNoOfExcessHours,
                                                    totalNoOfHours,
                                                    lostOfTicket);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            new TextButton(
                                              child: new Text("No"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
//                                  new FlatButton(
//                                    child: new Text("Cancellation"),
//                                    onPressed: enabled ? () {
//                                      Navigator.of(context).pop();
//                                      showDialog(
//                                        barrierDismissible: true,
//                                        context: context,
//                                        builder: (BuildContext context) {
//                                          // return object of type Dialog
//                                          return CupertinoAlertDialog(
//                                            title: new Text("Manager's key"),
//                                            content: new Column(
//                                              children: <Widget>[
//
//                                                new CupertinoTextField(
//                                                  autofocus: true,
//                                                  placeholder: "Username",
//                                                  controller: _managerKeyUser,
//                                                ),
//                                                Divider(),
//                                                new CupertinoTextField(
//                                                  autofocus: true,
//                                                  placeholder: "Password",
//                                                  controller: _managerKeyUserPass,
//                                                  obscureText: true,
//                                                ),
//
//                                              ],
//                                            ),
//                                            actions: <Widget>[
//                                              new FlatButton(
//                                                child: new Text("Proceed"),
//                                                onPressed:(){
//                                                  Navigator.of(context).pop();
//                                                  managerCancel(plateData[index]['plateNumber'],plateData[index]["id"]);
//                                                },
//                                              ),
//                                              new FlatButton(
//                                                child: new Text("Close"),
//                                                onPressed:(){
//                                                  Navigator.of(context).pop();
//                                                },
//                                              ),
//                                            ],
//                                          );
//                                        },
//                                      );
//                                    } : null,
//                                  ),
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        color: cardColor,
                        margin: EdgeInsets.all(5),
                        elevation: 0.0,
                        child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              title: Text('$f.Plt No : ${plateData[index]["plateNumber"]}'.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: width / 20),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('     Time In : ' + DateFormat("yyyy-MM-dd hh:mm a").format(dateTimeIn), style: TextStyle(fontSize: width / 32),),
                                  Text('     Time lapse : $timeAg', style: TextStyle(fontSize: width / 32),),
                                  Text('     Vehicle Type : $vtype2', style: TextStyle(fontSize: width / 32),),
                                  Text('     Charge : ' + oCcy.format(totalChargeAmount), style: TextStyle(fontSize: width / 32),),
                                  Text('     Penalty : ' + oCcy.format(penaltyAmount), style: TextStyle(fontSize: width / 32),),
                                  Text('     Trans Code : ' + plateData[index]["checkDigit"], style: TextStyle(fontSize: width / 32),),
                                  Text('     In By : ' + plateData[index]["fname"], style: TextStyle(fontSize: width / 32),),
                                  Text('     Location : ' + plateData[index]["location"], style: TextStyle(fontSize: width / 32),
                                  ),
//                                    Text('     Total : '+oCcy.format(totalAmount),style: TextStyle(fontSize: width/32),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future managerCancel(plateNumber, id) async {
    var res =
    await db.ofManagerLogin(_managerKeyUser.text, _managerKeyUserPass.text);
    setState(() {
      data = res;
    });
    if (data.isNotEmpty) {
      _managerKeyUser.clear();
      _managerKeyUserPass.clear();
      await db.olCancel(id);
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text("Successfully Cancelled"),
            content: new Text("Plate '$plateNumber' successfully removed"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  updateStat(id);
                  getTransData();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    if (data.isEmpty) {
      _managerKeyUser.clear();
      _managerKeyUserPass.clear();
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text("Wrong credentials"),
            content: new Text("Please check your username and password"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getTransData();
    _managerKeyUser = TextEditingController();
    _managerKeyUserPass = TextEditingController();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
