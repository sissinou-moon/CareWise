import 'package:carewise/Classes/Tools.dart';
import 'package:carewise/DB/firebase/Authentications.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  SignUpPage({super.key, required this.onTap});

  VoidCallback onTap;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
 
  //CONTROLLER
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();

  //VARS
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: SecondColor,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment(0, -1.45),
              child: SvgPicture.asset('assets/images/World health day.svg'),
            ),
            Align(
              alignment: Alignment(0, 1),
              child: Container(
                height: height*0.67,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black,width: 0.8),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(height*0.02),
                    topLeft: Radius.circular(height*0.02),
                  ),
                ),
                child: Padding(
                  padding: MainPadding(height, width),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.01, top: height*0.02),
                        child: MyTitle('Welcome to CareWise!', Colors.black, height*0.03),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.04),
                        child: MyDescription('Your personal health assistant in your pocket', Colors.black, height*0.014,1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.005),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText('Email', Colors.black, height*0.02),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.03),
                        child: TextField(
                          controller: _emailcontroller,
                          obscureText: false,
                          decoration: MainTextField(height, width, 'email', showPassword, () { setState(() { showPassword = !showPassword; });  }),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.005),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText('Password', Colors.black, height*0.02),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.12),
                        child: TextField(
                          controller: _passwordcontroller,
                          obscureText: showPassword,
                          decoration: MainTextField(height, width, 'password', showPassword, () { setState(() { showPassword = !showPassword; });  }),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: height*0.015),
                        child: GestureDetector(
                          onTap: () {
                            if(_emailcontroller.text.isEmpty) {
                              CherryToast.error(title: Text("Please, write your email address")).show(context);
                            }else if(_passwordcontroller.text.isEmpty) {
                              CherryToast.error(title: Text("Please,write a strong password")).show(context);
                            }else if(!_emailcontroller.text.contains("@")) {
                              CherryToast.error(title: Text("Error in your account email address")).show(context);
                            }else if(_passwordcontroller.text.length < 6) {
                              CherryToast.error(title: Text("The Password must contain more than 6 characters")).show(context);
                            }else {
                              SignUp(_emailcontroller.text.trim(), _passwordcontroller.text.trim()).whenComplete(() {
                                CherryToast.success(title: Text("Your account had created successfuly")).show(context);
                              }).onError((error, stackTrace) {
                                CherryToast.error(title: Text(error.toString())).show(context);
                              });
                            }
                          },
                          child: MyButton('SignUp', height*0.06, width*0.5, SecondColor, height*0.015),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyDescription("You have an account ? ", Colors.black, height*0.013,1),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: MyDescription(' Login!', SecondColor, height*0.013,1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}