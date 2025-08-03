// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Doctor/Components/ChartOverview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';


class HomeDPage extends StatefulWidget {
  Map DoctorInfo;
  HomeDPage({super.key, required this.DoctorInfo});

  @override
  State<HomeDPage> createState() => _HomeDPageState();
}

class _HomeDPageState extends State<HomeDPage> {

  //MAP 
  Map LanguageContent = {};
  Map PatientHistory = {};

  //VARS
  String AppLanguage = 'En';
  int ToDayAppointmentsLength = 0;
  int ThisMonthAppointmentsLength = 0;

  //DATE
  DateTime NowaDay = DateTime.now();


  @override
  void initState() {
    super.initState();

    //if(hiveDB.bx.get("usermap") == null){
    //  hiveDB.InitUserMapData();
    //}else{
    //  hiveDB.LoadUserMapData();
    //}

    Future.delayed(const Duration(milliseconds: 5) , () {
      readJson();
      FetchAndReorderAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //Provider.of<LanguageProvider>(context, listen: false).Language

    return Container(
      padding: MainPadding(height*1.5, width*0.15),
      height: height,
      width: width*0.85,
      color: const Color.fromARGB(255, 250, 250, 250),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(height*0.015),
                  height: height*0.25,
                  width: width*0.26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(height*0.022),
                    border: Border.all(width: 0.4,color: Colors.black)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Opacity(
                            opacity: 0.8,
                            child: Container(
                              height: height*0.065,
                              width: height*0.065,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height*0.017),
                                border: Border.all(width: 0.7,color: Colors.black),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/file-user.png',height: height*0.045,),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(width: width*0.01,),
                          
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTitle(LanguageContent.isEmpty ? '' : LanguageContent['En']['Total Patient Title'], Colors.black, height*0.027),
                              MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Total Patient Desc'], Colors.black54, height*0.016, 1),
                            ],
                          )
                        ],
                      ),
        
                      MyExpandedCollumn(),
        
                      MyText(ThisMonthAppointmentsLength.toString(), Colors.black, height*0.055),
        
                      Row(
                        children: [
                          MyDescription('+12%', Colors.green, height*0.016, 1),
                          MyDescription(LanguageContent.isEmpty ? '' : ' ${LanguageContent['En']['Total percentage']}', Colors.black54, height*0.016, 1),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(height*0.015),
                  height: height*0.25,
                  width: width*0.26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(height*0.022),
                    border: Border.all(width: 0.4,color: Colors.black)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Opacity(
                            opacity: 0.8,
                            child: Container(
                              height: height*0.065,
                              width: height*0.065,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height*0.017),
                                border: Border.all(width: 0.7,color: Colors.black),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/sack-dollar.png',height: height*0.045,),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(width: width*0.01,),
                          
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTitle(LanguageContent.isEmpty ? '' : LanguageContent['En']['Total Revenue Title'], Colors.black, height*0.027),
                              MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Total Revenue Desc'], Colors.black54, height*0.016, 1),
                            ],
                          )
                        ],
                      ),
        
                      MyExpandedCollumn(),
        
                      MyText((widget.DoctorInfo['appointmentprice']*ThisMonthAppointmentsLength).toString(), Colors.black, height*0.055),
        
                      Row(
                        children: [
                          MyDescription('+40%', Colors.green, height*0.016, 1),
                          MyDescription(LanguageContent.isEmpty ? '' : ' ${LanguageContent['En']['Total percentage']}', Colors.black54, height*0.016, 1),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(height*0.015),
                  height: height*0.25,
                  width: width*0.26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(height*0.022),
                    border: Border.all(width: 0.4,color: Colors.black)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Opacity(
                            opacity: 0.8,
                            child: Container(
                              height: height*0.065,
                              width: height*0.065,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(height*0.017),
                                border: Border.all(width: 0.7,color: Colors.black),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/schedule.png',height: height*0.045,),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(width: width*0.01,),
                          
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyTitle(LanguageContent.isEmpty ? '' : LanguageContent['En']['Total Appointment Today'], Colors.black, height*0.027),
                              MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Total Appointment Desc'], Colors.black54, height*0.016, 1),
                            ],
                          )
                        ],
                      ),
        
                      MyExpandedCollumn(),
        
                      MyText(ToDayAppointmentsLength.toString(), Colors.black, height*0.055),
        
