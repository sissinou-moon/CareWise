// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:async';

import 'package:carewise/Classes/MyTransition.dart';
import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Objects/DoctorC.dart';
import 'package:carewise/Objects/PatientC.dart';
import 'package:carewise/Patient/Pages/DoctorPage.dart';
import 'package:carewise/Patient/Pages/SearchHightLvl.dart';
import 'package:carewise/Patient/providers/SearchProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tip_dialog/tip_dialog.dart';

class DisplayMap extends StatefulWidget {
  Patient patient;
  DisplayMap({super.key, required this.patient});

  @override
  State<DisplayMap> createState() => _DisplayMapState();
}

class _DisplayMapState extends State<DisplayMap> {


  //GOOGLE MAP TOOLS
    //CONTROLLER
      final Completer<GoogleMapController> _controller =
          Completer<GoogleMapController>();

    //INIT CAMERA
      static const CameraPosition FirstSpawn = CameraPosition(
        target: LatLng(0, 0),
        zoom: 14.4746,
      );
      

    //markers
      Set<Marker> Markers = {};
      Set<Marker> SelectedStations = {};

    //icon
      BitmapDescriptor MedIcon = BitmapDescriptor.defaultMarker;
      BitmapDescriptor HosIcon = BitmapDescriptor.defaultMarker;

    //Markers
      Set<Marker> markers = {}; 

    //CustomInfoWindow
     CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  //-----------------------------------------------------------------------

  //MAP
  Map Result = {
    '1': 'test',
    '2': 12,
    '3': 7.3, 
  };

  //LISTS 
  List<String> Specialties = [
    'Diabetes',
    'Radiology',
    'Neurology',
    'Otology',
    'Ophthalmology',
    'Rhinology',
    'Cariology',
    'Gastroenterology',
    'Pulmonology, ',
    'Hepatology',
    'Orthopedics',
  ];
  List<String> SpecIcons = [
    'diabetes',
    'xray',
    'neurology',
    'otology',
    'eye',
    'rhinology',
    'tooth-hygiene',
    'intestine',
    'pulmonology',
    'hepatology',
    'fracture',
  ];
  List<String> Types = [
    'male',
    'female',
    'hospital',
  ];
  List<String> TypesIcons = [
    'doctor',
    'doctor_woman',
    'hospital',
  ];

  //STRINGS
  String SpecIndex = 'Diabetes';
  String TypeIndex = 'male';

  //INT 
  int IconIndex = 0;
  int ElementIndex = 0;

