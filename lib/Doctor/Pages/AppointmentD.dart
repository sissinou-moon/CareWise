// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:html';

import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Objects/AppointmentC.dart';
import 'package:carewise/Objects/Medicine.dart';
import 'package:carewise/Objects/PrescriptionC.dart';
import 'package:carewise/Objects/ReservationC.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';


class AppointmentDPage extends StatefulWidget {
  Map DoctorInfo;
  AppointmentDPage({super.key, required this.DoctorInfo});

  @override
  State<AppointmentDPage> createState() => _AppointmentDPageState();
}

class _AppointmentDPageState extends State<AppointmentDPage> {

  //DATE
  DateTime NowaDay = DateTime.now();
  DateTime SelectedDate = DateTime.now();

  //MAP
  Map LanguageContent = {};
  Map IndexAppointment = {};
  Map Appointments = {};

  //LISTS 
  List<Map> Medicines = [];

  //INSTANCES
  Reservations IndexReservation = Reservations(id: "", spot: 0, spots: 0, emptyspots: 0, indexspot: 0, date: "");

  //CONTROLLERS
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final oldcontroller = TextEditingController();
  final spotcontroller = TextEditingController();
  final documentidcontroller = TextEditingController();
  final medicinecontroller = TextEditingController();
  final medicinehowmanycontroller = TextEditingController();
  final medicinehowoftencontroller = TextEditingController();

  WidgetsToImageController ScreenShotController = WidgetsToImageController();
  final WidgetScreenShotController = ScreenshotController();

  //VARS
  int Spot = 0;

  bool AfterEeating = false;

