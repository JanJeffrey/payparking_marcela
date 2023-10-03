import 'dart:io';
//import 'package:image_picker/image_picker.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:intl/intl.dart';
//import 'dart:async';
import 'utils/db_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:device_apps/device_apps.dart';
//import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'utils/file_creator.dart';
import 'utils/db_helper.dart';


class ParkTrans extends StatefulWidget {
  final String empId;
  final String name;
  final String empNameFn;
  final String location;

  ParkTrans({Key key, @required this.empId, this.name, this.empNameFn, this.location}) : super(key: key);
  @override
  _ParkTrans createState() => _ParkTrans();
}
class _ParkTrans extends State<ParkTrans>{

  final db = PayParkingDatabase();
  final fileCreate = PayParkingFileCreator();
  File pickedImage;
  bool _isEnabled = true;
  String locationA = "Location";
  var wheel = 0;
  Color buttonBackColorA;
  Color textColorA = Colors.black45;
  Color buttonBackColorB;
  Color textColorB = Colors.black45;
  Color bground4= Colors.transparent;
  Color bground2= Colors.transparent;
  Color buttonBackColorNp;
  bool isSwitched = false;
  List transList;
  List delinquentList;
  List blackListed;
  String plateno,vtype,ticketNo,transcode,datetime;
  var allowCheckDigit = 0;
   setWheelA() {
      setState(() {
        buttonBackColorA = Colors.lightBlue;
        buttonBackColorB = Colors.transparent;
        textColorA = Colors.black45;
        bground2 = Colors.lightBlue;
        bground4= Colors.transparent;
        wheel = 50;
      });
  }

   setWheelB() {
    setState(() {
      buttonBackColorB = Colors.lightBlue;
      buttonBackColorA = Colors.transparent;
      textColorB = Colors.black45;
      bground4 = Colors.lightBlue;
      bground2= Colors.transparent;
      wheel = 100;
    });
  }

  Future getTransData() async {
    // listStat = false;
    var res = await db.ofFetchAll();
    setState((){
      transList = res;
    });
  }
  List<Widget> _getList() {
     String location = widget.location;
     print('Location length : ${location.length}');
     var locCount = location.split(",").length;
     var locSplit = location.split(",");
     var counter  = locCount ;
      counter = counter-1;
     List<Widget> temp = [];
    for(var q = 0; q < locCount; q++) {
      temp.add(
        TextButton(
          // child: new Text('Basement'),
          child: new Text(locSplit[q]),
          onPressed: () {
            setState(() {
              Navigator.of(context, rootNavigator: true).pop();
              //get location
              //  locationA = locSplit[0];
              locationA = locSplit[q].trim();
              print(locationA);
            });
          },
        ),
      );
      if(q >=counter){
        if(q >=counter){
          temp.add(
            TextButton(
              child: new Text("Close "),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                locationA = 'Location';
              },
            ),
          );
        }
      }
    }
    return temp;
  }

//  Future trapLocation() async{
//    var res = await db.trapLocation(widget.empId);
//    if(res == true){
//       _isEnabled = false;
//      showDialog(
//        barrierDismissible: false,
//        context: context,
//        builder: (BuildContext context) {
//          // return object of type Dialog
//          return CupertinoAlertDialog(
//            title: new Text("Location Problem"),
//            content: new Text("This user has no location yet please contact your admin for location setup"),
//            actions: <Widget>[
//              // usually buttons at the bottom of the dialog
//              new FlatButton(
//                child: new Text("Close"),
//                onPressed:(){
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
//          );
//        },
//      );
//    }
//  }

   void addLocation() async{
       showDialog(
         barrierDismissible: true,
         context: context,
         builder: (BuildContext context) {
           // return object of type Dialog
           return CupertinoAlertDialog(
             title: Text('Add Location'),
             actions: _getList(),
           );
         },
       );
  }

