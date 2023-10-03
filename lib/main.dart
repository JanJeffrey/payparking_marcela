import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login.dart';
import 'delinquent.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PayParking Login',
//      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: SignInPage(),
      //MyApp2(),
//        home:Delinquent(),
    );
  }
}

// na comment nako kining naa sa babaw...
    // var res = await checkIfConnectedToNetwork();
    // if (res == 'error') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ErrorScreen()),
    //   );
    // } else if (res == 'errornet') {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => NointernetScreen()),
    //   );
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => LoginScreen()),
    //   );
    // }
  // }
  // Future<void> checkLogIn()async{
  //   var user='';
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   user=prefs.getString('empidKey') ?? '';
  //   bool status=prefs.getBool('isLoggedIn') ?? false;
  //   if(status){
  //     print('trueeeee');
  //     print(user);
  //     print(status);
  //     Navigator.of(context).pop();
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomeT(logInData:user)),
  //     );
  //   }else{
  //     print('falseeee');
  //     print(status);
  //     print(user);
  //     Navigator.of(context).pop();
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => SignInPage()),
  //     );
  //   }
  // }
//kini pd naa sa babaw...


  // Future<void> _deviceDetails() async {
  //   final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
  //   try {
  //     if (Platform.isAndroid) {
  //       var build = await deviceInfoPlugin.androidInfo;
  //       deviceName = build.model;
  //       identifier = build.androidId;
  //
  //       GlobalVariables.deviceInfo = "$deviceName $identifier";
  //       GlobalVariables.readdeviceInfo = "${build.brand} ${build.device}";
  //
  //       //UUID for Android
  //     } else if (Platform.isIOS) {
  //       var data = await deviceInfoPlugin.iosInfo;
  //
  //       deviceName = data.name;
  //       identifier = data.identifierForVendor;
  //       GlobalVariables.deviceInfo = "$deviceName $identifier";
  //       GlobalVariables.readdeviceInfo = "${data.utsname.machine}";
  //       //UUID for iOS
  //     }
  //   } on PlatformException {
  //     print('Failed to get platform version');
  //   }
  // }
// }
