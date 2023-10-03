import 'package:flutter/material.dart';


class About extends StatefulWidget{
  @override
  _About createState() => new _About();
}
class _About extends State<About>{

  @override
  void initState(){
    super.initState();
  }
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      body:  ListView(
          children: <Widget>[
           Center(
             child: Column(
               children: <Widget>[

                 SizedBox(
                   height: 50,
                 ),
                  Text("App Developers",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                 SizedBox(
                   height: 50,
                 ),
                 CircleAvatar(
                   radius: 100.0,
                   backgroundImage:
                   AssetImage('assets/renan.jpg'),
                   backgroundColor: Colors.transparent,
                 ),
                 SizedBox(
                   height: 10,
                 ),
                 Text("Renan A. Ocoy",style:TextStyle(fontSize: 20),),

                 SizedBox(
                   height: 50,
                 ),
                 CircleAvatar(
                   radius: 110.0,
                   backgroundImage:
                   AssetImage('assets/pj.png'),
                   backgroundColor: Colors.transparent,
                 ),
                 SizedBox(
                   height: 10,
                 ),
                 Text("Paul Jearic P. Niones",style:TextStyle(fontSize: 20),),
                 SizedBox(
                   height: 80,
                 ),

               ],
             ),
           ),
            Text("For mobile app solutions call:09107961118",style:TextStyle(fontSize: 15),),
          ],
      ),
    );
  }
}


