import 'package:delices_app/pagedirection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  int age = 0;
  @override
  Widget build(BuildContext context) {
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
              Color(0xFFE89265), // Darker peach at the bottom
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.04,
              ),
              Image.asset("./assets/logo.png"),
              Text("How old are you?",
                  style: GoogleFonts.tiltWarp(
                    fontSize: MediaQuery.sizeOf(context).width * 0.066,
                  )),
              Container(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  height: MediaQuery.sizeOf(context).height * 0.085,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (age > 0) {
                            setState(() {
                              age--;
                            });
                          }
                        },
                        child: Icon(
                          MdiIcons.minus,
                          size: MediaQuery.sizeOf(context).width * 0.08,
                        ),
                      ),
                      Text(
                        "$age",
                        style: GoogleFonts.tiltWarp(
                          fontSize: MediaQuery.sizeOf(context).width * 0.063,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            if (age < 100) {
                              setState(() {
                                age++;
                              });
                            }
                          },
                          child: Icon(
                            MdiIcons.plus,
                            size: MediaQuery.sizeOf(context).width * 0.08,
                          ))
                    ],
                  )),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.2,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PageDirection(),
                      ));
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
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              )
            ],
          ),
        ),
      ),
    );
  }
}
