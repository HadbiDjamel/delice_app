import 'dart:ui';

import 'package:delices_app/age.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const DelicesApp());
}

class DelicesApp extends StatelessWidget {
  const DelicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Delices',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    //width = 392.72727272727275
    // height = 803.6363636363636
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x00eba177), 
              Color(0xFFE89265), 
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.04,
              ),
              Image.asset("./assets/logo.png"),
              Text("Hi! What's your name?",
                  style: GoogleFonts.tiltWarp(
                    fontSize: MediaQuery.sizeOf(context).width * 0.066,
                  )),
              Container( 
                width: MediaQuery.sizeOf(context).width * 0.77,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Colors.white),
                child: const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: TextField(
                      cursorColor: Colors.black,
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                        border:
                            InputBorder.none,
                        enabledBorder: InputBorder
                            .none, 
                        focusedBorder: InputBorder.none,
                      )),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.2,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => const AgePage(),));
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 70, 32, 9),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text("Continue",
                          style: GoogleFonts.tiltWarp(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.045))),
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height*0.02,)
            ],
          ),
        ),
      ),
    );
  }
}