//  Future pickImage() async{
//    plateNoController.clear();
//    String platePattern = r"([A-Z|\d]+[\s|-][A-Z\d]+)"; //platenumber regex
////    String platePattern =  r"([A-Z|\d]+[\s|-][0-9]+)";
//    RegExp regEx = RegExp(platePattern);
//    String platePatternNew;
//    var _imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
//    setState(() {
//      pickedImage = _imageFile;
//    });
//    if(_imageFile!=null){
//      File croppedFile = await ImageCropper.cropImage(
//          sourcePath: _imageFile.path,
//          aspectRatioPresets: [
//            CropAspectRatioPreset.square,
//            CropAspectRatioPreset.ratio3x2,
//            CropAspectRatioPreset.original,
//            CropAspectRatioPreset.ratio4x3,
//            CropAspectRatioPreset.ratio16x9
//          ],
//          androidUiSettings: AndroidUiSettings(
//              toolbarTitle: 'Cropper',
//              toolbarColor: Colors.white,
//              toolbarWidgetColor: Colors.black,
//              initAspectRatio: CropAspectRatioPreset.ratio16x9,
//              lockAspectRatio: false),
//          iosUiSettings: IOSUiSettings(
//            minimumAspectRatio: 1.0,
//          )
//      );
//
//      setState(() {
//        _imageFile = croppedFile ?? _imageFile;
//      });
//      if(croppedFile!=null){
//      final image = FirebaseVisionImage.fromFile(croppedFile);
//        TextRecognizer recognizedText = FirebaseVision.instance.textRecognizer();
//        VisionText readText = await recognizedText.processImage(image);
//        if(regEx.hasMatch(readText.text)){
////          print(true);
//          platePatternNew = readText.text;
//          if(this.mounted){
//            setState(() {
////              print(regEx.firstMatch(platePatternNew).group(0));
//              plateNoController.text = regEx.firstMatch(platePatternNew).group(0);
//              recognizedText.close();
//            });
//          }
//        }
//        else{
//          print(false);
//        }
//      }else{
//        print('No cropped image');
//      }
//    }else{
//      print('No image');
//    }
//  }

  TextEditingController plateNoController = TextEditingController();
  void confirmed()async{
    //var res = await db.validatePlateNumber(plateNoController.text);
    var del= await db.fetchBlacklisted(plateNoController.text);
    setState(() {
   //   delinquentList = res;
      blackListed=del;
    });

    if(isSwitched == false && plateNoController.text == "" || locationA == "Location") {
    }else if(isSwitched==false && blackListed.isNotEmpty){
      for(int i=0;i<blackListed.length;i++){
        ticketNo   = blackListed[i]['uid'];
        plateno    = blackListed[i]['plateNo'];
        vtype      = blackListed[i]['vtype'];
        transcode  = blackListed[i]['transcode'];
        datetime   = blackListed[i]['datetime'];
      }
      DateTime datetimenow=DateTime.now();
      final str_datetimenow = DateFormat("yyyy-MM-dd : H:mm").format(datetimenow);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(

            title: new Text("Warning! BlackListed"),
            content: new Text("Print Delinquent Details"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
             new TextButton(
                 child:new Text("Yes"),
              onPressed:() async {
              await fileCreate.transactionTypeFunc('print_delinquent');
              await fileCreate.delinquentTrans(str_datetimenow,plateno,vtype,ticketNo,transcode,datetime);
              DeviceApps.openApp("com.example.cpcl_test_v1").then((_) {
              });
             }
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
      // return CupertinoAlertDialog()
        // Fluttertoast.showToast(
        //     msg: "Plate Number is Black Listed!",
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIos: 2,
        //     backgroundColor: Colors.white,
        //     textColor: Colors.red,
        //     fontSize: 16.0
        // );
    }
    else {
      if(wheel == 0){
      }else{
          saveData();
      }
     }
   }

  create(int x){
    var arr= [];
    var y=x.toString();
    y.runes.forEach((int rune){
      var character = new String.fromCharCode(rune);
      arr.add(character);
    });
    odd(){
      int size= arr.length;
      var arr1=[];
      int i=1;
      int sum = 0;
      while(i<size){
        arr1.add(arr[i]);
        i+=2;
      }
      for(int p=0;p<arr1.length;p++){
        sum+=int.parse(arr1[p]);
      }
      return(sum*3);
    }
    even(){
      int size= arr.length;
      var arr1=[];
      int i=0;
      int sum = 0;
      while(i<size){
        arr1.add(arr[i]);
        i+=2;
      }
      for(int p=0;p<arr1.length;p++){
        sum+=int.parse(arr1[p]);
      }
      return(sum);
    }
    int total=odd()+even();
    int cv1=0;
    int cv2=0;
    while (cv1<total)
    {
      cv1+=10;
      if (cv1>=total)
      {
        cv2=cv1;
      }
    }
    int n=cv2-total;
    return x.toString()+""+n.toString();
  }

  void saveData() async{
      var uid = DateFormat("yyMMdHms").format(new DateTime.now());
      String plateNumber;
      var year = new DateFormat("yy").format(new DateTime.now());
      var month = new DateFormat("MM").format(new DateTime.now());
      var day = DateFormat("dd").format(new DateTime.now());
      var hour = DateFormat("H").format(new DateTime.now());
      var minute = DateFormat("mm").format(new DateTime.now());
      var second = DateFormat("s").format(new DateTime.now());
      var today = new DateTime.now();
      var dateToday = DateFormat("yyyy-MM-dd").format(new DateTime.now());
      var dateTimeToday = DateFormat("H:mm").format(new DateTime.now());
      var dateUntil = DateFormat("yyyy-MM-dd").format(today.add(new Duration(days: 7)));
      String amount = wheel.toString();
      var stat = 1;
      var empId = widget.empId;
      var fName = widget.empNameFn;
//    var dateTodayP = DateFormat("yyyy-MM-dd").format(new DateTime.now());
//    var dateTimeTodayP = DateFormat("jm").format(new DateTime.now());
//    var dateUntilP = DateFormat("yyyy-MM-dd").format(today.add(new Duration(days: 7)));
      //check digit
      var checkDigitNum = int.parse('$year$month$day$hour$minute$second');
      var checkDigitResult = create(checkDigitNum);
      //check digit
      if(isSwitched == true){
        plateNumber = checkDigitResult;
        print(plateNumber);
      }if(isSwitched == false ){
        plateNumber = plateNoController.text;
        print(plateNumber);
      }
        String locationAnew = locationA;
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
          // return object of type Dialog
          return CupertinoAlertDialog(
            title: new Text("Hello"),
            content: new Text("Press Proceed to print ticket"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Proceed"),
                onPressed: () async{
                  Navigator.of(context).pop();
                  plateNoController.text = "";
//                  await db.olSaveTransaction(uid,checkDigitResult,plateNumber,dateToday,dateTimeToday,dateUntil,amount,user,stat,locationAnew);
                  await db.ofSaveTransaction(uid,checkDigitResult,plateNumber,dateToday,dateTimeToday,dateUntil,amount,empId,fName,stat,locationAnew);
//                  await db.olSendTransType(widget.empId,'ticket');
                  await fileCreate.transactionTypeFunc('print_coupon');
                  await fileCreate.transactionsFunc(uid,checkDigitResult,plateNumber,dateToday,dateTimeToday,dateUntil,amount,empId,locationAnew);
                  DeviceApps.openApp("com.example.cpcl_test_v1").then((_) {
                  });
                  Fluttertoast.showToast(
                      msg: "Successfully added to transactions",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 2,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
//                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      locationA = "Location";
  }

  @override
  void initState(){
    super.initState();
//    trapLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final ButtonStyle flatButtonStyle4wheels = TextButton.styleFrom(
        primary: Colors.lightBlue,
        onSurface: Colors.lightBlue,
        backgroundColor: bground4,
        minimumSize: Size(88, 36),
        padding: EdgeInsets.symmetric(horizontal: width/15.0,vertical: 20.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            side: BorderSide(color: Colors.lightBlue)
        )
    );
    final ButtonStyle flatButtonStyle2wheels = TextButton.styleFrom(
        primary: Colors.lightBlue,
        onSurface: Colors.lightBlue,
        backgroundColor: bground2,
        minimumSize: Size(88, 36),
        padding: EdgeInsets.symmetric(horizontal: width/15.0,vertical: 20.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            side: BorderSide(color: Colors.lightBlue)
        )
    );
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
        primary: Colors.lightBlue,
        onSurface: Colors.lightBlue,
        // backgroundColor: bground2,
        minimumSize: Size(88, 36),
        padding: EdgeInsets.symmetric(horizontal: width/15.0,vertical: 20.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
            side: BorderSide(color: Colors.lightBlue)
        )
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text('Park Me',style: TextStyle(fontWeight: FontWeight.bold,fontSize: width/28, color: Colors.black),),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: () {},
            child: Text(widget.name.toString(),style: TextStyle(fontSize: width/36,color: Colors.black),),
          ),
        ],
      ),
      body: ListView(
//          physics: BouncingScrollPhysics(),
          children: <Widget>[
//      SingleChildScrollView(
//        scrollDirection: Axis.horizontal,
//        child: Row(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
//                child: MaterialButton(
//                  height: 40.0,
//                  onPressed:(){},
//                  child:FlatButton.icon(
//                    label: Text('Open Camera',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0, color: Colors.lightBlue),),
//                    splashColor: Colors.lightBlue,
//                    icon: Icon(Icons.camera_alt, color: Colors.lightBlue,),
//                    padding: EdgeInsets.all(14.0),
//                    shape: RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(35.0),
//                        side: BorderSide(color: Colors.lightBlue)
//                    ),
//                    onPressed:(){
//                      pickImage();
//                    },
//                  ),
//                ),
//              ),
//            ],
//        ),
//      ),

          Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
              child: new TextFormField(
               controller:plateNoController,
               autofocus: false,
               textCapitalization: TextCapitalization.sentences,
               enabled: _isEnabled,
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
          Divider(
            color: Colors.transparent,
            height: 15.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child:Text('Vehicle Type & Location',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black45),),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child:Column(
                children: <Widget>[
                Text("No Plate #",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black45),),
                Divider(
                height: 20.0,
                color: Colors.transparent,
               ),
                Transform.scale( scale: 3.0,
                 child: Switch(

                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                         if(isSwitched == true){
                           _isEnabled = false;
                           plateNoController.clear();
                         }else{
                           _isEnabled = true;
                         }
                     });
                    },
                    activeTrackColor: Colors.lightBlueAccent.withOpacity(0.3),
                    activeColor: Colors.lightBlue,
                  ),
                 ),

                  Text("   "),
                  TextButton.icon(
                    label: Text('4 wheels'.toString(),style: TextStyle(fontSize: width/33.0, color: textColorA),),
                    style: flatButtonStyle4wheels,
                    icon: Icon(Icons.directions_car, color: textColorA,size: width/20.0,),
                    // splashColor: Colors.lightBlue,
                    // color: buttonBackColorB,
                    // icon: Icon(Icons.directions_car, color: textColorA,size: width/20.0,),
                    // padding: EdgeInsets.symmetric(horizontal: width/15.0,vertical: 20.0),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: new BorderRadius.circular(35.0),
                    //     side: BorderSide(color: Colors.lightBlue)
                    // ),
                    onPressed:(){
                      setWheelB();
                    },
                  ),
                Text("   "),
                  TextButton.icon(
                    label: Text('2 wheels'.toString(),style: TextStyle(fontSize: width/33.0, color: textColorB),),
                    style: flatButtonStyle2wheels,
                    icon: Icon(Icons.motorcycle, color: textColorB,size: width/20.0,),
                    // splashColor: Colors.lightBlue,
                    // color: buttonBackColorA,
                    // icon: Icon(Icons.motorcycle, color: textColorB,size: width/20.0,),
                    // padding: EdgeInsets.symmetric(horizontal:width/15.0,vertical: 20.0),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: new BorderRadius.circular(35.0),
                    //     side: BorderSide(color: Colors.lightBlue)
                    // ),
                    onPressed:(){
                      setWheelA();
                    },
                  ),
                Text("   "),
                  TextButton.icon(
                    label: Text(locationA.toString(),style: TextStyle(fontSize: width/33.0, color: Colors.black45),),
                    style: flatButtonStyle,
                    icon: Icon(Icons.location_on, color: Colors.black45,size: width/20.0,),

                    // splashColor: Colors.lightBlue,
                    // icon: Icon(Icons.location_on, color: Colors.black45,size: width/20.0,),
                    // padding: EdgeInsets.symmetric(horizontal:width/15.0,vertical: 20.0),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: new BorderRadius.circular(35.0),
                    //     side: BorderSide(color: Colors.lightBlue)
                    // ),
                    onPressed: addLocation,
                  ),
              ]),
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