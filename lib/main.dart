import 'package:carewise/Doctor/Pages/LoadingD.dart';
import 'package:carewise/Doctor/Pages/SinPages/SignInPageD.dart';
import 'package:carewise/Doctor/Pages/SourceD.dart';
import 'package:carewise/Doctor/Providers/LanguageProvide.dart';
import 'package:carewise/Patient/Pages/SourcePage.dart';
import 'package:carewise/Patient/Pages/authentication/Switch.dart';
import 'package:carewise/Patient/providers/SearchProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (a) => LanguageProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: width < 500 ? AuthPage() : SignInDPage(),
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Source();
        }else {
          return SwitchPage();
        }
      },
    );
  }
}