                      Row(
                        children: [
                          MyDescription('+5%', Colors.green, height*0.016, 1),
                          MyDescription(LanguageContent.isEmpty ? '' : ' ${LanguageContent['En']['Total percentage']}', Colors.black54, height*0.016, 1),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          
            Padding(
              padding: EdgeInsets.only(top: width*0.022),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height*0.58,
                    width: width*0.542,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height*0.025),
                      border: Border.all(width: 0.5,color: Colors.black)
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const Alignment(0, 0.74),
                          child: Padding(
                            padding: EdgeInsets.only(right: width*0.028,left: width*0.054),
                            child: Divider(
                              height: 0.04,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, 0.44),
                          child: Padding(
                            padding: EdgeInsets.only(right: width*0.028,left: width*0.054),
                            child: Divider(
                              height: 0.04,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, 0.14),
                          child: Padding(
                            padding: EdgeInsets.only(right: width*0.028,left: width*0.054),
                            child: Divider(
                              height: 0.04,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, -0.14),
                          child: Padding(
                            padding: EdgeInsets.only(right: width*0.028,left: width*0.054),
                            child: Divider(
                              height: 0.04,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, -0.44),
                          child: Padding(
                            padding: EdgeInsets.only(right: width*0.028,left: width*0.054),
                            child: Divider(
                              height: 0.04,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                        ),
                        ChartComponent(),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(right: 0,left: width*0.02),
                    child: Container(
                      height: height*0.58,
                      width: width*0.257,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(height*0.02),
                        border: Border.all(color: Colors.black,width: 0.4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: width*0.01,top: height*0.02,left: width*0.01,bottom: height*0.02),
                            child: MyTitle(LanguageContent.isEmpty ? '' : LanguageContent['En']['Patient History'], Colors.black, height*0.027),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height*0.02),
                            child: Container(
                              height: 2,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(width: 0.4,color: Colors.black)
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: width*0.01,left: width*0.01,bottom: height*0.02),
                            child: SizedBox(
                              height: height*0.45,
                              width: width*0.257,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: PatientHistory.isEmpty ? 1 : PatientHistory.length,
                                itemBuilder: (context, index) {
                                  if (PatientHistory.isEmpty) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Lottie.asset('assets/animations/708791546726.json',height: height*0.3,repeat: false),
                                      ],
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: height*0.02),
                                      child: Container(
                                        padding: EdgeInsets.only(top: height*0.01,right: width*0.01,left: width*0.01,bottom: height*0.01),
                                        height: height*0.17,
                                        width: width*0.257,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(height*0.02),
                                          border: Border.all(color: Colors.black,width: 0.5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            MyDescription('ID : ${PatientHistory['${index + 1}']['id']}', Colors.black, height*0.02, 1),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: width*0.1,
                                                  child: MyDescription('Full Name : ${PatientHistory['${index + 1}']['Pfirstname']}', Colors.black, height*0.02, 1),
                                                ),
                                                SizedBox(
                                                  width: width*0.075,
                                                  child: MyDescription(' ${PatientHistory['${index + 1}']['Plastname']}', Colors.black, height*0.02, 1)
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: width*0.075,
                                              child: MyDescription('Spot : ${PatientHistory['${index + 1}']['spot']}', Colors.black, height*0.02, 1)
                                            ),
                                            SizedBox(
                                              width: width*0.1,
                                              child: MyDescription('State : ${PatientHistory['${index + 1}']['state']}', Colors.black, height*0.02, 1)
                                            ),
                                            SizedBox(
                                              width: width*0.1,
                                              child: MyDescription('Paid : ${PatientHistory['${index + 1}']['paid']}', Colors.black, height*0.02, 1)
                                            ),
                                          ],
                                        )
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height*0.02,
            ),
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


  //
  Future<void> FetchAndReorderAppointments() async {
    await FirebaseFirestore.instance.collection('Appointments').where('Did', isEqualTo: widget.DoctorInfo['id']).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        if (element.data()['date'] == DateFormat.yMd().format(NowaDay)) {
          setState(() {
            PatientHistory.addAll({'${element.data()['spot']}' : element.data()});
            ToDayAppointmentsLength++;
          });
        }
        if (DateFormat.yMd().parse(element.data()['date']).month == NowaDay.month) {
          setState(() {
            ThisMonthAppointmentsLength++;
          });
        }
      });
    });
  }
}