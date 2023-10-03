import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/signature.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'utils/db_helper.dart';

class Delinquent extends StatefulWidget {
  final int id;
  final String plateNo;
  final String fullName;
  final String username;
  final String uid;
  final int penaltyA;
  final int totCharge;
  final int excessHr,totafHours;
  int penalty;
  final dateTimeIn,dateTimeNow;
  final String checkDigit,amount,empId,fname,empIDwid,location;
  int lostTicket;

 // Delinquent({Key key, @required this.id,this.fullName, this.uid, this.plateNo, this.username,this.penaltyA,this.totCharge,this.excessHr}) : super(key: key);
  Delinquent({Key key, @required this.id,this.uid,this.checkDigit,this.plateNo,this.username,this.dateTimeIn,this.dateTimeNow,this.amount,this.penalty,this.empId,this.fname,this.empIDwid,this.fullName,this.location,this.penaltyA,this.totCharge,this.excessHr,this.totafHours,this.lostTicket}) : super(key: key);
  @override
  _Delinquent createState() => _Delinquent();
}
class _Delinquent extends State<Delinquent>{
  final db = PayParkingDatabase();
  final _secNameController = TextEditingController();
  List plateData;
  Future passBlackListedToHistory(id,uid,checkDigit,plateNo,dateTimeIn,dateTimeNow,amount,penalty,user,empNameIn,outBy,empNameOut,location,penaltyOT,totalChargeAmount,totalNoOfExcessHours,totalNoOfHours,lostOfTicket) async{
    String plateNumber = plateNo;
    final dateIn = DateFormat("yyyy-MM-dd : H:mm").format(dateTimeIn);
    final dateNow = DateFormat("yyyy-MM-dd : H:mm").format(dateTimeNow);
    var amountPay = amount;
//      await db.olAddTransHistory(id,uid,checkDigit,plateNumber,dateIn,dateNow,amountPay.toString(),penalty.toString(),user.toString(),outBy.toString(),location.toString());
    await db.addTransHistory(uid,checkDigit,plateNo,dateIn,dateNow,amountPay.toString(), penalty.toString(),user.toString(),empNameIn.toString(),outBy.toString(), empNameOut.toString(),location.toString(),penaltyOT.toString(),totalNoOfExcessHours.toString(),totalChargeAmount.toString(),'1',totalNoOfHours.toString(),lostOfTicket.toString());
    await db.updatePayTranStat(id);
    getTransData();
    Fluttertoast.showToast(
        msg: "Successfully added to Black Listed",
        toastLength: Toast.LENGTH_LONG ,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  bool listStat = false;
  Future getTransData() async {
    listStat = false;
    var res = await db.ofFetchAll();
    setState((){
      plateData = res;
    });
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose(){
    _secNameController.dispose();super.dispose();
  }
  Future saveDelinquent(id,uid,plateNo,dateToday,fullName,secNameC,imgEmp,imgGuard,penaltyA,totcCharge,totAmt,dateEscape,dateTimeIn,checkdigit,vtype,totafhours,excess) async{
    final dateIn = DateFormat("yyyy-MM-dd : H:mm").format(dateTimeIn);
  //   await db.olSaveDelinquent(id,uid,plateNo,dateToday,fullName,secNameC,imgEmp,imgGuard,penaltyA,totcCharge,totAmt,dateEscape,dateTimeIn,checkdigit,vtype,totafhours,excess);
   await db.saveDelinquentToSqlite(id, uid, plateNo, dateToday, fullName, secNameC, imgEmp, imgGuard, penaltyA, totcCharge, totAmt, dateEscape,dateIn,checkdigit,vtype,totafhours,excess);
  }
  Future saveDelinquentTrans(plateno,vtype,ticketNo,transcode,datetime)async{
    await db.delinquentTrans(plateno,vtype,ticketNo,transcode,datetime);
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var _guardSignature = Signature(
      height: 150,
      backgroundColor: Colors.blueGrey,
      onChanged: (points) {
//        print(points);
      },
    );
    var _empSignature = Signature(
      height: 150,
      backgroundColor: Colors.blueGrey,
      onChanged: (points) {
//        print(points);
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Delinquent',style: TextStyle(fontWeight: FontWeight.bold,fontSize: width/28, color: Colors.black),),
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
          physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Text("Plate #: "+widget.plateNo,style: TextStyle(fontSize: width/17)),),
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: new TextField(
            autofocus: false,
            controller: _secNameController,
              decoration: InputDecoration(
              labelText: 'Security Name',
//              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, width/15.0),
//              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
              ),
            ),
          ),
          Divider(
            height: 10,
            color: Colors.transparent,
          ),
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text("Security Signature"),
          ),
          Divider(
            height: height/1000,
            color: Colors.transparent,
          ),
          _guardSignature,
          Padding(
            padding:EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text("Your Signature"),
          ),
          _empSignature,
          Divider(
            height: height/25,
            color: Colors.transparent,
          ),
          Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //SHOW EXPORTED IMAGE IN NEW ROUTE
                  IconButton(
                    icon: const Icon(Icons.check),
                    color: Colors.blue,
                    onPressed: () async {
                      if(_guardSignature.isNotEmpty && _empSignature.isNotEmpty && _secNameController.text.isNotEmpty) {
                        var dateToday = DateFormat("yyyy-MM-dd H:mm:ss").format(new DateTime.now());
                        var guardData = await _guardSignature.exportBytes();
                        var imgGuard = base64.encode(guardData);
                        var empData = await _empSignature.exportBytes();
                        var imgEmp = base64.encode(empData);
                        print(guardData);
                        print(_secNameController.text);
                        print(widget.uid);
                        print(widget.fullName);
                        print(dateToday);
                        print(widget.plateNo);
                        int p=int.parse(widget.penaltyA.toString());  //widget.penaltyA;
                        int c=int.parse(widget.totCharge.toString());
                        int totAmt=p+c;
                        final dateIn = DateFormat("yyyy-MM-dd : H:mm").format(widget.dateTimeIn);
                        setState(() {
                          passBlackListedToHistory(widget.id,widget.uid,widget.checkDigit,widget.plateNo,widget.dateTimeIn,widget.dateTimeNow,widget.amount,widget.penalty,widget.empId,widget.fname,widget.empIDwid,widget.fullName,widget.location,widget.penaltyA,widget.totCharge,widget.excessHr,widget.totafHours,widget.lostTicket);
                       //   saveDelinquentTrans(widget.plateNo.toString(),widget.amount.toString(),widget.uid.toString(),widget.checkDigit.toString(),dateIn);
                           saveDelinquent(widget.id,widget.uid,widget.plateNo,dateToday,widget.fullName,_secNameController.text,imgEmp,imgGuard,widget.penaltyA,widget.totCharge,totAmt,widget.dateTimeNow,widget.dateTimeIn,widget.checkDigit,widget.amount,widget.totafHours,widget.excessHr);
                        });
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialogs
                            return CupertinoAlertDialog(
                              title: new Text("Success"),
                              content: new Text("Plate # mark as delinquent"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    print(imgGuard);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        //                        print(img);
//                        print(data);
//                        Navigator.of(context).push(
//                          MaterialPageRoute(
//                            builder: (BuildContext context) {
//                              return Scaffold(
//                                appBar: AppBar(),
//                                body: Container(
//                                  color: Colors.grey[300],
//                                  child: Image.memory(data),
//                                ),
//                              );
//                            },
//                          ),
//                        );
                      }
                      else{
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return CupertinoAlertDialog(
                              title: new Text("Empty fields"),
                              content: new Text("Please check security field and the sign pad "),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed:(){
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
                  //CLEAR CANVAS
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        return _guardSignature.clear();
                      });
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}