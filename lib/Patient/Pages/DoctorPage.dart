// ignore_for_file: must_be_immutable

import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Objects/AppointmentC.dart';
import 'package:carewise/Objects/DoctorC.dart';
import 'package:carewise/Objects/ReservationC.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DoctorPage extends StatefulWidget {
  Map DoctorMap;
  DoctorPage({super.key, required this.DoctorMap});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {

  //DATE 
  DateTime NowaDay = DateTime.now();
  DateTime SelectedDate = DateTime.now();
  TimeOfDay SelectedTime = TimeOfDay.now();

  //INSTANCE
  late Doctor DoctorMap;
  Reservations reservations = Reservations(id: '',spot: 0, spots: 0, emptyspots: 0, date: '', indexspot: 0);
  Map patient = {};

  //VARS
  bool showDetails = false;
  bool TimeOrSpot = false;
  bool appointmentExis = false;

  int SpotIndex = 0;

  //LIST 
  List<Appointment> history = [];

  //CONTROLLERS
  final name = TextEditingController();
  final time = TextEditingController();
  final spot = TextEditingController();
  final age = TextEditingController();


  @override
  void initState() {
    super.initState();
    DoctorMap = Doctor(
      firstname: widget.DoctorMap['firstname'], 
      lastname: widget.DoctorMap['lastname'], 
      sexe: widget.DoctorMap['sexe'], 
      email: widget.DoctorMap['email'], 
      id: widget.DoctorMap['id'], 
      speciality: widget.DoctorMap['speciality'], 
      phonenumber: widget.DoctorMap['phonenumber'], 
      adr: widget.DoctorMap['adr'], 
      yourown: widget.DoctorMap['yourown'], 
      relation: widget.DoctorMap['relation'], 
      bio: widget.DoctorMap['bio'], 
      workDays: widget.DoctorMap['workDays'], 
      workHours: widget.DoctorMap['workHours'], 
      appointmentprice: 2000,
    );

    Future.delayed(Duration(milliseconds: 10), () {
      FetchReservationInfo();
      FetchPatientInfo();
    }).whenComplete(() {
      Future.delayed(Duration(milliseconds: 500), () {
        FetchAppointmentHisory();
      });
    });

    Future.delayed(Duration(seconds: 2), () {
      FirebaseFirestore.instance.collection(MainCo).doc(DoctorMap.id).collection('Appointments').where('date', isEqualTo: DateFormat.yMd().format(SelectedDate)).snapshots().listen((event) { 
        if (SpotIndex <= reservations.spot) {
          setState(() {
            SpotIndex = reservations.spot+1;
          });
        }
      });
    });

    
  }
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,size: height*0.022,),
        ),
        title: MyText('Appointment', Colors.black, height*0.027),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: MainPadding(height, width),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: height*0.03),
                child: Container(
                  height: height*0.19,
                  width: width,
                  padding: MainPadding(height*0.7, width*0.7),
                  decoration: BoxDecoration(
                    color: MainColor,
                    borderRadius: BorderRadius.circular(height*0.02),
                    border: Border.all(color: Colors.black,width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: MyText('Dr.${DoctorMap.firstname[0].toUpperCase()}${DoctorMap.firstname[1]}${DoctorMap.firstname[2]} ${DoctorMap.lastname}', Colors.black, height*0.021),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.015),
                        child: MyText(DoctorMap.speciality, Colors.black.withOpacity(0.7), height*0.015),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.01),
                        child: MyDescription('${DoctorMap.adr['province']}, ${DoctorMap.adr['locality']}', Colors.black.withOpacity(0.7), height*0.014, 3),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.005),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month_outlined, color: Colors.black.withOpacity(0.5),size: height*0.02,),
                            SizedBox(width: width*0.01,),
                            MyDescription(DoctorMap.workDays, Colors.black.withOpacity(0.7), height*0.014, 3),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.01),
                        child: Row(
                          children: [
                            Icon(Icons.timelapse_outlined, color: Colors.black.withOpacity(0.5),size: height*0.02,),
                            SizedBox(width: width*0.01,),
                            MyDescription(DoctorMap.workHours, Colors.black.withOpacity(0.7), height*0.014, 3),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height*0.0),
                child: MyTitle('About Doctor', Colors.black.withOpacity(0.7), height*0.02),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height*0.02),
                child: MyDescription(DoctorMap.bio, Colors.black.withOpacity(0.7), height*0.014, 5),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height*0.02),
                child: Container(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.002,right: 5),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DatePicker(
                    DateTime.utc(NowaDay.year,NowaDay.month,NowaDay.day),
                    initialSelectedDate: DateTime.now(),
                    selectionColor: MainColor,
                    selectedTextColor: Colors.white,
                    deactivatedColor: Colors.white,
                    dateTextStyle: TextStyle(
                      fontSize: height*0.018,
                      fontFamily: 'H2',
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.2)
                    ),
                    dayTextStyle: TextStyle(
                      fontSize: height*0.018,
                      fontFamily: 'H2',
                      color: Colors.black.withOpacity(0.2),
                      fontWeight: FontWeight.w500
                    ),
                    monthTextStyle: TextStyle(
                      fontSize: 0,
                    ),
                    daysCount: 7,
                    onDateChange: (date) {
                      setState(() {
                        SelectedDate = date;
                      });
                      FetchReservationInfo();
                      FetchAppointmentHisory();
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for(var i = 0; i < 3; i++) Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: height*0.135,
                        width: height*0.11,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(height*0.02),
                          border: Border.all(color: Colors.black,width: 1),
                        ),
                        child: Column(
                          children: [
                            i == 0 ? Image.asset('assets/icons/planet.png', height: height*0.08,) : i == 1 ? Image.asset('assets/icons/message(1).png', height: height*0.08,) : Image.asset('assets/icons/space(1).png', height: height*0.08,),
                            i == 0 ? MyText('Your Spot', Colors.black, height*0.017) : i == 1 ? MyText('Live spot', Colors.black, height*0.017) : MyText('All spots', Colors.black, height*0.017),
                            i == 0 ? MyDescription(SpotIndex.toString(), Colors.black, height*0.015, 1) : i == 1 ? MyDescription(reservations.spot.toString(), Colors.black, height*0.015, 1) : MyDescription(reservations.spots.toString(), Colors.black, height*0.015, 1),
                          ],
                        )
                      ),
                    ],
                  ),
                ],
              ),
              showDetails == true ? 
                Padding(
                  padding: EdgeInsets.only(top: height*0.02),
                  child: Container(
                    height: height*0.05,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //TextField(
                        //  controller: name,
                        //  decoration: InputDecoration(
                        //    contentPadding: EdgeInsets.only(right: width*0.03, top: height*0.012, bottom: height*0.012, left: width*0.03),
                        //    isDense: true,
                        //    border: OutlineInputBorder(
                        //      borderSide: BorderSide(
                        //        color: Colors.black,
                        //        width: 1,
                        //      ),
                        //      borderRadius: BorderRadius.circular(height*0.018),
                        //    ),
                        //    hintText: 'Your name',
                        //    hintStyle: TextStyle(color: Colors.black.withOpacity(0.4),fontFamily: 'H3', fontSize: height*0.016,letterSpacing: 1, fontWeight: FontWeight.w300),
                        //  ),
                        //),
                        //TextField(
                        //  controller: age,
                        //  decoration: InputDecoration(
                        //    contentPadding: EdgeInsets.only(right: width*0.03, top: height*0.012, bottom: height*0.012, left: width*0.03),
                        //    isDense: true,
                        //    border: OutlineInputBorder(
                        //      borderSide: BorderSide(
                        //        color: Colors.black,
                        //        width: 1,
                        //      ),
                        //      borderRadius: BorderRadius.circular(height*0.018),
                        //    ),
                        //    hintText: 'Your age',
                        //    hintStyle: TextStyle(color: Colors.black.withOpacity(0.4),fontFamily: 'H3', fontSize: height*0.016,letterSpacing: 1, fontWeight: FontWeight.w300),
                        //  ),
                        //),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: height*0.05,
                              width: width*0.81,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(height*0.017),
                                border: Border.all(width: 1,color: TimeOrSpot == false ? Colors.black : Colors.black.withOpacity(0.2)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (SpotIndex <= reservations.spot+1 || SpotIndex <= 0) {
                                          setState(() {
                                            TimeOrSpot = false;
                                          });
                                        } else {
                                          setState(() {
                                            SpotIndex--;
                                            TimeOrSpot = false;
                                          });
                                        }
                                      });
                                    }, 
                                    icon: Icon(Icons.remove,color: TimeOrSpot == false ? Colors.black : Colors.black.withOpacity(0.2),),
                                  ),
                                  MyText('$SpotIndex', TimeOrSpot == false ? Colors.black : Colors.black.withOpacity(0.2), height*0.022),
                                  IconButton(
                                    onPressed: () {
                                      if (SpotIndex >= reservations.spots) {
                                        setState(() {
                                          TimeOrSpot = false;
                                        });
                                      } else {
                                        setState(() {
                                          SpotIndex++;
                                          TimeOrSpot = false;
                                        });
                                      }
                                    }, 
                                    icon: Icon(Icons.add,color: TimeOrSpot == false ? Colors.black : Colors.black.withOpacity(0.2),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                : 
                Container(),
              Padding(
                padding: EdgeInsets.only(top: height*0.02,bottom: height*0.02),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          //if (showDetails == true) {
                          //  setState(() {
                          //    showDetails = false;
                          //  });
                          //  CherryToast.success(title: Text("Your spot was changed successfully")).show(context);
                          //} else {
                          //  setState(() {
                          //    showDetails = true;
                          //  });
                          //}
                          print(history);
                        },
                        child: MyButton(showDetails == false ?  'Modify' : 'Save', height*0.05, width, Colors.white, height*0.015),
                      ),
                    ),
                    SizedBox(
                      width: width*0.015,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          VerifyAppointment(height).whenComplete(() {
                            if (appointmentExis == true) {
                              CherryToast.warning(title: MyDescription('You can only reserve in one appointment today with this doctor', Colors.black, height*0.016, 3)).show(context);
                            } else {
                              CreateAppointment();
                              CherryToast.success(title: MyDescription('Appointment was created successfully', Colors.black, height*0.016, 3)).show(context);
                            }
                          });
                        },
                        child: MyButton('Take', height*0.05, width, MainColor, height*0.015),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom:history == {} ? height*0 : height*0.01),
                child: MyTitle('History', Colors.black.withOpacity(0.7), height*0.02),
              ),
              history != [] ?  SizedBox(
                height: height*0.3,
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    Appointment appoint = history[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: height*0.01),
                      child: Row(
                        children: [
                          Container(
                            height: height*0.205,
                            width: width*0.008,
                            decoration: BoxDecoration(
                              color: SecondColor,
                              borderRadius: BorderRadius.circular(height),
                            ),
                          ),
                          SizedBox(width: width*0.005,),
                          Container(
                            padding: EdgeInsets.only(right: width*0.03, top: height*0.005, left: width*0.03),
                            height: height*0.205,
                            width: width*0.78,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.018), bottomRight: Radius.circular(height*0.018)),
                              border: Border.all(width: 1,color: Colors.black),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyDescription('Doctor', Colors.black, height*0.014, 1),
                                        MyText('Dr.${DoctorMap.firstname} ${DoctorMap.lastname}', Colors.black, height*0.017)
                                      ],
                                    ),
                                    const Expanded(
                                      child: SizedBox(
                                        width: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width*0.25,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MyDescription('Spot', Colors.black, height*0.014, 1),
                                          MyText(appoint.spot.toString(), Colors.black, height*0.017)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height*0.025,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyDescription('Patient', Colors.black, height*0.014, 1),
                                        MyText('${patient['firstname']} ${patient['lastname']}', Colors.black, height*0.017)
                                      ],
                                    ),
                                    const Expanded(
                                      child: SizedBox(
                                        width: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width*0.25,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MyDescription('Date', Colors.black, height*0.014, 1),
                                          MyText(appoint.date, Colors.black, height*0.017)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height*0.025,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MyDescription('Appointment', Colors.black, height*0.014, 1),
                                        MyText(appoint.id, Colors.black, height*0.017)
                                      ],
                                    ),
                                    const Expanded(
                                      child: SizedBox(
                                        width: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width*0.25,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MyDescription('State', Colors.black, height*0.014, 1),
                                          MyText(appoint.state, Colors.black, height*0.017)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: Lottie.asset('assets/animations/51382-astronaut-light-theme.json'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //fetch patient info
  Future FetchPatientInfo() async {
    //CHANGE EMAIL TO ID ***************************************************************************
    return await FirebaseFirestore.instance.collection(UsersCo).doc('nour@gmail.com').snapshots().listen((event) { 
      setState(() {
        patient = event.data()!;
      });
    });
  }

  //
  Future CreateAppointment() async {
    //CHANGE EMAIL TO ID **************************************************************************************
    await FirebaseFirestore.instance.collection('Appointments').doc('${SelectedDate.day}${patient['firstname'][0].toString().toUpperCase()}${patient['lastname'][0].toString().toUpperCase()}$SpotIndex${DoctorMap.firstname[0].toUpperCase()}${DoctorMap.lastname[0].toUpperCase()}${DoctorMap.adr['province'][0].toString().toUpperCase()}${DoctorMap.adr['province'][1].toString().toUpperCase()}${NowaDay.hour}${NowaDay.minute}${NowaDay.second}').set(
      Appointment(
        id: '${SelectedDate.day}${patient['firstname'][0].toString().toUpperCase()}${patient['lastname'][0].toString().toUpperCase()}$SpotIndex${DoctorMap.firstname[0].toUpperCase()}${DoctorMap.lastname[0].toUpperCase()}${DoctorMap.adr['province'][0].toString().toUpperCase()}${DoctorMap.adr['province'][1].toString().toUpperCase()}${NowaDay.hour}${NowaDay.minute}${NowaDay.second}', 
        fromapp: true,
        date: DateFormat.yMd().format(SelectedDate), 
        Did: DoctorMap.id, 
        Dfirstname: DoctorMap.firstname, 
        Dlastname: DoctorMap.lastname, 
        Pid: patient['id'], 
        Pfirstname: patient['firstname'], 
        Plastname: patient['lastname'], 
        Pold: patient['old'], 
        spot: SpotIndex, 
        state: 'Waiting', 
        adr: {
          'locality' : DoctorMap.adr['locality'],
          'province' : DoctorMap.adr['province'],
        }, 
        paid: false, 
        paymentmethod: '',
      ).toJson(),
    );

    await FirebaseFirestore.instance.collection(MainCo).doc(DoctorMap.id).collection('Reservations').doc(reservations.id).update({
      'spot' : reservations.spot + 1,
      'emptyspots' : reservations.emptyspots - 1,
    });
  }

  //fetch appointments history 
  Future FetchAppointmentHisory() async {
    setState(() {
      history.clear();
    });
    return await FirebaseFirestore.instance.collection('Appointments').where('Pid', isEqualTo: '3S54DQ6').snapshots().listen((event) { 
      event.docs.forEach((element) { 
        print(element.data()['Did']);
        if (element.data()['Did'] == DoctorMap.id) {
          setState(() {
            history.add(
              Appointment(
                id: element.data()['id'], 
                fromapp: element.data()['fromapp'],
                date: element.data()['date'], 
                Did: element.data()['Did'], 
                Dfirstname: element.data()['Dfirstname'], 
                Dlastname: element.data()['Dlastname'], 
                Pid: element.data()['Pid'], 
                Pfirstname: element.data()['Pfirstname'], 
                Plastname: element.data()['Plastname'], 
                Pold: element.data()['Pold'], 
                spot: element.data()['spot'], 
                state: element.data()['state'], 
                adr: element.data()['adr'], 
                paid: element.data()['paid'], 
                paymentmethod: element.data()['paymentmethod'],
              ),
            );
          });
        }
      });
    });
  }


  //fetch reservation info
  Future FetchReservationInfo() async {
    //DateFormat.yMd().format(NowaDay);
    print('lets goo');
    return await FirebaseFirestore.instance.collection(MainCo).doc(DoctorMap.id).collection('Reservations').where('date', isEqualTo: DateFormat.yMd().format(SelectedDate)).snapshots().listen((event) async { 
      if (event.docs.isNotEmpty) {
        event.docs.forEach((element) { 
          print('found');
          setState(() {
            reservations = Reservations( 
              id: element.id,
              spot: element['spot'], 
              spots: element['spots'], 
              emptyspots: element['emptyspots'], 
              date: element['date'], 
              indexspot: element['indexspot'], 
            );
            SpotIndex = reservations.spot + 1;
          });
        });
      } else {
        print('empty');
        await FirebaseFirestore.instance.collection(MainCo).doc(DoctorMap.id).collection('Reservations').doc('${SelectedDate.month}_${SelectedDate.day}_${SelectedDate.year}').set({
          'spots' : 20,
          'date' : DateFormat.yMd().format(NowaDay),
          'spot' : 0,
          'emptyspots' : 20,
        });
        setState(() {
          reservations = Reservations( 
            id: '${SelectedDate.month}_${SelectedDate.day}_${SelectedDate.year}',
            spot: 0, 
            spots: 20, 
            emptyspots: 20, 
            date: DateFormat.yMd().format(SelectedDate), 
            indexspot: 0, 
          );
          SpotIndex = 1;
        });
      }
    });
  }

  //verify if appointment exists
  Future VerifyAppointment(double height) async {
    setState(() {
      appointmentExis = false;
    });
    final data = await FirebaseFirestore.instance.collection('Appointments').where('Pid', isEqualTo: patient['id']).get();
    if(data.docs.isEmpty) {
      print('1');
      CreateAppointment();
      CherryToast.success(title: MyText('Appointment was created successfully', Colors.black, height*0.016)).show(context);
    }else {
      print('2');
      data.docs.forEach((item) { 
        print('3');
        if (item.data()['date'] == DateFormat.yMd().format(SelectedDate)) {
          print('4');
          setState(() {
            appointmentExis = true;
          });
        }else {
          print('5');
        }
      });
    }
  }
}