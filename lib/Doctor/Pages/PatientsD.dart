import 'dart:convert';

import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Objects/AppointmentC.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PatientsDPage extends StatefulWidget {
  Map DoctorInfo;
  PatientsDPage({super.key, required this.DoctorInfo});

  @override
  State<PatientsDPage> createState() => _PatientsDPageState();
}

class _PatientsDPageState extends State<PatientsDPage> {

  //DATE
  DateTime NowaDay = DateTime.now();
  DateTime SelectedDate = DateTime.now();

  //MAP
  Map LanguageContent = {};
  List<Map> Appointments = [];
  List<Map> Prescriptions = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 10), () {
      readJson();
      ReadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(height*0.06),
      height: height,
      width: width*0.85,
      child: Container(
        padding: EdgeInsets.only(right: width*0.01,top:height*0.02,left: width*0.01),
        height: height,
        width: width*0.78,
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
                  MyText(LanguageContent.isEmpty ? '' : LanguageContent['En']['Patients Details'], Colors.white, height*0.03),
                  MyExpandedRow(),
                  GestureDetector(
                    onTap: () {
                      print(Appointments);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: height*0.05,
                      width: width*0.08,
                      decoration: BoxDecoration(
                        color: widget.DoctorInfo['sexe'] == 'female' ? ThirdColor : MainColor,
                        borderRadius: BorderRadius.circular(height*0.013),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/file-user.png',height: height*0.025,),
                          SizedBox(width: width*0.005,),
                          MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Export'], Colors.black, height*0.017, 1),
                        ],
                      ),
                    ),
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
                    width: width*0.15,
                    child: MyDescription('Name', Colors.white.withOpacity(0.6), height*0.017,1)
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: width*0.08,
                    child: MyDescription('Date', Colors.white.withOpacity(0.6), height*0.017,1)
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: width*0.08,
                    child: MyDescription('Spot', Colors.white.withOpacity(0.6), height*0.017,1)
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: width*0.08,
                    child: MyDescription('Paid', Colors.white.withOpacity(0.6), height*0.017,1)
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: width*0.15,
                    child: MyDescription('Payment Method', Colors.white.withOpacity(0.6), height*0.017,1)
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: width*0.08,
                    child: MyDescription('Prescription', Colors.white.withOpacity(0.6), height*0.017,1)
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
                width: width*0.78,
                child: Appointments.isEmpty ? Lottie.asset('assets/animations/708791546726.json') : ListView.builder(
                  itemCount: Appointments.length,
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
                                child: MyDescription(Appointments[index]['Pid'], Colors.white, height*0.017,1)
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: width*0.15,
                                child: MyDescription('${Appointments[index]['Pfirstname']} ${Appointments[index]['Plastname']}', Colors.white, height*0.017,1)
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: width*0.08,
                                child: MyDescription(Appointments[index]['date'], Colors.white, height*0.017,1)
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: width*0.08,
                                child: MyDescription(Appointments[index]['spot'].toString(), Colors.white, height*0.017,1)
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: width*0.08,
                                child: MyDescription(Appointments[index]['paid'].toString(), Colors.white, height*0.017,1)
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: width*0.15,
                                child: MyDescription(Appointments[index]['paymentlethod'], Colors.white, height*0.017,1)
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: width*0.08,
                                child: GestureDetector(
                                  onTap: () async {
                                    Prescriptions.forEach((element) async { 
                                      if (element['Pfirstname'] == Appointments[index]['Pfirstname'] && element['Plastname'] == Appointments[index]['Plastname']) {
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
                                                        '#${widget.DoctorInfo['firstname'].toString().toUpperCase()[0]}${widget.DoctorInfo['speciality'].toString().toUpperCase()[0]}${Appointments[index]['spot']}${Appointments[index]['Pfirstname'].toString().toUpperCase()[0]}${SelectedDate.day}${Appointments[index]['Plastname'].toString().toUpperCase()[0]}${SelectedDate.month}${Appointments[index]['Pold'].toString().toUpperCase()[0]}',
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
                                                    data: '${widget.DoctorInfo['firstname'].toString().toUpperCase()[0]}${widget.DoctorInfo['speciality'].toString().toUpperCase()[0]}${Appointments[index]['spot']}${Appointments[index]['Pfirstname'].toString().toUpperCase()[0]}${SelectedDate.day}${Appointments[index]['Plastname'].toString().toUpperCase()[0]}${SelectedDate.month}${Appointments[index]['Pold'].toString().toUpperCase()[0]}',
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
                                                          ' : ${Appointments[index]['Pfirstname'].toString()} ${Appointments[index]['Plastname'].toString()}   ',
                                                          style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.019,letterSpacing: 1),
                                                        ),
                                                        pw.Text(
                                                          LanguageContent.isEmpty ? '' : LanguageContent['En']['Old'],
                                                          style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.019,letterSpacing: 1,fontWeight: pw.FontWeight.bold),
                                                        ),
                                                        pw.Text(
                                                          ' : ${Appointments[index]['Pold'].toString()}   ',
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
                                                          ' : ${Appointments[index]['id'].toString()}',
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
                                                          itemCount: element['medications'].toList().length,
                                                          itemBuilder: (context, indexx) {
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
                                                                        element['medications'][indexx]['name'],
                                                                        style: pw.TextStyle(color: PdfColors.black, fontSize: height*0.02,letterSpacing: 2,fontWeight: pw.FontWeight.bold,),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  pw.Row(
                                                                    mainAxisAlignment: pw.MainAxisAlignment.start,
                                                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                                    children: [
                                                                      pw.Text(
                                                                        '${element['medications'][indexx]['howMany']} ${LanguageContent['En']['packages']} ${LanguageContent['En']['and take it']} ${element['medications'][indexx]['howOften']} ${element['medications'][indexx]['after'] ? '${LanguageContent['En']['after eating']}' : '${LanguageContent['En']['before eating']}'}',
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
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: height*0.03,
                                    width: width*0.07,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white,width: 0.3),
                                      borderRadius: BorderRadius.circular(height*0.009),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('assets/icons/upload(2).png',height: height*0.025,),
                                        SizedBox(width: width*0.003,),
                                        MyDescription(LanguageContent.isEmpty ? '' : LanguageContent['En']['Print it'], Colors.white, height*0.017, 1),
                                      ],
                                    ),
                                  ),
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

  //Read all appointments of this doctor
  void ReadAppointments() async {
    await FirebaseFirestore.instance.collection('Appointments').where('Did', isEqualTo: widget.DoctorInfo['id']).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        setState(() {
          Appointments.add(element.data());
        });
      });
    });
    await FirebaseFirestore.instance.collection('Prescriptions').where('Did', isEqualTo: widget.DoctorInfo['id']).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        setState(() {
          Prescriptions.add(element.data());
        });
      });
    });
  }
}