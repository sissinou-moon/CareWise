import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

HexColor MainColor = HexColor('#3378FF');
HexColor SecondColor = HexColor('#4ABEED');
HexColor ThirdColor = HexColor('#FF90BC');

//COLLECTS
String AdminCo = 'Admins';
String MainCo = 'Doctors';
String UsersCo = 'Patients';
String LocationCo = 'Locations';

//THIS USER COORDINATE
final email = FirebaseAuth.instance.currentUser!.email;


Text MyTitle(String title ,Color color, double size) {
  return Text(title, style: TextStyle(color: color, fontSize: size, fontFamily: 'H1'),);
}

Text MyDescription(String desc ,Color color, double size, int maxLines) {
  return Text(desc, style: TextStyle(color: color, fontSize: size, fontFamily: 'H3',letterSpacing: 1),maxLines: maxLines,overflow: TextOverflow.ellipsis,);
}

Text MyText(String text ,Color color, double size) {
  return Text(text, style: TextStyle(color: color, fontSize: size, fontFamily: 'H2',letterSpacing: 1),overflow: TextOverflow.ellipsis,);
}

EdgeInsets MainPadding(double height, double width) {
  return EdgeInsets.only(right: width*0.095, top: height*0.025, bottom: 0, left: width*0.095);
}

InputDecoration MainTextField(double height, double width, String type, bool showPassword, VoidCallback onTap) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(right: width*0.03, top: height*0.012, bottom: height*0.012, left: width*0.03),
    isDense: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(height*0.018),
    ),
    enabled: true,
    suffixIcon: type == 'password' ? showPassword == true ? GestureDetector(onTap: onTap,child: Icon(Icons.visibility_off_outlined)) : GestureDetector(onTap: onTap,child: Icon(Icons.visibility_outlined)) : type == 'email' ? Icon(Icons.email_outlined) : null,
  );
}


GestureDetector MyButton(String text, double height, double width, Color color, double radius) {
  return GestureDetector(
    child: Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black, width: 0.8),
      ),
      child: MyText(text, color == Colors.white ? Colors.black : Colors.white, height/2),
    ),
  );
}

// ignore: non_constant_identifier_names
Expanded MyExpandedRow() {
  return Expanded(
    child: SizedBox(
      width: 1,
    ),
  );
}
Expanded MyExpandedCollumn() {
  return Expanded(
    child: SizedBox(
      height: 1,
    ),
  );
}
