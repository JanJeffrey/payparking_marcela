import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'utils/db_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:data_connection_checker/data_connection_checker.dart';

class UploadPage extends StatefulWidget{

  String passData;

  UploadPage({Key key, @required this.passData,}) : super(key: key);

  @override
  _UploadPage createState() => new _UploadPage();
}
class _UploadPage extends State<UploadPage>{
  List hisData;
  List delinquentData;
  List blackListed;
  final db = PayParkingDatabase();
  String uid;
  String checkDigit;
  String plateNumber;
  String dateTimeIn;
  String dateTimeout;
  String amount;
  String penalty;
  String user;
  String empNameIn;
  String outBy;
  String empNameOut;
  String location;
  String penaltyOT;
  String statusNumber = "";
  String statusText = "";
  String statusB;
  String lostTicket;
  String plateno,vtype,ticketNo,transcode,datetime;
  // String d_id;
  // String d_uid;
  // String d_plateNo;
  // String d_dateToday;
  // String d_fullName;
  // String d_secNameC;
  // String d_imgEmp;
  // String d_imgGuard;
  // String d_penaltyA;
  // String d_totCharge;
  // String d_totAmt;
  // String d_dateEscaped;
  // String d_status;
  Future syncTransData() async{
    if (!mounted) return;
    setState(() {
   //  statusNumber = "1/6";
      statusText = "Uploading data";
    });
    //var res = await db.fetchAllHistory();
    var res = await db.fetchAllHistoryfromSqlite();
    var del=await db.fetchAllDelinquent();
    //   var del= await db.syncBlaclisted();
    setState(() {
      hisData = res;
      delinquentData=del;
    });
    olSaveDelinquent();
    if(hisData.isEmpty){
      print("hello");
      //userDownLoad();
    }else{
      for(int i = 0; i < hisData.length; i++){
        uid         = hisData[i]['uid'];
        checkDigit  = hisData[i]['checkDigit'];
        plateNumber = hisData[i]['plateNumber'];
        dateTimeIn  = hisData[i]['dateTimein'];
        dateTimeout = hisData[i]['dateTimeout'];
        amount      = hisData[i]['amount'];
        penalty     = hisData[i]['totalCharge'];
        user        = hisData[i]['user'];
        outBy       = hisData[i]['outBy'];
        location    = hisData[i]['location'];
        penaltyOT   = hisData[i]['penaltyOT'];
        statusB     = hisData[i]['status'];
        lostTicket  = hisData[i]['lostOfTicket'];
        await http.post(Constants.dbSource + "/${Constants.bertingserver}sync_data",body:{
          "uid"           :uid,
          "checkDigit"    :checkDigit,
          "plateNumber"   :plateNumber,
          "dateTimeIn"    :dateTimeIn,
          "dateTimeout"   :dateTimeout,
          "amount"        :amount,
          "penalty"       :penalty,
          "user"          :user,
          "outBy"         :outBy,
          "location"      :location,
          "penalty1"      :penaltyOT,
          "status"        :statusB,
          "lost_of_ticket":lostTicket
        });
        if(i == hisData.length-1){
        //  userDownLoad();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return CupertinoAlertDialog(
                title: new Text("Transactions are successfully uploaded"),
                content: new Text("Press ok to continue"),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new TextButton(
                    child: new Text("Ok"),
                    onPressed: () async {
                   //   String passdata=widget.passData.toString();
                     // if(passdata=='upload'){
                      db.updateHistory();

                      //  db.emptyHistoryTbl();
                   //   }
                      // SharedPreferences.setMockInitialValues({});
                      // SharedPreferences prefs= await SharedPreferences.getInstance();
                      // String value=prefs.getString('download');
                      // print(value);
                      // print(syncData());
                      // if(value!='2'){
                      //   db.updateHistory();
                      // }
                      // if(value=='0'){
                      // print('TRUEEE');
                      // }
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }

    }
  }
  Future olSaveDelinquent() async {


    for(int i=0;i<delinquentData.length;i++) {
      await http.post(
          Constants.dbSource + "/e_parking/olSaveDelinquent", body: {
        "id"         : delinquentData[i]['id'].toString(),
        "uid"        : delinquentData[i]['uid'].toString(),
        "plateNo"    : delinquentData[i]['plateNo'].toString(),
        "dateToday"  : delinquentData[i]['dateToday'].toString(),
        "fullName"   : delinquentData[i]['fullName'].toString(),
        "secNameC"   : delinquentData[i]['secNameC'].toString(),
        "imgEmp"     : delinquentData[i]['imgEmp'].toString(),
        "imgGuard"   : delinquentData[i]['imgGuard'].toString(),
        "penaltyA"   : delinquentData[i]['penaltyA'].toString(),
        "totCharge"  : delinquentData[i]['totCharge'].toString(),
        "totAmt"     : delinquentData[i]['totAmt'].toString(),
        "dateEscaped": delinquentData[i]['dateEscaped'].toString(),
        "status"     : delinquentData[i]['status'].toString(),
        "datetime"   : delinquentData[i]['dateTimeIn'].toString(),
        "transcode"  : delinquentData[i]['checkdigit'].toString(),
        "vtype"      : delinquentData[i]['vtype'].toString(),
        "totalHrs"   : delinquentData[i]['totalHrs'].toString(),
        "excessHrs"  : delinquentData[i]['excessHrs'].toString()
      });
    }
  }

  Future userDownLoad()async{
    setState(() {
      statusNumber = "2/6";
      statusText = "Updating users";
    });

    int count;
    int res = await db.countTblUser();
    count = res;
    print(count);

    await db.emptyUserTbl();
    for(int i = 0; i < count; i++){
      Map dataUser;
      List plateData;
      final response = await http.post(Constants.dbSource + "/e_parking/app_downLoadUser",body:{
        "tohide":"tohide"
      });
      dataUser = jsonDecode(response.body);
      plateData = dataUser['user_details'];

      await db.ofSaveUsers(plateData[i]['d_user_id'],plateData[i]['d_emp_id'],plateData[i]['d_full_name'],plateData[i]['d_username'],plateData[i]['d_password'],plateData[i]['d_usertype'],plateData[i]['d_status']);
      if(i == count-1){
        downloadLocationUser();
      }
    }
  }

  Future downloadLocationUser() async{
    if (!mounted) return;
    setState(() {
      statusNumber = "3/6";
      statusText = "Updating location user";
    });

    int count;
    int res = await db.countTblLocationUser();
    count = res;
//    await db.emptyLocationUserTbl();
    for(int i = 0; i < count; i++) {
      Map dataUser;
      List plateData;
      final response1 = await http.post(Constants.dbSource + "/e_parking/app_downLoadlocation_user", body: {
        "tohide": "tohide"
      });
      dataUser = jsonDecode(response1.body);
      plateData = dataUser['user_details'];
      await db.ofSaveLocationUsers(plateData[i]['d_loc_user_id'],plateData[i]['d_user_id'],plateData[i]['d_location_id'],plateData[i]['d_emp_id']);
      if(i == count-1){
        downloadManager();
      }
    }
  }

  Future downloadManager() async{
    if (!mounted) return;
    setState(() {
      statusNumber = "4/6";
      statusText = "Updating managers";
    });


    int count;
    int res = await db.countTblManager();
    count = res;
    print("heeeeeee"+count.toString());
    await db.emptyManagerTbl();
    for(int i = 0; i < count; i++) {
      Map dataUser;
      List plateData;
      final response1 = await http.post(Constants.dbSource + "/e_parking/app_downLoadManager", body: {
        "tohide": "tohide"
      });
      dataUser = jsonDecode(response1.body);
      plateData = dataUser['user_details'];
      print(plateData);
      await db.ofSaveManagers(plateData[i]['d_emp_id'],plateData[i]['d_username'],plateData[i]['d_password'],plateData[i]['d_usertype'],plateData[i]['d_status']);
      if(i == count-1){
        downloadLocation();
      }
    }
  }

  Future downloadLocation() async{
    if (!mounted) return;
    setState(() {
      statusNumber = "5/6";
      statusText = "Updating locations";
    });

    int count;
    int res = await db.countTblLocation();
    count = res;
    await db.emptyLocationTbl();
    for(int i = 0; i < count; i++) {
      Map dataUser;
      List plateData;
      final response1 = await http.post(Constants.dbSource + "/e_parking/app_downLoadlocation", body: {
        "tohide": "tohide"
      });
      dataUser = jsonDecode(response1.body);
      plateData = dataUser['user_details'];
      await db.ofSaveLocation(plateData[i]['d_location_id'],plateData[i]['d_location'],plateData[i]['d_location_address'],plateData[i]['d_status']);
      if(i == count-1){
        downloadDelinquent();
      }
    }
  }

  Future downloadDelinquent() async{
    if (!mounted) return;
    setState(() {
      statusNumber = "6/6";
      statusText = "Updating delinquents";
    });
    int count,count2;
    int res = await db.countTblDelinquent();
    count = res;
    await db.emptyDelinquent();
    //await db.emptytblDelinquent3();
    for(int i = 0; i < count; i++) {
      Map dataUser;
      List plateData;
      final response1 = await http.post(Constants.dbSource + "/e_parking/app_downloadDelinquent", body: {
        "tohide": "tohide"
      });
      dataUser = jsonDecode(response1.body);
      plateData = dataUser['user_details'];
      await db.ofSaveDelinquent(plateData[i]['d_uid'],plateData[i]['d_plateno'],plateData[i]['d_dateToday'],plateData[i]['d_empName'],plateData[i]['d_secNameC'],plateData[i]['d_imgEmp'],plateData[i]['d_penaltyA'],plateData[i]['d_totCharge'],plateData[i]['d_totAmt'],plateData[i]['dateEscaped']);
      if(i == count-1){
//       Fluttertoast.showToast(
//           msg: "Transactions are successfully uploaded",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIos: 2,
//           backgroundColor: Colors.black54,
//           textColor: Colors.white,
//           fontSize: 16.0
//       );
      }
    }
    for(int i = 0; i < count; i++) {
      Map dataUser;
      List plateData;
      final response1 = await http.post(Constants.dbSource + "/e_parking/app_downloadDelinquent2", body: {
        "tohide": "tohide"
      });
      dataUser = jsonDecode(response1.body);
      plateData = dataUser['user_details'];
      await db.delinquentTrans(plateData[i]['d_uid'],plateData[i]['d_plateno'],plateData[i]['d_vtype'],plateData[i]['d_transcode'],plateData[i]['d_datetimein']);
      // await db.delinquentTrans(plateno, vtype, ticketNo, transcode, datetime);
      // await db.ofSaveDelinquent(plateData[i]['d_uid'],plateData[i]['d_plateno'],plateData[i]['d_dateToday'],plateData[i]['d_empName'],plateData[i]['d_secNameC'],plateData[i]['d_imgEmp'],plateData[i]['d_penaltyA'],plateData[i]['d_totCharge'],plateData[i]['d_totAmt'],plateData[i]['dateEscaped']);
      if(i == count-1){
//       Fluttertoast.showToast(
//           msg: "Transactions are successfully uploaded",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIos: 2,
//           backgroundColor: Colors.black54,
//           textColor: Colors.white,
//           fontSize: 16.0
//       );
      }
    }
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          title: new Text("Successfully uploaded"),
          content: new Text("Press ok to continue"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text("Ok"),
              onPressed: () async {
                String passdata=widget.passData.toString();
                if(passdata=='upload'){
                  //     db.updateHistory();

                  db.emptyHistoryTbl();
                }
                // SharedPreferences.setMockInitialValues({});
                // SharedPreferences prefs= await SharedPreferences.getInstance();
                // String value=prefs.getString('download');
                // print(value);
                // print(syncData());
                // if(value!='2'){
                //   db.updateHistory();
                // }
                // if(value=='0'){
                // print('TRUEEE');
                // }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    print("okna!");
  }

  @override
  void initState(){
    super.initState();
    syncTransData();
//    userDownLoad();
  }
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double setHeight;
    double screenHeight = MediaQuery.of(context).size.height;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    if(isPortrait == true){
      setHeight = screenHeight - 490;
    }else{
      setHeight = screenHeight - 280;
    }
    return new Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height:setHeight,
          ),
          GradientText('Syncing...',
              gradient: LinearGradient(colors: [Colors.deepOrangeAccent, Colors.blue, Colors.pink]),
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center),
          SizedBox(
            height: 40,
          ),
          Center(
            child:SpinKitRing(
              color: Colors.blue,
              size: 80,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          GradientText(statusNumber,
              gradient: LinearGradient(colors: [Colors.deepOrangeAccent, Colors.blue, Colors.pink]),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center),
          SizedBox(
            height: 20,
          ),
          GradientText(statusText,
              gradient: LinearGradient(colors: [Colors.black, Colors.blue, Colors.blueGrey]),
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}


