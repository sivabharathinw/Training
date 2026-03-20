import 'dart:async';

import 'package:flutter/material.dart';
void main(){
  runZonedGuarded((){
    print("hello from zone");
    runApp(MyApp());
  }, (error,stack){
    print("Caught: $error");
  },
    zoneValues: {
      "name": "siva",
      "age":22,
  }
  );
  }
  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return  MaterialApp(
        home:Scaffold(
          body:Center(
            //here we acces the zone value without passing the data
            child:  Text(Zone.current["name"].toString(),style:TextStyle(fontSize: 30,color:Colors.red)),
        ),
      ),
      );

    }
  }