  String ClinicLogo = 'https://upload.wikimedia.org/wikipedia/fr/a/ac/Logo_clinique_de_La_Source_Lausanne.png'; // use widget.doctorinfo['cliniclogo']

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      readJson();
      FetchReservation();
      FetchIndexAppointment();
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //---------------------------------------------------------------------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.03),
                  child: Container(
                    height: height*0.4,
                    width: width*0.13,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height*0.02),
                      border: Border.all(width: 0.7, color: Colors.black)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: width*0.01,left: width*0.01,top: height*0.015,bottom: height*0.015),
                          child: MyTitle(LanguageContent.isEmpty ? '' : LanguageContent['En']['Add Direct Spot'], Colors.black, height*0.023),
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
                          padding: EdgeInsets.only(bottom: height*0.02,right: width*0.01,left: width*0.01),
                          child: TextField(
                            controller: firstnamecontroller,
                            style: TextStyle(
                              fontFamily: 'H3',
                              fontWeight: FontWeight.w400,
                              fontSize: height*0.022,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.01, bottom: height*0.01, left: width*0.007),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(height*0.01),
                              ),
                              enabled: true,
                              labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['First Name'],
                              labelStyle: TextStyle(
                                fontFamily: 'H3',
                                fontWeight: FontWeight.w400,
                                fontSize: height*0.018,
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height*0.02,right: width*0.01,left: width*0.01),
                          child: TextField(
                            controller: lastnamecontroller,
                            style: TextStyle(
                              fontFamily: 'H3',
                              fontWeight: FontWeight.w400,
                              fontSize: height*0.022,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.01, bottom: height*0.01, left: width*0.007),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(height*0.01),
                              ),
                              enabled: true,
                              labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Last Name'],
                              labelStyle: TextStyle(
                                fontFamily: 'H3',
                                fontWeight: FontWeight.w400,
                                fontSize: height*0.018,
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height*0.02,right: width*0.01,left: width*0.01),
                          child: TextField(
                            controller: oldcontroller,
                            style: TextStyle(
                              fontFamily: 'H3',
                              fontWeight: FontWeight.w400,
                              fontSize: height*0.022,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.01, bottom: height*0.01, left: width*0.007),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(height*0.01),
                              ),
                              enabled: true,
                              labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Old'],
                              labelStyle: TextStyle(
                                fontFamily: 'H3',
                                fontWeight: FontWeight.w400,
                                fontSize: height*0.018,
                              )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height*0.02,right: width*0.01,left: width*0.01),
                          child: Container(
                            padding: EdgeInsets.only(right: width*0.005,left: width*0.005),
                            alignment: Alignment.center,
                            height: height*0.042,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(height*0.01),
                              border: Border.all(color: Colors.black.withOpacity(0.7),width: 0.7),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (Spot < 0) {
                                      
                                    } else {
                                      
                                    }
                                  },
                                  child: Icon(Icons.add,size: height*0.023,),
                                ),
                                MyExpandedRow(),
                                MyDescription(Spot.toString(), Colors.black, height*0.02, 1),
                                MyExpandedRow(),
                                GestureDetector(
                                  onTap: () {
                                    
                                  },
                                  child: Icon(Icons.remove,size: height*0.023,),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height*0.02,right: width*0.01,left: width*0.01),
                          child: GestureDetector(
                            onTap: () {
                              if (firstnamecontroller.text.isEmpty || lastnamecontroller.text.isEmpty || oldcontroller.text.isEmpty) {
                                CherryToast.warning(title: MyDescription(LanguageContent['En']['Cherry warning first or last name or old fields is empty'], Colors.black, height*0.03, 2)).show(context);
                              } else {
                                CreateAppointment();
                                CherryToast.success(title: MyDescription(LanguageContent['En']['Cherry success message create direct spot'], Colors.black, height*0.03, 3),).show(context);
                              }
                            },
                            child: MyButton(LanguageContent.isEmpty ? '' : LanguageContent['En']['Add Direct Spot'], height*0.042, width, MainColor, height*0.012)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //---------------------------------------------------------------------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.03),
                  child: Container(
                    height: height*0.15,
                    width: width*0.13,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height*0.02),
                      border: Border.all(width: 0.7, color: Colors.black)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: height*0.015,right: width*0.01,left: width*0.01),
                          child: TextField(
                            controller: documentidcontroller,
                            style: TextStyle(
                              fontFamily: 'H3',
                              fontWeight: FontWeight.w400,
                              fontSize: height*0.022,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.01, bottom: height*0.01, left: width*0.007),
                              isDense: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(height*0.01),
                              ),
                              enabled: true,
                              labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Document ID'],
                              labelStyle: TextStyle(
                                fontFamily: 'H3',
                                fontWeight: FontWeight.w400,
                                fontSize: height*0.018,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width*0.01,left: width*0.01),
                          child: MyButton(LanguageContent.isEmpty ? '' : LanguageContent['En']['Search'], height*0.042, width, MainColor, height*0.012),
                        ),
                      ],
                    ),
                  ),
                ),
                //---------------------------------------------------------------------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.02),
                  child: Container(
                    alignment: Alignment.center,
                    height: height*0.21,
                    width: width*0.13,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height*0.02),
                      border: Border.all(width: 0.7, color: Colors.black)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.015,left: width*0.01),
                              child: SizedBox(
                                width: width*0.05,
                                child: TextField(
                                  controller: medicinecontroller,
                                  style: TextStyle(
                                    fontFamily: 'H3',
                                    fontWeight: FontWeight.w400,
                                    fontSize: height*0.022,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.01, bottom: height*0.01, left: width*0.007),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(height*0.01),
                                    ),
                                    enabled: true,
                                    labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Medicine Name'],
                                    labelStyle: TextStyle(
                                      fontFamily: 'H3',
                                      fontWeight: FontWeight.w400,
                                      fontSize: height*0.018,
                                    )
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.015,left: width*0.007),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    AfterEeating = !AfterEeating;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(right: width*0.007, left: width*0.007),
                                  width: width*0.05,
                                  height: height*0.04,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(height*0.01),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(LanguageContent.isEmpty ? '' : LanguageContent['En']['After'], style:TextStyle(
                                            fontFamily: 'H3',
                                            fontWeight: FontWeight.w400,
                                            fontSize: height*0.018,
                                          )),
                                          SizedBox(height: width*0.002,),
                                        ],
                                      ),
                                      SizedBox(width: width*0.002,),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            AfterEeating = !AfterEeating;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 400),
                                          height: height*0.02,
                                          width: height*0.02,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                              width: AfterEeating ? 1 : 0.5,
                                              color: AfterEeating ? MainColor : Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(height),
                                          ),
                                          child: AfterEeating ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              AnimatedContainer(
                                                duration: Duration(milliseconds: 400),
                                                height: height*0.01,
                                                width: height*0.01,
                                                decoration: BoxDecoration(
                                                  color: MainColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ) : Container(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.02,left: width*0.01),
                              child: SizedBox(
                                width: width*0.05,
                                child: TextField(
                                  controller: medicinehowmanycontroller,
                                  style: TextStyle(
                                    fontFamily: 'H3',
                                    fontWeight: FontWeight.w400,
                                    fontSize: height*0.022,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.01, bottom: height*0.01, left: width*0.007),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(height*0.01),
                                    ),
                                    enabled: true,
                                    labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['Quantity'],
                                    labelStyle: TextStyle(
                                      fontFamily: 'H3',
                                      fontWeight: FontWeight.w400,
                                      fontSize: height*0.018,
                                    )
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: height*0.02,right: width*0.01,left: width*0.007),
                              child: SizedBox(
                                width: width*0.05,
                                child: TextField(
                                  controller: medicinehowoftencontroller,
                                  style: TextStyle(
                                    fontFamily: 'H3',
                                    fontWeight: FontWeight.w400,
                                    fontSize: height*0.022,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(right: width*0.007, top: height*0.01, bottom: height*0.01, left: width*0.007),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(height*0.01),
                                    ),
                                    enabled: true,
                                    labelText: LanguageContent.isEmpty ? '' : LanguageContent['En']['How Often'],
                                    labelStyle: TextStyle(
                                      fontFamily: 'H3',
                                      fontWeight: FontWeight.w400,
                                      fontSize: height*0.018,
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width*0.01,left: width*0.01),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Medicines.add(
                                  Medicine(name: medicinecontroller.text.trim(), howMany: int.parse(medicinehowmanycontroller.text.trim()), howOften: int.parse(medicinehowoftencontroller.text.trim()), after: AfterEeating).toJson(),
                                );
                              });
                            },
                            child: MyButton(LanguageContent.isEmpty ? '' : LanguageContent['En']['Add Medicines'], height*0.042, width, MainColor, height*0.012)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //---------------------------------------------------------------------------------------
            Padding(
              padding: EdgeInsets.only(right: width*0.035,left: width*0.035),
              child: Container(
                height: height*0.82,
                width: width*0.43,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 230, 230),
                  borderRadius: BorderRadius.circular(height*0.03),
                  border: Border.all(width: 0.7, color: Colors.black),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(0.9, -1),
                      child: IconButton(
                        onPressed: () async {
                          final netImage = await networkImage('https://upload.wikimedia.org/wikipedia/fr/a/ac/Logo_clinique_de_La_Source_Lausanne.png');
                          final doc = pw.Document();
                          doc.addPage(
                            pw.MultiPage(
                              header: (context) => pw.SizedBox(
                                height: height*0.09,
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Column(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Text(
                                          'Dr.${widget.DoctorInfo['firstname']} ${widget.DoctorInfo['lastname']}',
                                          style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.022,fontWeight: pw.FontWeight.bold,letterSpacing: 1),
                                        ),
                                        pw.Text(
                                          widget.DoctorInfo['speciality'].toString(),
                                          style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.017,letterSpacing: 1),
                                        ),
                                        Appointments.isEmpty ? pw.Container() : pw.Text(
                                          IndexReservation.indexspot == 0 ? '#' : '#${widget.DoctorInfo['firstname'].toString().toUpperCase()[0]}${widget.DoctorInfo['speciality'].toString().toUpperCase()[0]}${IndexReservation.indexspot}${Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString().toUpperCase()[0]}${SelectedDate.day}${Appointments['${IndexReservation.indexspot}']['Plastname'].toString().toUpperCase()[0]}${SelectedDate.month}${Appointments['${IndexReservation.indexspot}']['Pold'].toString().toUpperCase()[0]}',
                                          style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.017,letterSpacing: 1),
                                        ),
                                      ],
                                    ),
                                    pw.Expanded(child: pw.SizedBox(width: 1)),
                                    //image 
                                    pw.Image(netImage,height: height*0.06,),
                                  ],
                                ),
                              ),
                              footer: (context) => pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.end,
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.SizedBox(
                                    height: height*0.07,
                                    width: height*0.07,
                                    child: pw.BarcodeWidget(
                                      barcode: pw.Barcode.qrCode(),
                                      data: Appointments.isEmpty || IndexReservation.indexspot == 0 ? '' : '${widget.DoctorInfo['firstname'].toString().toUpperCase()[0]}${widget.DoctorInfo['speciality'].toString().toUpperCase()[0]}${IndexReservation.indexspot}${Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString().toUpperCase()[0]}${SelectedDate.day}${Appointments['${IndexReservation.indexspot}']['Plastname'].toString().toUpperCase()[0]}${SelectedDate.month}${Appointments['${IndexReservation.indexspot}']['Pold'].toString().toUpperCase()[0]}',
                                    ),
                                  )
                                ],
                              ),
                              build: (context) => [
                                pw.Container(
                                  padding: pw.EdgeInsets.only(),
                                  height: height*0.78,
                                  width: width*0.3,
                                  decoration: pw.BoxDecoration(
                                    color: PdfColors.white,
                                  ),
                                  child: pw.Column(
                                    mainAxisAlignment: pw.MainAxisAlignment.start,
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Padding(
                                        padding: pw.EdgeInsets.only(top: height*0.025,bottom: height*0.025),
                                        child: pw.Divider(
                                          height: 0.1,
                                          color: PdfColors.grey,
                                        ),
                                      ),

                                      pw.Row(
                                        mainAxisAlignment: pw.MainAxisAlignment.start,
                                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                                        children: [
                                          pw.Text(
                                            LanguageContent.isEmpty ? '' : LanguageContent['En']['FullName'],
                                            style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.019,letterSpacing: 1,fontWeight: pw.FontWeight.bold),
                                          ),
                                          pw.Text(
                                            ' : ${Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString()} ${Appointments['${IndexReservation.indexspot}']['Plastname'].toString()}   ',
                                            style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.019,letterSpacing: 1),
                                          ),
                                          pw.Text(
                                            LanguageContent.isEmpty ? '' : LanguageContent['En']['Old'],
                                            style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.019,letterSpacing: 1,fontWeight: pw.FontWeight.bold),
                                          ),
                                          pw.Text(
                                            ' : ${Appointments['${IndexReservation.indexspot}']['Pold'].toString()}   ',
                                            style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.019,letterSpacing: 1),
                                          ),
                                        ],
                                      ),
                                      pw.SizedBox(
                                        height: height*0.01,
                                      ),
                                      pw.Row(
                                        children: [
                                          pw.Text(
                                            LanguageContent.isEmpty ? '' : LanguageContent['En']['Ap Id'],
                                            style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.019,letterSpacing: 1,fontWeight: pw.FontWeight.bold),
                                          ),
                                          pw.Text(
                                            ' : ${Appointments['${IndexReservation.indexspot}']['id'].toString()}',
                                            style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.019,letterSpacing: 1),
                                          ),
                                        ],
                                      ),

                                      pw.Padding(
                                        padding: pw.EdgeInsets.only(top: height*0.035,bottom: height*0.025),
                                        child: pw.Row(
                                          mainAxisAlignment: pw.MainAxisAlignment.center,
                                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                                          children: [
                                            pw.Text(
                                              LanguageContent.isEmpty ? '' : LanguageContent['En']['Medicines'],
                                              style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.045,letterSpacing: 1,fontWeight: pw.FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),

                                      pw.Padding(
                                        padding: pw.EdgeInsets.only(top: height*0.03,bottom: height*0.03),
                                        child: pw.SizedBox(
                                          height: height*0.41,
                                          child: pw.ListView.builder(
                                            itemCount: Medicines.length,
                                            itemBuilder: (context, index) {
                                              return pw.Padding(
                                                padding: pw.EdgeInsets.only(bottom: height*0.02),
                                                child: pw.Column(
                                                  children: [
                                                    pw.Row(
                                                      mainAxisAlignment: pw.MainAxisAlignment.start,
                                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                      children: [
                                                        pw.Text(
                                                          '${index + 1}- ',
                                                          style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.02,letterSpacing: 1,fontWeight: pw.FontWeight.bold),
                                                        ),
                                                        pw.Text(
                                                          Medicines[index]['name'],
                                                          style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.02,letterSpacing: 2,fontWeight: pw.FontWeight.bold,),
                                                        ),
                                                      ],
                                                    ),
                                                    pw.Row(
                                                      mainAxisAlignment: pw.MainAxisAlignment.start,
                                                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                      children: [
                                                        pw.Text(
                                                          '${Medicines[index]['howMany']} ${LanguageContent['En']['packages']} ${LanguageContent['En']['and take it']} ${Medicines[index]['howOften']} ${Medicines[index]['after'] ? '${LanguageContent['En']['after eating']}' : '${LanguageContent['En']['before eating']}'}',
                                                          style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.017,letterSpacing: 1),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            )
                          ); // Page
                          await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
                        }, 
                        icon: Image.asset('assets/icons/file-export.png',height: height*0.025,width: height*0.025,),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: MainPadding(height, width*0.2),
                        height: height*0.78,
                        width: width*0.3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height*0.09,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MyTitle('Dr.${widget.DoctorInfo['firstname']} ${widget.DoctorInfo['lastname']}', Colors.black, height*0.02),
                                      MyDescription(widget.DoctorInfo['speciality'].toString(), Colors.black, height*0.015, 1),
                                      Appointments.isEmpty ? Container() : MyDescription(IndexReservation.indexspot == 0 ? '#' : '#${widget.DoctorInfo['firstname'].toString().toUpperCase()[0]}${widget.DoctorInfo['speciality'].toString().toUpperCase()[0]}${IndexReservation.indexspot}${Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString().toUpperCase()[0]}${SelectedDate.day}${Appointments['${IndexReservation.indexspot}']['Plastname'].toString().toUpperCase()[0]}${SelectedDate.month}${Appointments['${IndexReservation.indexspot}']['Pold'].toString().toUpperCase()[0]}', Colors.black, height*0.015, 1),
                                    ],
                                  ),
                                  MyExpandedRow(),
                                  Image.network(ClinicLogo,height: height*0.06,),
                                ],
                              ),
                            ),
                                      
                            Padding(
                              padding: EdgeInsets.only(top: height*0.015,bottom: height*0.015),
                              child: Divider(),
                            ),
                                      
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyText(LanguageContent.isEmpty || IndexReservation.indexspot == 0 ? '' : LanguageContent['En']['FullName'], Colors.black, height*0.013),
                                Appointments.isEmpty || IndexReservation.indexspot == 0 ? Container() : MyDescription(' : ${Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString()} ${Appointments['${IndexReservation.indexspot}']['Plastname'].toString()}   ', Colors.black, height*0.013, 1),
                                MyText(LanguageContent.isEmpty || IndexReservation.indexspot == 0 ? '' : LanguageContent['En']['Old'], Colors.black, height*0.013),
                                Appointments.isEmpty || IndexReservation.indexspot == 0 ? Container() : MyDescription(' : ${Appointments['${IndexReservation.indexspot}']['Pold'].toString()}   ', Colors.black, height*0.013, 1),
                              ],
                            ),
                            SizedBox(
                              height: height*0.01,
                            ),
                            Row(
                              children: [
                                MyText(LanguageContent.isEmpty || IndexReservation.indexspot == 0 ? '' : LanguageContent['En']['Ap Id'], Colors.black, height*0.013),
                                Appointments.isEmpty || IndexReservation.indexspot == 0 ? Container() : MyDescription(' : ${Appointments['${IndexReservation.indexspot}']['id'].toString()}', Colors.black, height*0.013, 1),
                              ],
                            ),
                              
                            Padding(
                              padding: EdgeInsets.only(top: height*0.015,bottom: height*0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  MyTitle(LanguageContent.isEmpty ? '' : LanguageContent['En']['Medicines'], Colors.black, height*0.03),
                                ],
                              ),
                            ),
                                      
                            Padding(
                              padding: EdgeInsets.only(top: height*0.005,bottom: height*0.005),
                              child: SizedBox(
                                height: height*0.41,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: Medicines.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: height*0.01),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              MyText('${index + 1}- ', Colors.black, height*0.016),
                                              MyText(Medicines[index]['name'], Colors.black, height*0.016),
                                              const Expanded(child: SizedBox(width: 1,)),
                                              GestureDetector(
                                                onTap: () {
                                                  print('remove');
                                                  setState(() {
                                                    Medicines.removeAt(index);
                                                  });
                                                },
                                                child: Icon(Icons.remove_circle_outline,color: Colors.red,size: height*0.02,)
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              MyDescription('${Medicines[index]['howMany']} ${LanguageContent['En']['packages']} ${LanguageContent['En']['and take it']} ${Medicines[index]['howOften']} ${Medicines[index]['after'] ? '${LanguageContent['En']['after eating']}' : '${LanguageContent['En']['before eating']}'}', Colors.black, height*0.013, 1),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: height*0.05,
                                      width: height*0.05,
                                      child: WidgetsToImage(
                                        controller: ScreenShotController,
                                        child: PrettyQrView.data(
                                          data: Appointments.isEmpty || IndexReservation.indexspot == 0 ? '' : '${widget.DoctorInfo['firstname'].toString().toUpperCase()[0]}${widget.DoctorInfo['speciality'].toString().toUpperCase()[0]}${IndexReservation.indexspot}${Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString().toUpperCase()[0]}${SelectedDate.day}${Appointments['${IndexReservation.indexspot}']['Plastname'].toString().toUpperCase()[0]}${SelectedDate.month}${Appointments['${IndexReservation.indexspot}']['Pold'].toString().toUpperCase()[0]}',
                                          decoration: const PrettyQrDecoration(
                                            image: PrettyQrDecorationImage(
                                              scale: 0.3,
                                              image: AssetImage('assets/icons/CareWaseLog.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //------------------------------------------------------------------------------------------
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.03),
                  child: Container(
                    padding: EdgeInsets.only(right: height*0.01, bottom: height*0.01, left: height*0.01),
                    height: height*0.36,
                    width: height*0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height*0.02),
                      border: Border.all(width: 0.7,color: Colors.black),
                    ),
                    child: CalendarCarousel(
                      selectedDateTime: SelectedDate,
                      targetDateTime: NowaDay,
                      daysTextStyle: TextStyle(color: Colors.black, fontFamily: 'H3', fontSize: height*0.017),
                      selectedDayTextStyle: TextStyle(color: Colors.black, fontFamily: 'H3', fontSize: height*0.017),
                      todayTextStyle: TextStyle(color: Colors.black, fontFamily: 'H3', fontSize: height*0.017),
                      headerTextStyle: TextStyle(color: Colors.black, fontFamily: 'H2', fontSize: height*0.025,fontWeight: FontWeight.bold),
                      weekdayTextStyle: TextStyle(color: Colors.black, fontFamily: 'H3', fontSize: height*0.017),
                      weekendTextStyle: TextStyle(color: Colors.black, fontFamily: 'H3', fontSize: height*0.017),
                      iconColor: Colors.black,
                      selectedDayButtonColor: Colors.transparent,
                      todayButtonColor: Colors.transparent,
                      customDayBuilder: (isSelectable, index, isSelectedDay, isToday, isPrevMonthDay, textStyle, isNextMonthDay, isThisMonthDay, day) {
                        if (isSelectedDay) {
                          return Container(
                            alignment: Alignment.center,
                            height: height*0.0625,
                            width: height*0.0625,
                            decoration: BoxDecoration(
                              color: MainColor,
                              borderRadius: BorderRadius.circular(height*0.012),
                            ),
                            child: MyDescription(day.day.toString(), Colors.black, height*0.017, 1),
                          );
                        }
                        if ('${day.day}/${day.month}' == '${NowaDay.day}/${NowaDay.month}') {
                          return Container(
                            alignment: Alignment.center,
                            height: height*0.0625,
                            width: height*0.0625,
                            decoration: BoxDecoration(
                              color: MainColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(height*0.012),
                            ),
                            child: MyDescription(day.day.toString(), Colors.black, height*0.017, 1),
                          );
                        }
                      },
                      onDayPressed: (p0, p1) {
                        setState(() {
                          SelectedDate = p0;
                        });
                      },
                    ),
                  ),
                ),

                //-------------------------------
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.01),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: height*0.01),
                        child: Container(
                          alignment: Alignment.center,
                          height: height*0.08,
                          width: width*0.0925,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(height*0.02),
                            border: Border.all(width: 0.7,color: Colors.black)
                          ),
                          child: MyText(LanguageContent.isEmpty ? '' : '${IndexReservation.emptyspots} ${LanguageContent['En']['Empty Spots']}', Colors.black, height*0.02),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Container(
                          alignment: Alignment.center,
                          height: height*0.08,
                          width: width*0.0925,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(height*0.02),
                            border: Border.all(width: 0.7,color: Colors.black)
                          ),
                          child: MyText(LanguageContent.isEmpty ? '' : '${IndexReservation.indexspot} ${LanguageContent['En']['Live Spot']}', Colors.black, height*0.02),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.01),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: height*0.01),
                        child: Container(
                          alignment: Alignment.center,
                          height: height*0.08,
                          width: width*0.0925,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(height*0.02),
                            border: Border.all(width: 0.7,color: Colors.black)
                          ),
                          child: MyText(LanguageContent.isEmpty ? '' : '${IndexReservation.spot} ${LanguageContent['En']['Spot']}', Colors.black, height*0.02),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Container(
                          alignment: Alignment.center,
                          height: height*0.08,
                          width: width*0.0925,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(height*0.02),
                            border: Border.all(width: 0.7,color: Colors.black)
                          ),
                          child: MyText(LanguageContent.isEmpty ? '' : '${IndexReservation.spots} ${LanguageContent['En']['All Spots']}', Colors.black, height*0.02),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.03),
                  child: GestureDetector(
                    onTap: () async {
                      if (IndexReservation.spot == 0) {
                        CherryToast.info(title: MyDescription(LanguageContent['En']['Cherry info message start visiting'], Colors.black, height*0.03, 3)).show(context);
                      } else if ((IndexReservation.indexspot + 1) > IndexReservation.spot){
                        CherryToast.info(title: MyDescription(LanguageContent['En']['Cherry info message wait for new appointment'], Colors.black, height*0.03, 2)).show(context);
                      } else {
                        if (IndexReservation.indexspot == 0) {
                          await FirebaseFirestore.instance.collection(MainCo).doc(widget.DoctorInfo['id']).collection('Reservations').doc('${NowaDay.month}_${NowaDay.day}_${NowaDay.year}').update({
                            'indexspot' : IndexReservation.indexspot + 1,
                          });
                        } else {
                          await FirebaseFirestore.instance.collection('Prescriptions').doc('${widget.DoctorInfo['firstname'].toString().toUpperCase()[0]}${widget.DoctorInfo['speciality'].toString().toUpperCase()[0]}${IndexReservation.indexspot}${Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString().toUpperCase()[0]}${SelectedDate.day}${Appointments['${IndexReservation.indexspot}']['Plastname'].toString().toUpperCase()[0]}${SelectedDate.month}${Appointments['${IndexReservation.indexspot}']['Pold'].toString().toUpperCase()[0]}').set(
                            Prescription(
                              code: '${widget.DoctorInfo['firstname'].toString().toUpperCase()[0]}${widget.DoctorInfo['speciality'].toString().toUpperCase()[0]}${IndexReservation.indexspot}${Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString().toUpperCase()[0]}${SelectedDate.day}${Appointments['${IndexReservation.indexspot}']['Plastname'].toString().toUpperCase()[0]}${SelectedDate.month}${Appointments['${IndexReservation.indexspot}']['Pold'].toString().toUpperCase()[0]}', 
                              date: DateFormat.yMd().format(SelectedDate), 
                              Did: widget.DoctorInfo['id'], 
                              Dfirstname: widget.DoctorInfo['firstname'], 
                              Dlastname: widget.DoctorInfo['lastname'], 
                              Pid: Appointments['${IndexReservation.indexspot}']['Pid'].toString(), 
                              Pfirstname: Appointments['${IndexReservation.indexspot}']['Pfirstname'].toString(), 
                              Plastname: Appointments['${IndexReservation.indexspot}']['Plastname'].toString(), 
                              medications: Medicines,
                            ).toJson(),
                          ).whenComplete(() async {
                            await FirebaseFirestore.instance.collection('Appointments').doc(Appointments['${IndexReservation.indexspot}']['id']).update({
                              'paid' : true,
                            });
                            Future.delayed(Duration(milliseconds: 500), () async {
                              await FirebaseFirestore.instance.collection(MainCo).doc(widget.DoctorInfo['id']).collection('Reservations').doc('${NowaDay.month}_${NowaDay.day}_${NowaDay.year}').update({
                                'indexspot' : IndexReservation.indexspot + 1,
                              });
                            });
                            setState(() {
                              Medicines.clear();
                            });
                          });
                        }
                      }
                    },
                    child: MyButton(LanguageContent.isEmpty ? '' : IndexReservation.indexspot == 0 ? LanguageContent['En']['Start Visiting'] : LanguageContent['En']['Next Spot'].toString(), height*0.07, width*0.191, MainColor, height*0.02)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height*0.03),
                  child: Container(
                    padding: EdgeInsets.only(top: height*0.01,right: width*0.005,left: width*0.01),
                    height: height*0.15,
                    width: width*0.191,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(height*0.02),
                      border: Border.all(width: 0.7,color: Colors.black),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.12,
                              child: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['FullName'], Colors.black, height*0.013, 1)
                            ),
                            SizedBox(
                              child: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Spot'], Colors.black, height*0.013, 1)
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.12,
                              child: MyText(Appointments.isEmpty ? '' : IndexReservation.indexspot == 0 ? '' : '${Appointments['${IndexReservation.indexspot}']['Pfirstname']} ${Appointments['${IndexReservation.indexspot}']['Plastname']}', Colors.black, height*0.017)
                            ),
                            SizedBox(
                              child: MyText(Appointments.isEmpty ? '' : IndexReservation.indexspot == 0 ? '' : Appointments['${IndexReservation.indexspot}']['spot'].toString(), Colors.black, height*0.017)
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.12,
                              child: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Patient ID'], Colors.black, height*0.013, 1)
                            ),
                            SizedBox(
                              child: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Old'], Colors.black, height*0.013, 1)
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.12,
                              child: MyText(Appointments.isEmpty ? '#' : IndexReservation.indexspot == 0 ? '#' : '#${Appointments['${IndexReservation.indexspot}']['Pid']}', Colors.black, height*0.017)
                            ),
                            SizedBox(
                              child: MyText(Appointments.isEmpty ? '' : IndexReservation.indexspot == 0 ? '' :  Appointments['${IndexReservation.indexspot}']['Pold'].toString(), Colors.black, height*0.017)
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.12,
                              child: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Appointment ID'], Colors.black, height*0.013, 1)
                            ),
                            SizedBox(
                              child: MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Paid'], Colors.black, height*0.013, 1)
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: width*0.12,
                              child: MyText(Appointments.isEmpty ? '#' : IndexReservation.indexspot == 0 ? '#' :  '#${Appointments['${IndexReservation.indexspot}']['id']}', Colors.black, height*0.017)
                            ),
                            SizedBox(
                              child: MyText(Appointments.isEmpty ? '' : IndexReservation.indexspot == 0 ? '' :  Appointments['${IndexReservation.indexspot}']['paid'].toString(), Colors.black, height*0.017)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      )
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


  //Fetch reservation
  Future FetchReservation() async {
    await FirebaseFirestore.instance.collection(MainCo).doc(widget.DoctorInfo['id']).collection('Reservations').where('date', isEqualTo: DateFormat.yMd().format(NowaDay)).snapshots().listen((event) { 
      if (event.docs.isEmpty) {
        FirebaseFirestore.instance.collection(MainCo).doc(widget.DoctorInfo['id']).collection('Reservations').doc('${SelectedDate.month}_${SelectedDate.day}_${SelectedDate.year}').set({
          'id': '${SelectedDate.month}_${SelectedDate.day}_${SelectedDate.year}',
          'spots' : 20,
          'date' : DateFormat.yMd().format(NowaDay),
          'spot' : 0,
          'emptyspots' : 20,
          'indexspot': 0,
        });
        setState(() {
          IndexReservation = Reservations(
            id: '${SelectedDate.month}_${SelectedDate.day}_${SelectedDate.year}', 
            spot: 0, 
            spots: 20, 
            emptyspots: 20, 
            indexspot: 0, 
            date: DateFormat.yMd().format(SelectedDate),
          );
        });
      } else {
        event.docs.forEach((element) { 
          setState(() {
            IndexReservation = Reservations(
              id: element.data()['id'], 
              spot: element.data()['spot'], 
              spots: element.data()['spots'], 
              emptyspots: element.data()['emptyspots'], 
              indexspot: element.data()['indexspot'], 
              date: element.data()['date']
            );
            Spot = element.data()['spot'] + 1; 
          });
        });
      }
    });
  }

  //Fetch appointment
  Future FetchIndexAppointment() async {
    await FirebaseFirestore.instance.collection('Appointments').where('Did', isEqualTo: widget.DoctorInfo['id']).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        if (element.data()['date'] == DateFormat.yMd().format(SelectedDate)) {
          setState(() {
            Appointments.addAll({
              '${element.data()['spot']}' : element.data(),
            });
          });
        }
      });
    });
  }

  //
  Future CreateAppointment() async {
    //CHANGE EMAIL TO ID **************************************************************************************
    await FirebaseFirestore.instance.collection('Appointments').doc('${SelectedDate.day}${firstnamecontroller.text.toString()[0].toString().toUpperCase()}${lastnamecontroller.text.toString()[0].toString().toUpperCase()}$Spot${widget.DoctorInfo['firstname'][0].toUpperCase()}${widget.DoctorInfo['lastname'][0].toUpperCase()}${widget.DoctorInfo['adr']['province'][0].toString().toUpperCase()}${widget.DoctorInfo['adr']['province'][1].toString().toUpperCase()}${NowaDay.hour}${NowaDay.minute}${NowaDay.second}').set(
      Appointment(
        id: '${SelectedDate.day}${firstnamecontroller.text.toString()[0].toString().toUpperCase()}${lastnamecontroller.text.toString()[0].toString().toUpperCase()}$Spot${widget.DoctorInfo['firstname'][0].toUpperCase()}${widget.DoctorInfo['lastname'][0].toUpperCase()}${widget.DoctorInfo['adr']['province'][0].toString().toUpperCase()}${widget.DoctorInfo['adr']['province'][1].toString().toUpperCase()}${NowaDay.hour}${NowaDay.minute}${NowaDay.second}', 
        fromapp: true,
        date: DateFormat.yMd().format(SelectedDate), 
        Did: widget.DoctorInfo['id'], 
        Dfirstname: widget.DoctorInfo['firstname'], 
        Dlastname: widget.DoctorInfo['lastname'], 
        Pid: '0000000', 
        Pfirstname: firstnamecontroller.text.trim(), 
        Plastname: lastnamecontroller.text.trim(), 
        Pold: int.parse(oldcontroller.text.trim()), 
        spot: Spot, 
        state: 'Waiting', 
        adr: {
          'locality' : widget.DoctorInfo['adr']['locality'],
          'province' : widget.DoctorInfo['adr']['province'],
        }, 
        paid: false, 
        paymentmethod: 'Cash',
      ).toJson(),
    );

    await FirebaseFirestore.instance.collection(MainCo).doc(widget.DoctorInfo['id']).collection('Reservations').doc(IndexReservation.id).update({
      'spot' : IndexReservation.spot + 1,
      'emptyspots' : IndexReservation.emptyspots - 1,
    });
  }

  
  //
  void _createPdf() async {
    final doc = pw.Document();

    /// for using an image from assets
    // final image = await imageFromAssetBundle('assets/image.png');

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('Hello eclectify Enthusiast'),
          ); // Center
        },
      ),
    ); // Page

    /// print the document using the iOS or Android print service:
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());

    /// share the document to other applications:
    // await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');

    /// tutorial for using path_provider: https://www.youtube.com/watch?v=fJtFDrjEvE8
    /// save PDF with Flutter library "path_provider":
    // final output = await getTemporaryDirectory();
    // final file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await doc.save());
  }

}