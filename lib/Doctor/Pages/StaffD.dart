import 'dart:convert';

import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Objects/Stuff.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class StaffDPage extends StatefulWidget {
  Map DoctorInfo;
  StaffDPage({super.key, required this.DoctorInfo});

  @override
  State<StaffDPage> createState() => _StaffDPageState();
}

class _StaffDPageState extends State<StaffDPage> {

  //DATE
  DateTime NowaDay = DateTime.now();
  DateTime SelectedDate = DateTime.now();

  //MAP
  Map LanguageContent = {};
  Map Messages = {};

  //CONTROLLERS
  final MesgController = TextEditingController();
  final FirstNameController = TextEditingController();
  final EmailController = TextEditingController();
  final LastNameController = TextEditingController();
  final PasswordController = TextEditingController();

  //LISTS
  List AllStuff = [];
  List<String> Sexe = [
    'male',
    'female',
  ];

  //VARS
  int MessagesLength = 0;
  String StuffSexe = 'male';
  String StuffId = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 10), () {
      readJson();
      FetchMessages();
      FtechAllStuffs();
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //Provider.of<LanguageProvider>(context, listen: false).Language

    return Container(
      padding: EdgeInsets.all(height*0.03),
      height: height,
      width: width*0.85,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(right: width*0.01,top:height*0.02,left: width*0.01),
            height: height*0.6,
            width: width*0.5,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(height*0.03),
              border: Border.all(width: 1,color: Colors.black)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {

                        },
                        child: MyText(LanguageContent.isEmpty ? '' : LanguageContent['En']['Stuff Team'], Colors.white, height*0.03)
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.05),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: width*0.15,
                        child: MyDescription('Id', Colors.white.withOpacity(0.6), height*0.017,1)
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: width*0.09,
                        child: MyDescription('Email', Colors.white.withOpacity(0.6), height*0.017,1)
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: width*0.15,
                        child: MyDescription('Name', Colors.white.withOpacity(0.6), height*0.017,1)
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: width*0.08,
                        child: MyDescription('State', Colors.white.withOpacity(0.6), height*0.017,1)
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.015),
                  child: Divider(color: Colors.white.withOpacity(0.2),height: 0.5,),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height*0.015),
                  child: SizedBox(
                    height: height*0.4,
                    width: width*0.5,
                    child: AllStuff.isEmpty ? Lottie.asset('assets/animations/708791546726.json') : ListView.builder(
                      itemCount: AllStuff.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.02,top: height*0.02),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: width*0.15,
                                    child: MyDescription(AllStuff[index]['id'], Colors.white, height*0.017,1)
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: width*0.15,
                                    child: MyDescription(AllStuff[index]['email'], Colors.white, height*0.017,1)
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: width*0.08,
                                    child: MyDescription('${AllStuff[index]['firstname']} ${AllStuff[index]['lastname']}', Colors.white, height*0.017,1)
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: width*0.08,
                                    child: AllStuff[index]['state'] ? Row(
                                      children: [
                                        SizedBox(width: width*0.02,),
                                        Container(
                                          height: height*0.02,
                                          width: height*0.02,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: MainColor,
                                          ),
                                        ),
                                      ],
                                    ) : Row(
                                      children: [
                                        SizedBox(width: width*0.02,),
                                        Container(
                                          height: height*0.02,
                                          width: height*0.02,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(),
                              child: Divider(color: Colors.white.withOpacity(0.2),height: 0.5,),
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width*0.02),
            child: Container(
              height: height*0.6,
              width: width*0.23,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(height*0.03),
                border: Border.all(width: 1,color: Colors.black),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: height*0.005,bottom: height*0.005,left: width*0.005,right: width*0.005),
                    height: height*0.548,
                    width: width*23,
                    child: ListView.builder(
                      itemCount: Messages.length,
                      itemBuilder: (context, index) {
                        final data = Messages['${index+1}'];
                        if (data['from'] == widget.DoctorInfo['id']) {
                          return Padding(
                            padding: EdgeInsets.only(top: height*0.015),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: height*0.005,bottom: height*0.005,left: width*0.005,right: width*0.005),
                                  width: data['msg'].toString().length > 20 ? width*0.1 : width*0.04,
                                  decoration: BoxDecoration(
                                    color: widget.DoctorInfo['sexe'] == 'female' ? ThirdColor : MainColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(height*0.02),
                                      topLeft: Radius.circular(height*0.02),
                                      bottomLeft: Radius.circular(height*0.02), 
                                    ),
                                  ),
                                  child: MyDescription(data['msg'], Colors.black, height*0.021, 30),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(top: height*0.015),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: height*0.005,bottom: height*0.005,left: width*0.005,right: width*0.005),
                                  width: data['msg'].toString().length > 20 ? width*0.1 : width*0.04,
                                  decoration: BoxDecoration(
                                    color: SecondColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(height*0.02),
                                      topLeft: Radius.circular(height*0.02),
                                      bottomRight: Radius.circular(height*0.02), 
                                    ),
                                  ),
                                  child: MyDescription(data['msg'], Colors.black, height*0.021, 30),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: height*0.045,
                    width: width*0.23,
                    child: TextField(
                      controller: MesgController,
                      style: TextStyle(
                        fontSize: height*0.02,
                        fontFamily: 'H3',
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: width*0.01,bottom: height*0.008),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(height*0.03),
                            bottomLeft: Radius.circular(height*0.03),
                          )
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 216, 215, 215).withOpacity(0.2),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            SendMesg();
                          },
                          child: Icon(Icons.send,size: height*0.025,color: MainColor,)
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width*0.02),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context, 
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        height: height*0.6,
                        width: width*0.2,
                        child: Column(
                          children : [
                            MyText(LanguageContent.isEmpty ? '' : LanguageContent['En']['Add Member'], Colors.black, height*0.035),
                            Padding(
                              padding: EdgeInsets.only(top: height*0.02,bottom: height*0.01,right: width*0.01,left: width*0.01),
                              child: TextField(
                                controller: FirstNameController,
                                style: TextStyle(
                                  fontFamily: 'H3',
                                  fontWeight: FontWeight.w400,
                                  fontSize: height*0.022,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.025, bottom: height*0.025, left: width*0.007),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(height*0.02),
                                  ),
                                  enabled: true,
                                  labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['First Name'],
                                  labelStyle: TextStyle(
                                    fontFamily: 'H3',
                                    fontWeight: FontWeight.w400,
                                    fontSize: height*0.021,
                                  )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.01,right: width*0.01,left: width*0.01),
                              child: TextField(
                                controller: LastNameController,
                                style: TextStyle(
                                  fontFamily: 'H3',
                                  fontWeight: FontWeight.w400,
                                  fontSize: height*0.022,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.025, bottom: height*0.025, left: width*0.007),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(height*0.02),
                                  ),
                                  enabled: true,
                                  labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Last Name'],
                                  labelStyle: TextStyle(
                                    fontFamily: 'H3',
                                    fontWeight: FontWeight.w400,
                                    fontSize: height*0.021,
                                  )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.01,right: width*0.01,left: width*0.01),
                              child: TextField(
                                controller: EmailController,
                                style: TextStyle(
                                  fontFamily: 'H3',
                                  fontWeight: FontWeight.w400,
                                  fontSize: height*0.022,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.025, bottom: height*0.025, left: width*0.007),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(height*0.02),
                                  ),
                                  enabled: true,
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontFamily: 'H3',
                                    fontWeight: FontWeight.w400,
                                    fontSize: height*0.021,
                                  )
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.01,right: width*0.01,left: width*0.01),
                              child: TextField(
                                controller: PasswordController,
                                style: TextStyle(
                                  fontFamily: 'H3',
                                  fontWeight: FontWeight.w400,
                                  fontSize: height*0.022,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.025, bottom: height*0.025, left: width*0.007),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(height*0.02),
                                  ),
                                  enabled: true,
                                  labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Password'],
                                  labelStyle: TextStyle(
                                    fontFamily: 'H3',
                                    fontWeight: FontWeight.w400,
                                    fontSize: height*0.021,
                                  )
                                ),
                              ),
                            ),
                            Container(
                              width: width*0.18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height*0.02),
                                border: Border.all(width: 0.8),
                              ),
                              child: DropdownButton( 
                                // Initial Value 
                                value: StuffSexe, 
                              
                                // Down Arrow Icon 
                                icon: const Icon(Icons.keyboard_arrow_down), 
                              
                                //
                                underline: const Divider(color: Colors.transparent,),  
                                //borderRadius
                                borderRadius: BorderRadius.circular(height*0.02),
                              
                                // Array list of items 
                                items: Sexe.map((String items) { 
                                  return DropdownMenuItem( 
                                    value: items, 
                                    child: Row(
                                      children: [
                                        SizedBox(width: width*0.01,),
                                        Text(items),
                                      ],
                                    ),
                                  ); 
                                }).toList(), 
                                // After selecting the desired option,it will 
                                // change button value to selected value 
                                onChanged: (String? newValue) {  
                                  setState(() { 
                                    StuffSexe = newValue!; 
                                  }); 
                                  print(StuffSexe);
                                }, 
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: height*0.03,right: width*0.01,left: width*0.01),
                              child: GestureDetector(
                                onTap: () {
                                  String sId = '${FirstNameController.text.trim()[0].toUpperCase()}${FirstNameController.text.trim()[1].toUpperCase()}${SelectedDate.day}${LastNameController.text.trim()[0].toUpperCase()}${LastNameController.text.trim()[1].toUpperCase()}${SelectedDate.month}${SelectedDate.hour}'; 
                                  setState(() {
                                    StuffId = sId;
                                  });
                                  final NewStuff = Stuff(id: sId, firstname: FirstNameController.text.trim(), lastname: LastNameController.text.trim(), email: EmailController.text.trim(), password: PasswordController.text.trim(), sexe: StuffSexe, Did: widget.DoctorInfo['id'], state: false);
                                  AddNewMember(NewStuff);
                                  Navigator.of(context).pop();
                                },
                                child: MyButton(LanguageContent.isEmpty ? '' : LanguageContent['En']['Add Member'], height*0.07, width*0.18, MainColor, height*0.02)
                              ),
                            ),
                          ],
                        ),
                      )
                    );
                  }
                );
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: width*0.015,left: width*0.015),
                height: height*0.6,
                width: width*0.05,
                decoration: BoxDecoration(
                  color: MainColor,
                  borderRadius: BorderRadius.circular(height*0.02),
                  border: Border.all(color: Colors.black,width: 1),
                ),
                child: Text(LanguageContent.isEmpty ? '' : LanguageContent['En']['Add'],style: TextStyle(fontSize: height*0.06,fontFamily: 'H2',color: Colors.white),),
              ),
            ),
          ),
        ],
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

  //Send mesg
  void SendMesg() async {
    final ref = await FirebaseDatabase.instance.ref().child(widget.DoctorInfo['id']);

    ref.child('${MessagesLength + 1}').set({
      'msg' : MesgController.text.trim(),
      'from' : widget.DoctorInfo['id'],
      'name' : '${widget.DoctorInfo['firstname']} ${widget.DoctorInfo['lastname']}',
    }).whenComplete(() {
      setState(() {
        MesgController.clear();
      });
    });
  }

  void FetchMessages() async {
    final ref = await FirebaseDatabase.instance.ref().child(widget.DoctorInfo['id']);

    //to get each msg
    ref.onChildAdded.forEach((element) { 
      setState(() {
        Messages.addAll(
          {element.snapshot.key : element.snapshot.value as Map}
        );
      });
    });

    ref.onValue.listen((event) { 
      setState(() {
        MessagesLength = event.snapshot.children.length;
      });
    });
  }

  void AddNewMember(Stuff New) async {
    await FirebaseFirestore.instance.collection('Stuffs').doc(StuffId).set(New.toJson());
  }

  void FtechAllStuffs() async {
    await FirebaseFirestore.instance.collection('Stuffs').where('Did', isEqualTo: widget.DoctorInfo['id']).snapshots().listen((event) { 
      setState(() {
        AllStuff.clear();
      });
      event.docs.forEach((element) { 
        setState(() {
          AllStuff.add({
            'firstname' : element.data()['firstname'],
            'lastname' : element.data()['lastname'],
            'Did' : element.data()['Did'],
            'id' : element.data()['id'],
            'sexe' : element.data()['sexe'],
            'email' : element.data()['email'],
            'password' : element.data()['password'],
            'state' : element.data()['state'],
          });
        });
      });
    });
  }









  //Padding(
  //  padding: EdgeInsets.only(right: width*0.03,top: height*0.03),
  //  child: Container(
  //    padding: EdgeInsets.only(top: height*0.04,bottom: height*0.03),
  //    height: height*0.37,
  //    width: width*0.23,
  //    decoration: BoxDecoration(
  //      color: Colors.white,
  //      borderRadius: BorderRadius.circular(height*0.03),
  //      border: Border.all(width: 1,color: Colors.black),
  //    ),
  //    child: Column(
  //      children: [
  //        Padding(
  //          padding: EdgeInsets.only(bottom: height*0.02,right: width*0.01,left: width*0.01),
  //          child: TextField(
  //            controller: TaskNameController,
  //            style: TextStyle(
  //              fontFamily: 'H3',
  //              fontWeight: FontWeight.w400,
  //              fontSize: height*0.022,
  //            ),
  //            decoration: InputDecoration(
  //              contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.025, bottom: height*0.025, left: width*0.007),
  //              isDense: true,
  //              border: OutlineInputBorder(
  //                borderSide: BorderSide(
  //                  color: Colors.black,
  //                  width: 1,
  //                ),
  //                borderRadius: BorderRadius.circular(height*0.02),
  //              ),
  //              enabled: true,
  //              labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Task Name'],
  //              labelStyle: TextStyle(
  //                fontFamily: 'H3',
  //                fontWeight: FontWeight.w400,
  //                fontSize: height*0.021,
  //              )
  //            ),
  //          ),
  //        ),
  //        Padding(
  //          padding: EdgeInsets.only(bottom: height*0.02,right: width*0.01,left: width*0.01),
  //          child: Container(
  //            height: height*0.07,
  //            decoration: BoxDecoration(
  //              color: Colors.white,
  //              borderRadius: BorderRadius.circular(height*0.02),
  //              border: Border.all(color: Color.fromARGB(255, 87, 87, 87),width: 0.9),
  //            ),
  //          ) ,
  //        ),
  //        MyExpandedCollumn(),
  //        Padding(
  //          padding: EdgeInsets.only(bottom: height*0.01,right: width*0.01,left: width*0.01),
  //          child: MyButton(LanguageContent.isEmpty ? '' : LanguageContent['En']['Add Task'], height*0.07, width*0.2, MainColor, height*0.02),
  //        ),
  //      ],
  //    ),
  //  ),
} 