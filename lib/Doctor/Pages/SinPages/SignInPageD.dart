import 'dart:convert';

import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Doctor/Pages/LoadingD.dart';
import 'package:carewise/Doctor/Pages/SourceD.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class SignInDPage extends StatefulWidget {
  const SignInDPage({super.key});

  @override
  State<SignInDPage> createState() => _SignInDPageState();
}

class _SignInDPageState extends State<SignInDPage> {

  //MAP
  Map LanguageContent = {};
  Map DoctorInfo = {};

  //CONTROLLERS
  TextEditingController IdController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  //VARS
  bool showPassword = false;

  String HoverButtonColor = '#3378FF';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 10) , () {
      readJson();
    });
  }
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(width*0.01),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: height,
                  width: width*0.36,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 232, 232).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(height*0.03),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:height*0.3,left: height*0.3,top: height*0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTitle(LanguageContent.isEmpty ? '' : LanguageContent['En']['Sign in'], Colors.black, height*0.085),
                      Padding(
                        padding: EdgeInsets.only(top: height*0.04,bottom: height*0.04),
                        child: Container(
                          height: 0.2,
                          width: width*0.3,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height*0.02,bottom: height*0.02),
                        child: SizedBox(
                          height: height*0.07,
                          width: width*0.3,
                          child: TextField(
                            controller: IdController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.012, bottom: height*0.012, left: width*0.007),
                              filled: true,
                              fillColor: Color.fromARGB(255, 245, 244, 244).withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(height*0.021),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: width*0.005,top: height*0.005),
                                child: Image.asset('assets/icons/face-id.png'),
                              ),
                              labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['ID'],
                              labelStyle: TextStyle(
                                fontFamily: 'H3',
                                fontSize: height*0.02,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height*0.01,bottom: height*0.01),
                        child: SizedBox(
                          height: height*0.07,
                          width: width*0.3,
                          child: TextField(
                            controller: PasswordController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.012, bottom: height*0.012, left: width*0.007),
                              filled: true,
                              fillColor: Color.fromARGB(255, 245, 244, 244).withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(height*0.021),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(right: width*0.005,top: height*0.005),
                                child: Image.asset('assets/icons/password.png'),
                              ),
                              labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Password'],
                              labelStyle: TextStyle(
                                fontFamily: 'H3',
                                fontSize: height*0.02,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: height*0.02,bottom: height*0.01),
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              await FirebaseFirestore.instance.collection(MainCo).doc(IdController.text).snapshots().listen((event) { 
                                if (event.exists) {
                                  if (event.data()!['password'] == PasswordController.text) {
                                    CherryToast.success(title: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Welcome Back Sire'], Colors.black, height*0.025, 1)).show(context);
                                    setState(() {
                                      DoctorInfo = event.data()!;
                                    });
                                    Future.delayed(Duration(seconds: 1), () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoadingDPage(DoctorId: event.data()!['id'],)),
                                      );
                                    });
                                  } else {
                                    CherryToast.error(title: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Password error'], Colors.black, height*0.025, 1)).show(context);
                                  }
                                } else {
                                  CherryToast.error(title: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']["Id doesn't exist..!"], Colors.black, height*0.025, 1)).show(context);
                                }
                              });
                            } catch (e) {
                              CherryToast.error(title: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']["Id doesn't exist..!"], Colors.black, height*0.025, 1)).show(context);
                            }
                          },
                          child: MyButton(LanguageContent.isEmpty ? '' : LanguageContent['En']['Sign in'], height*0.07, width*0.3, HexColor(HoverButtonColor), height*0.02)
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment(-1, 0),
              child: Opacity(
                opacity: 1,
                child: Image.asset('assets/images/Frame 5.png',height: height*0.8,)
              ),
            )
          ],
        ),
      ),
    );
  }

  //Read Json File
   Future<void> readJson() async {
    final String response = await rootBundle.loadString('lib/Data/EngArbFr.json');
    final data = await json.decode(response);
    setState(() {
      LanguageContent = data;
    });
  }
}