  @override
  void initState() {
    super.initState();
    addCustomIcon();

    Future.delayed(Duration(seconds: 1), () {
      GoToUserLocation();
    });

    Provider.of<SearchProvider>(context, listen: false).addListener(() { 
      setState(() {
        SpecIndex = Provider.of<SearchProvider>(context, listen: false).Specialtie;
        TypeIndex = Provider.of<SearchProvider>(context, listen: false).Type;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    //context.watch<SearchProvider>().Specialtie;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: FirstSpawn,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onTap: (argument) {
              _customInfoWindowController.hideInfoWindow!();
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: height*0.045,
            width: width*0.52,
            offset: 50,
          ),
          Align(
            alignment: Alignment(-1, -0.85),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              icon: Container(
                height: height*0.05,
                width: height*0.05,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(height),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 218, 217, 217).withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(0, 4),                  
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.02,),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.88),
            child: Container(
              height: TypeIndex != 'Hospital' ?  height*0.27 : height*0.205,
              width: width*0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(height*0.02),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 218, 217, 217).withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(0, 4),                  
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.5,
                    child: Opacity(
                      opacity: 0.2,
                      child: SvgPicture.asset('assets/images/Ambulance-amico.svg'),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -1),
                    child: Padding(
                      padding: EdgeInsets.only(right: width*0.03,top: height*0.01,left: width*0.03),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: height*0.01),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(right: width*0.03, top: height*0.011, bottom: height*0.011, left: width*0.03),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(height*0.018),
                                ),
                                hintText: Provider.of<SearchProvider>(context, listen: false).Location == '' ? 'Your Location' : Provider.of<SearchProvider>(context, listen: false).Location,
                                suffixIcon: Icon(Icons.location_searching_outlined),
                                enabled: false,
                              ),
                            ),
                          ),
                          TypeIndex != 'Hospital' ? Padding(
                            padding: EdgeInsets.only(bottom: height*0.01),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(height*0.02),
                                      border: Border.all(width: 0.8),
                                    ),
                                    child: DropdownButton( 
                                      // Initial Value 
                                      value: SpecIndex, 
                                    
                                      // Down Arrow Icon 
                                      icon: const Icon(Icons.keyboard_arrow_down), 
                                    
                                      //
                                      underline: Divider(color: Colors.transparent,),    

                                      //borderRadius
                                      borderRadius: BorderRadius.circular(height*0.02),
                                    
                                      // Array list of items 
                                      items: Specialties.map((String items) { 
                                        return DropdownMenuItem( 
                                          value: items, 
                                          child: Row(
                                            children: [
                                              SizedBox(width: width*0.04,),
                                              SizedBox(
                                                width: width*0.51,
                                                child: Text(items),
                                              ),
                                              SizedBox(width: width*0.1,),
                                              Image.asset('assets/icons/${SpecIcons[Specialties.indexOf(items)]}.png',height: height*0.03,)
                                            ],
                                          ), 
                                        ); 
                                      }).toList(), 
                                      // After selecting the desired option,it will 
                                      // change button value to selected value 
                                      onChanged: (String? newValue) {  
                                        setState(() { 
                                          SpecIndex = newValue!; 
                                        }); 
                                      }, 
                                    ),
                                  ),
                                ),
                              ],
                            ), 
                          ) : Container(),
                          Padding(
                            padding: EdgeInsets.only(bottom: height*0.01),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(height*0.02),
                                      border: Border.all(width: 0.8),
                                    ),
                                    child: DropdownButton( 
                                      // Initial Value 
                                      value: TypeIndex, 
                                    
                                      // Down Arrow Icon 
                                      icon: const Icon(Icons.keyboard_arrow_down), 
                                    
                                      //
                                      underline: const Divider(color: Colors.transparent,),    

                                      //borderRadius
                                      borderRadius: BorderRadius.circular(height*0.02),
                                    
                                      // Array list of items 
                                      items: Types.map((String items) { 
                                        return DropdownMenuItem( 
                                          value: items, 
                                          child: Row(
                                            children: [
                                              SizedBox(width: width*0.04,),
                                              SizedBox(
                                                width: width*0.51,
                                                child: Text(items),
                                              ),
                                              SizedBox(width: width*0.1,),
                                              Image.asset('assets/icons/${TypesIcons[Types.indexOf(items)]}.png',height: height*0.03,)
                                            ],
                                          ), 
                                        ); 
                                      }).toList(), 
                                      // After selecting the desired option,it will 
                                      // change button value to selected value 
                                      onChanged: (String? newValue) {  
                                        setState(() { 
                                          TypeIndex = newValue!; 
                                        }); 
                                      }, 
                                    ),
                                  ),
                                ),
                              ],
                            ), 
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, TransitionFirstType(
                                      Stack(
                                        children: [
                                          SearchHightLvl(),
                                          TipDialogContainer(duration: const Duration(seconds: 2)),
                                        ],
                                      )
                                    ));
                                  },
                                  child: MyButton('More', height*0.05, width, Colors.white, height*0.015),
                                ),
                              ),
                              SizedBox(
                                width: width*0.03,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Search(height,width);
                                    TipDialogHelper.loading("Loading");
                                    Future.delayed(Duration(seconds: 2), () {
                                      TipDialogHelper.dismiss();
                                    });
                                  },
                                  child: MyButton('Search', height*0.05, width, MainColor, height*0.015),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Go to user location
  Future<void> GoToUserLocation() async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition UserLocation = CameraPosition(
          target: LatLng(widget.patient.adr['latitude'], widget.patient.adr['longitude']),
          zoom: 17.5
      );
    await controller.animateCamera(CameraUpdate.newCameraPosition(UserLocation));
  }

  //Custome icon
  void addCustomIcon() {
    print("************");
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'assets/icons/med_loc.png').then(
        (icon) {
          setState(() {
            MedIcon = icon;
          });
        }
      );
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'assets/icons/hospital_loc.png',).then(
        (icon) {
          setState(() {
            HosIcon = icon;
          });
        }
      );
  }

  //Search 
  Future Search(double height, double width) async {
    setState(() {
      markers = {};
    });
    return await FirebaseFirestore.instance.collection(MainCo).where('speciality', isEqualTo: SpecIndex).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        if(element['sexe'] == TypeIndex) {
          if(Provider.of<SearchProvider>(context, listen: false).Location == '' ? (element['adr']['locality'] == widget.patient.adr['locality']) : (element['adr']['locality'] == Provider.of<SearchProvider>(context, listen: false).Location.split(',')[0])) {
            setState(() {
              markers.add(
                Marker(
                  markerId: MarkerId('$IconIndex'),
                  icon: MedIcon,
                  position: LatLng(element['adr']['latitude'], element['adr']['longitude']),
                  onTap: () {
                    _customInfoWindowController.addInfoWindow!(
                      Container(
                        height: height,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(height*0.013),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: width*0.02, top: height*0.002,bottom: height*0.002),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText('Firstname : ${element['firstname']}', Colors.black, height*0.012),
                                    MyText('Lastname : ${element['lastname']}', Colors.black, height*0.012),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, TransitionFirstType(DoctorPage(DoctorMap: element.data(),)));
                              },
                              child: Container(
                                height: height,
                                width: width*0.07,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(height*0.013),bottomRight: Radius.circular(height*0.013)),
                                ),
                                child: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: height*0.022,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      LatLng(element['adr']['latitude'], element['adr']['longitude']),
                    );
                  },
                ),
              );
              IconIndex++;
            });
          }
        }
      });
    });
  }


  //
  void CreateMedObject() async {
    Doctor mydoctor = Doctor(
      firstname: 'Taje Dine', 
      lastname: 'Ali', 
      sexe: 'female', 
      email: 'nour@gmail.com', 
      id: '2DSQ84XQ', 
      speciality: 'Radiology', 
      phonenumber: 0648213648, 
      adr: {
        'latitude' : 35.797837,
        'longitude' : 0.681257,
        'Province' : 'Relizane Province',
        'Locality' : 'Oued El Djemaa',
      }, 
      yourown: true, 
      relation: {
        'id' : '2DSQ84XQ',
        'type' : 'private',
      }, 
      bio: 'As a doctor, your professional bio is one of the most powerful tools you have to showcase your expertise and attract potential patients. In this blog, we will provide you with key elements to include in a well-crafted physician bio and showcase some doctor bio examples that do a great job of using these elements.', 
      workDays: 'Monday - Friday', 
      workHours: '8:00 - 17:30', 
      appointmentprice: 2000,
    );

    await FirebaseFirestore.instance.collection(MainCo).doc(mydoctor.id).set(mydoctor.toJson());
  }
}