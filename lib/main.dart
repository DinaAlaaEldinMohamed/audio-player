import 'package:flutter/material.dart';
import 'package:lec1/pages/home_page.dart';

void main() {
twoFer();
  runApp(MyApp());
}
String twoFer({String personName=''}) {
  // Replace the throw call and put your code here
  if(personName==''){
     return 'One for you, one for me.';
  }else{
     return 'One for $personName, one for me.';
  }
 
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
