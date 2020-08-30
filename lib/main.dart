import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'SmartParking',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:600920471014:ios:350c8bdecfc6ff4b099227',
      gcmSenderID: '600920471014',
      databaseURL: 'https://smartparking-6a131.firebaseio.com/',
    )
        : const FirebaseOptions(
      googleAppID: '1:600920471014:android:f25032cd84e61250099227',
      apiKey: 'AIzaSyAMgy8Ev_nxxDzTuDs0A_O7Y01Rg7s8sF0',
      databaseURL: 'https://smartparking-6a131.firebaseio.com/',
    ),
  );
  runApp(new MyApp(app: app,));
}


class MyApp extends StatelessWidget {
  MyApp({this.app});
  final FirebaseApp app;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new HomePage(app: app,),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({this.app});
  final FirebaseApp app;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _parkingSlotRef;
  Map<int,int> _slotParkir = new Map<int,int>();

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _parkingSlotRef = database.reference().child('parkingSlot');
    _parkingSlotRef.onChildAdded.listen((Event event){
      setState((){
        _slotParkir[int.tryParse(event.snapshot.key) ?? 0]=event.snapshot.value ?? 0;
        print('parkingSlot added: ${event.snapshot.key} status ${event.snapshot.value}');
      });
    });
    _parkingSlotRef.onChildChanged.listen((Event event) {
      setState(() {
        _slotParkir[int.tryParse(event.snapshot.key) ?? 0]=event.snapshot.value ?? 0;
        print('parkingSlot status changed: ${event.snapshot.key} status ${event.snapshot.value}');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [

            // CONTAINER TULISAN PARKIR PINTAR
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Text(
                "Parkir Pintar",
                style: TextStyle(
                  fontFamily: 'ProximaNova',
                  fontSize: 20.0,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // ROW CONTAINER ANGKA 1 & 2
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 35, 0),
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),


                  Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                        child: Text(
                          "2",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),
                ],
              ),
            ),

            // ROW CONTAINER BOX ANGKA 1 & 2 (SLOT PARKING 1 & 2)
            Container(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: new Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.orange,
                        ),
                        width: 5,
                        height: 100,
                        child: Text(
                          "${(_slotParkir[1] ?? 0) > 0 ? 'occucpied' : 'vacant'}",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),

                  Expanded(
                      child: new Container(
                        child: SizedBox(
                          width: 10,
                          height: 10,
                        ),
                      )),

                  Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.orange,
                        ),
                        width: 5,
                        height: 100,
                        child: Text(
                          "${(_slotParkir[2] ?? 0) > 0 ? 'occucpied' : 'vacant'}",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),
                ],
              ),
            ),

            // ROW CONTAINER ANGKA 3 & 4
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 35, 0),
                        child: Text(
                          "3",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),


                  Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                        child: Text(
                          "4",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),
                ],
              ),
            ),

            // ROW CONTAINER BOX ANGKA 3 & 4 (SLOT PARKING 3 & 4)
            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: new Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.orange,
                        ),
                        width: 5,
                        height: 100,
                        child: Text(
                          "${(_slotParkir[3] ?? 0) > 0 ? 'occucpied' : 'vacant'}",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),

                  Expanded(
                      child: new Container(
                        child: SizedBox(
                          width: 10,
                          height: 10,
                        ),
                      )),

                  Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.orange,
                        ),
                        width: 5,
                        height: 100,
                        child: Text(
                          "${(_slotParkir[4] ?? 0) > 0 ? 'occucpied' : 'vacant'}",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),
                ],
              ),
            ),

            //  CONTAINER ANGKA 5
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 35, 0),
                        child: Text(
                          "5",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),


                  Expanded(
                      child: new Container(
                        padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                        child: Text(
                          "",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),
                ],
              ),
            ),


            //CONTAINER BOX ANGKA 5 (SLOT PARKING 5)
            Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[



                  Expanded(
                      child: new Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.orange,
                        ),
                        width: 5,
                        height: 100,
                        child: Text(
                          "${(_slotParkir[5] ?? 0) > 0 ? 'occucpied' : 'vacant'}",
                          style: TextStyle(
                            fontFamily: 'Proxima_nova',
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        alignment: Alignment.center,
                      )),

                  Expanded(
                      child: new Container(
                        child: SizedBox(
                          width: 10,
                          height: 10,
                        ),
                      )),

                  Expanded(
                      child: new Container(
                        child: SizedBox(
                          width: 10,
                          height: 10,
                        ),
                      )),


                ],
              ),
            ),
          ],
        ));
  }
}