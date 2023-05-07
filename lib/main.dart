import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:clone_instagram/utils/colors.dart';

import 'package:clone_instagram/responsive/responsive_layout_screen.dart';
import 'package:clone_instagram/responsive/mobile_screen_layout.dart';
import 'package:clone_instagram/responsive/web_screen_layout.dart';

import 'package:clone_instagram/screens/login_screen.dart';
import 'package:clone_instagram/screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      name: 'Instagram Clone',
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBYXov4vZjMaRkU8byuF3JYamy4VIgGAwU',
        appId: '1:518501392338:web:13061fb93596b08214720b',
        messagingSenderId: '518501392338',
        projectId: 'clone-instagram-baae3',
        storageBucket: 'clone-instagram-baae3.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // connectionState: ConnectionState.active
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ResponsiveLayout(
                webScreenLayout: WebScreenLayout(),
                mobileScreenLayout: MobileScreenLayout(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          // connectionState: ConnectionState.waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          // connectionState: ConnectionState.none
          return const LoginScreen();
        },
      ),
    );
  }
}
