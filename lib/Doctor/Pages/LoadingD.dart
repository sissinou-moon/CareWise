import 'package:carewise/Classes/MyTransition.dart';
import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Doctor/Pages/SourceD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDPage extends StatefulWidget {
  String DoctorId;
  LoadingDPage({super.key, required this.DoctorId});

  @override
  State<LoadingDPage> createState() => _LoadingDPageState();
}

class _LoadingDPageState extends State<LoadingDPage> {

  //MAP
  Map? DoctorInfo;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 5),() {
      FetchDoctorInfo();
    });

    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(context, TransitionFirstType(SourceDPage(DoctorInfo: DoctorInfo!,)));
    });
  }


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.8),
            child: Lottie.asset('assets/animations/Animation - 1709541325864.json',height: height*0.8)
          ),
        ],
      ),
    );
  }

  Future<void> FetchDoctorInfo() async {
    await FirebaseFirestore.instance.collection(MainCo).where('id', isEqualTo: widget.DoctorId).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        setState(() {
          DoctorInfo = element.data();
        });
      });
    });
  }
}