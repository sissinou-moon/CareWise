// ignore_for_file: must_be_immutable

import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Patient/providers/SearchProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchHightLvl extends StatefulWidget { 
  SearchHightLvl({super.key});

  @override
  State<SearchHightLvl> createState() => _SearchHightLvlState();
}

class _SearchHightLvlState extends State<SearchHightLvl> {

  //CONTROLLERS
  final locationController = TextEditingController();
  final doctornameController = TextEditingController();

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
    'Pulmonology',
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

  List<List<String>> Results = [];

  //STRINGS
  String SpecIndex = 'Diabetes';
  String TypeIndex = 'male';

  //INT 
  int ThisField = 0;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined,size: height*0.022,),
        ),
      ),
      body: Padding(
        padding: MainPadding(height, width),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: height*0.01),
                child: TextField(
                  controller: locationController,
                  onChanged: (value) {
                    FetchLocations();
                    setState(() {
                      ThisField = 2;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(right: width*0.03, top: height*0.015, bottom: height*0.015, left: width*0.03),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(height*0.02),
                    ),
                    enabled: true,
                    hintText: "Enter the location"
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
                            context.read<SearchProvider>().WriteSearchDetails(locationController.text.trim(), SpecIndex, TypeIndex);
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
                padding: EdgeInsets.only(bottom: height*0.025),
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
                            context.read<SearchProvider>().WriteSearchDetails(locationController.text.trim(), SpecIndex, TypeIndex);
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
              Divider(
                height: 1.2,
                color: Colors.black,
                indent: 3,
                endIndent: 3,
              ),
              MyDescription(' Result :', Colors.black, height*0.017, 1),
              Padding(
                padding: EdgeInsets.only(top: height*0.01),
                child: SizedBox(
                  height: height*0.45,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    itemCount: Results.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: height*0.01),
                        child: GestureDetector(
                          onTap: () {
                            context.read<SearchProvider>().WriteSearchDetails('${Results[index][0]},${Results[index][1]}', SpecIndex, TypeIndex);
                            if (ThisField == 1) {
                              setState(() {
                                doctornameController.text = '${Results[index][0]},${Results[index][1]}';
                                Results.clear();
                              });
                            } else {
                              setState(() {
                                locationController.text = '${Results[index][0]},${Results[index][1]}';
                                Results.clear();
                              });
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(' ' + Results[index][0].toString(), Colors.black, height*0.02),
                              MyDescription(' ' + Results[index][1].toString(), Colors.black, height*0.015, 1),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<SearchProvider>().WriteSearchDetails(locationController.text.trim(), SpecIndex, TypeIndex);
                      locationController.text.isEmpty ? 
                        doctornameController.text.isEmpty ? 
                          null : 
                            Navigator.of(context).pop()
                            : 
                            Navigator.of(context).pop();
                    },
                    child: MyButton('Save', height*0.06, width*0.4, locationController.text.isEmpty ? doctornameController.text.isEmpty ? MainColor.withOpacity(0.2) : MainColor : MainColor, height*0.02),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  //Search for location
  Future FetchLocations() async {
    setState(() {
      Results.clear();
    });
    return await FirebaseFirestore.instance.collection(LocationCo).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        if (element.id.contains(locationController.text.trim())) {
          setState(() {
            Results.add([element.id,element.data()['relation'].toString()]);
          });
          print(Results[0][1]);
        }
      });
    });
  }

  //Search by doctor name
  Future FetchDoctorFirstName() async {
    setState(() {
      Results.clear();
    });
    await FirebaseFirestore.instance.collection(MainCo).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        if (element.data()['firstname'].toString().contains(doctornameController.text.trim())) {
          setState(() {
            Results.add([element.data()['firstname'].toString(),element.data()['lastname'].toString()]);
          });
          print(Results);
        }
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      if (Results.isEmpty) {
        FetchDoctorLastName();
      }
    });
  }
  Future FetchDoctorLastName() async {
    setState(() {
      Results.clear();
    });
    await FirebaseFirestore.instance.collection(MainCo).snapshots().listen((event) { 
      event.docs.forEach((element) { 
        if (element.data()['lastname'].toString().contains(doctornameController.text.trim())) {
          setState(() {
            Results.add([element.data()['firstname'].toString(),element.data()['lastname'].toString()]);
          });
          print(Results);
        }
      });
    });
    
    Future.delayed(Duration(seconds: 1), () {
      if (Results.isEmpty) {
        FetchDoctorFirstName();
      }
    });
  }
}