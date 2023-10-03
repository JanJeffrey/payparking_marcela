import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'syncing.dart';
import 'utils/db_helper.dart';


class Reprint extends StatefulWidget {
  final String id;
  final String plateNo;
  final String fullName;
  final String username;
  final String uid;

  Reprint({Key key, @required this.id,this.fullName, this.uid, this.plateNo, this.username}) : super(key: key);
  @override
  _Delinquent createState() => _Delinquent();
}
class _Delinquent extends State<Reprint>{
  final db = PayParkingDatabase();
  final _secNameController = TextEditingController();


  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    _secNameController.dispose();
    super.dispose();
  }

  Future saveDelinquentReprint(id,uid,plateNo,dateToday,fullName,secNameC,imgEmp,imgGuard,penaltyA,totCharge,dateEscape) async{
    int totAmt=penaltyA+totCharge;
 //   await db.olSaveDelinquent(id,uid,plateNo,dateToday,fullName,secNameC,imgEmp,imgGuard,penaltyA,totCharge,totAmt,dateEscape);
  }

  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var _guardSignature = Signature(
      height: 150,
      backgroundColor: Colors.blueGrey,
      onChanged: (points) {
      //print(points);
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Reprint',style: TextStyle(fontWeight: FontWeight.bold,fontSize: width/28, color: Colors.black),),
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
            child: Text("Plate #: "+widget.plateNo,style: TextStyle(fontSize: width/17)),
          ),
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
                      if(_guardSignature.isNotEmpty && _secNameController.text.isNotEmpty) {
                        var dateToday = DateFormat("yyyy-MM-dd H:mm:ss").format(new DateTime.now());
                        var guardData = await _guardSignature.exportBytes();
                        var imgGuard = base64.encode(guardData);
                        print(_secNameController.text);
                        print(widget.uid);
                        print(widget.fullName);
                        print(dateToday);
                        print(widget.plateNo);
                        print(imgGuard);
//                        saveDelinquent(widget.id,widget.uid,widget.plateNo,dateToday,widget.fullName,_secNameController.text,imgGuard);
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return CupertinoAlertDialog(
                              title: new Text("Empty fields"),
                              content: new Text("Please check security field and the sign pad"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new TextButton(
                                  child: new Text("Close"),
                                  onPressed: () {
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