import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Doctor/Pages/AppointmentD.dart';
import 'package:carewise/Doctor/Pages/HomeD.dart';
import 'package:carewise/Doctor/Pages/PatientsD.dart';
import 'package:carewise/Doctor/Pages/StaffD.dart';
import 'package:flutter/material.dart';

class SourceDPage extends StatefulWidget {
  Map DoctorInfo;
  SourceDPage({super.key, required this.DoctorInfo});

  @override
  State<SourceDPage> createState() => _SourceDPageState();
}

class _SourceDPageState extends State<SourceDPage> {

  //VARS
  bool SelectPage1 = true;
  bool SelectPage2 = false;
  bool SelectPage3 = false;
  bool SelectPage4 = false;

  double opacity1 = 0.2;
  double opacity2 = 0.2;
  double opacity3 = 0.2;
  double opacity4 = 0.2;

  int index = 0;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            setState(() {
              SelectPage1 = !SelectPage1;
            });
          },
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: height*0.05,
                width: height*0.05,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.4),
                ),
                child: MyDescription(widget.DoctorInfo['firstname'][0].toString().toUpperCase(), Colors.black, height*0.02, 1),
              ),
              Padding(
                padding: EdgeInsets.only(left: width*0.002),
                child: Column(
                  children: [
                    MyDescription('Super Owner', Colors.black, height*0.02,1),
                    MyDescription(widget.DoctorInfo['email'], Colors.black, height*0.014,1),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width*0.01,top: height*0.005),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Image.asset('assets/icons/sign-out-alt(1).png',height: height*0.03,)
                ),
              ),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0), 
          child: Container(
            height: 0.7,
            color: Colors.black,
          ),
        ),
        leading: Container(
          height: height*0.12,
          width: width*0.15,
          color: Colors.black,
        ),
        leadingWidth: width*0.15,
        centerTitle: true,
        toolbarHeight: height*0.12,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Row(
        children: [
          //Slider
          Container(
            padding: EdgeInsets.only(right: width*0.017,left: width*0.017,top: height*0.04),
            height: height,
            width: width*0.15,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height*0.04,),

                //
                GestureDetector(
                  onTap: () {
                    setState(() {
                      SelectPage1 = true;
                      SelectPage2 = false;
                      SelectPage3 = false;
                      SelectPage4 = false;
                      index = 0;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: height*0.055),
                    child: Row(
                      children: [
                        AnimatedOpacity(
                          opacity: SelectPage1 ? 1 : 0.4, 
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset('assets/icons/apps.png', height: height*0.032,),
                        ),
                        MyExpandedRow(),
                        AnimatedOpacity(
                          opacity: SelectPage1 ? 1 : 0.2, 
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: width*0.09,
                            child: MyDescription('Dashboard', Colors.white, height*0.027, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      SelectPage1 = false;
                      SelectPage2 = true;
                      SelectPage3 = false;
                      SelectPage4 = false;
                      index = 1;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: height*0.055),
                    child: Row(
                      children: [
                        AnimatedOpacity(
                          opacity: SelectPage2 ? 1 : 0.4, 
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset('assets/icons/dice-d6(2).png', height: height*0.032,),
                        ),
                        MyExpandedRow(),
                        AnimatedOpacity(
                          opacity: SelectPage2 ? 1 : 0.2, 
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: width*0.09,
                            child: MyDescription('Appointment', Colors.white, height*0.027, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      SelectPage1 = false;
                      SelectPage2 = false;
                      SelectPage3 = true;
                      SelectPage4 = false;
                      index = 2;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: height*0.055),
                    child: Row(
                      children: [
                        AnimatedOpacity(
                          opacity: SelectPage3 ? 1 : 0.4, 
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset('assets/icons/chart-pie-alt(3).png', height: height*0.032,),
                        ),
                        MyExpandedRow(),
                        AnimatedOpacity(
                          opacity: SelectPage3 ? 1 : 0.2, 
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: width*0.09,
                            child: MyDescription('Staff', Colors.white, height*0.027, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      SelectPage1 = false;
                      SelectPage2 = false;
                      SelectPage3 = false;
                      SelectPage4 = true;
                      index = 3;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: height*0.055),
                    child: Row(
                      children: [
                        AnimatedOpacity(
                          opacity: SelectPage4 ? 1 : 0.4, 
                          duration: const Duration(milliseconds: 300),
                          child: Image.asset('assets/icons/user(1).png', height: height*0.032,),
                        ),
                        MyExpandedRow(),
                        AnimatedOpacity(
                          opacity: SelectPage4 ? 1 : 0.2, 
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: width*0.09,
                            child: MyDescription('Patients', Colors.white, height*0.027, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          //Pages
          index == 0 ? HomeDPage(DoctorInfo: widget.DoctorInfo,) : index == 1 ? AppointmentDPage(DoctorInfo: widget.DoctorInfo,) : index == 2 ? StaffDPage(DoctorInfo: widget.DoctorInfo,) : PatientsDPage(DoctorInfo: widget.DoctorInfo,),
        ],
      )
    );
  }
}