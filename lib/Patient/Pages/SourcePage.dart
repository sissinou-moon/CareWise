import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/Patient/Pages/HomePage.dart';
import 'package:carewise/Patient/Pages/ProfilePage.dart';
import 'package:carewise/Patient/Pages/ServicesPage.dart';
import 'package:flutter/material.dart';

class Source extends StatefulWidget {
  const Source({super.key});

  @override
  State<Source> createState() => _SourceState();
}

class _SourceState extends State<Source> {

  //LISTS
  List<Widget> pages = [
    Home(),
    Services(),
    Profile(),
  ];

  //VARS 
  int index = 0;



  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          pages[index],
          Align(
            alignment: Alignment(0, 0.95),
            child: Container(
              height: height*0.07,
              width: width*0.6,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        index = 0;
                      });
                    },
                    child: Image.asset('assets/icons/home-button.png',height: height*0.032,),
                  ),
                  MyExpandedRow(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Image.asset('assets/icons/profile(2).png',height: height*0.032,),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.9),
            child: TextButton(
              onPressed: () {
                setState(() {
                  index = 1;
                });
              },
              child: Image.asset('assets/icons/plus.png',height: height*0.065,),
            ),
          ),
        ],
      ),
    );
  }
}