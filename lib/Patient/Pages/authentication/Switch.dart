import 'package:carewise/Patient/Pages/authentication/SignInP.dart';
import 'package:carewise/Patient/Pages/authentication/SignUpP.dart';
import 'package:flutter/material.dart';

class SwitchPage extends StatefulWidget {
  const SwitchPage({super.key});

  @override
  State<SwitchPage> createState() => _SwitchPageState();
}

class _SwitchPageState extends State<SwitchPage> {

  bool showLogin = false;

  void onTap() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLogin) {
      return SignInPage(onTap: onTap,);
    }else {
      return SignUpPage(onTap: onTap,);
    }
  }
}