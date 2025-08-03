import 'package:carewise/Classes/MyTransition.dart';
import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/DB/firebase/FireStoreMain.dart';
import 'package:carewise/Objects/PatientC.dart';
import 'package:carewise/Patient/Pages/DisplayMapPage.dart';
import 'package:carewise/location/locationServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:tip_dialog/tip_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //MAPS
  Map PatientDetails = {};

  //INSTANCES
  Patient patient = Patient(
    {}, 
    'Mentally healthy', 
    'Good', 
    {}, 
    id: '12SDQ6F4', 
    firstname: 'Younes', 
    lastname: 'Mohamed', 
    old: 26, 
    sexe: 'male', 
    email: email!, 
    phonenumber: 656068431, 
    birthday: '27/11/2003', 
    allergic: false, 
    socialstate: 'Signle', 
    smoking: false,
  );


  //vars
  late LocationData _locatioDT;
  LocationService locationservice = LocationService();
  List<Placemark>? placemark;
  double _latitude = 0;
  double _longitude = 0;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height*0.02,
      ),
      body: Padding(
        padding: MainPadding(height, width),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: height*0.00),
              child: Row(
                children: [
                  MyTitle('Hi, ${PatientDetails['name'] == null ? email!.split('@')[0] : PatientDetails['name']}!', Colors.black, height*0.032),
                  MyExpandedRow(),
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    }, 
                    icon: Icon(Icons.notifications_outlined),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height*0.03),
              child: MyDescription('How are you feeling todday ?', Colors.black, height*0.015,1),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height*0.03),
              child: Container(
                padding: EdgeInsets.all(height*0.01),
                height: height*0.2,
                width: width,
                decoration: BoxDecoration(
                  color: MainColor,
                  borderRadius: BorderRadius.circular(height*0.02),
                  border: Border.all(width: 0.8,color: Colors.black),
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: height*0.015),
                          child: MyText('Stay At Home !', Colors.white, height*0.025),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: height*0.02),
                          child: MyDescription('Take care of your self', Colors.white, height*0.016,1),
                        ),
                        MyExpandedCollumn(),
                        Padding(
                          padding: EdgeInsets.only(bottom: height*0.005),
                          child: MyButton('Meet online', height*0.035, width*0.3, Colors.transparent, height*0.011),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment(4, 0),
                      child: SvgPicture.asset('assets/images/Fighting against Coronavirus-bro.svg',height: height*0.3,),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height*0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, TransitionFirstType(
                        Stack(
                          children: [
                            DisplayMap(patient: patient,),
                            TipDialogContainer(duration: const Duration(seconds: 3))
                          ],
                        )
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(height*0.01),
                      height: height*0.365,
                      width: width*0.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(height*0.02),
                        border: Border.all(width: 0.8,color: Colors.black),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: height*0.005),
                            child: MyText('Find a doctors', Colors.black, height*0.02),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: height*0.02),
                            child: MyDescription('200 doctor available now !', Colors.black, height*0.01,1),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height*0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/images/female_doctor.svg',height: height*0.22),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width*0.03,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          padding: EdgeInsets.only(right:height*0.01,top: height*0.01,left: height*0.01),
                          height: height*0.172,
                          width: width*0.38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(height*0.02),
                            border: Border.all(width: 0.8,color: Colors.black),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: height*0.005),
                                child: MyText('Order Medicine', Colors.black, height*0.017),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/images/First aid kit-bro.svg',height: height*0.12),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height*0.02,
                      ),
                      GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          padding: EdgeInsets.only(right:height*0.01,top: height*0.01,left: height*0.01),
                          height: height*0.172,
                          width: width*0.38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(height*0.02),
                            border: Border.all(width: 0.8,color: Colors.black),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 0),
                                child: MyText('Diagnostic test', Colors.black, height*0.017),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/images/Thermometer-rafiki.svg',height: height*0.132),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();

    FetchInfo(UsersCo, email!).then((value) {
      PatientDetails = value;
    });

    Future.delayed(Duration(milliseconds: 50), () {
      FindUserLocation();
      FetchInfo(UsersCo, email!).then((value) {
        setState(() {
          PatientDetails = value;
        });
      });
    });
  }

  //Find user location
  FindUserLocation() async {
    _locatioDT = await locationservice.GetUserLocation();
    setState(() {
      _latitude = _locatioDT.latitude!;
      _longitude = _locatioDT.longitude!;
    });
    final Placemark = await placemarkFromCoordinates(_latitude, _longitude);
    setState(() {
      placemark = Placemark;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        patient.adr = {
          'locality' : placemark![0].locality,
          'province' : placemark![0].administrativeArea,
          'latitude' : _latitude,
          'longitude' : _longitude,
        };
      });
    });
  }

}