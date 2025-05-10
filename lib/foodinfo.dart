import 'package:delices_app/choosefood.dart';
import 'package:delices_app/pagedirection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodInfo extends StatefulWidget {
  const FoodInfo({super.key});

  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.sizeOf(context).height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.0055,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const PageDirection(),
                        ));
                      },
                      child: Stack(alignment: Alignment.center, children: [
                        Image.asset("./assets/browncircle.png"),
                        Image.asset('./assets/backarrow.png')
                      ]),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.663,
                      height: MediaQuery.sizeOf(context).height * 0.07,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 167, 135, 115),
                          borderRadius: BorderRadius.circular(35)),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.sizeOf(context).width * 0.05,
                            top: MediaQuery.sizeOf(context).height * 0.006),
                        child: Center(
                            child: Text(
                          'Plat',
                          style: GoogleFonts.tiltWarp(
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.05),
                        )),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const ChooseFood(),
                          ));
                        },
                        child: Image.asset("./assets/dishes.png")),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.65,
                    width: MediaQuery.sizeOf(context).width * 0.92,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const FoodInfo(),
                          ));
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width * 0.92,
                          height: MediaQuery.sizeOf(context).height * 0.18,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color.fromARGB(255, 241, 215, 199),
                                  Color.fromARGB(255, 250, 245, 242),
                                ],
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.06,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: RotatedBox(
                                          quarterTurns: 2,
                                          child: Image.asset(
                                              './assets/downarrow.png'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.55,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.67,
                                    child: ListView(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Description",
                                            style: GoogleFonts.tiltWarp(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.04),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                    fit: FlexFit.loose,
                                                    flex: 1,
                                                    child: Text(
                                                      "descriptionh fdgggg gggggggfgsfqgfd fsdhbfsd jfbsdfbjsdbf jsbdfhsd bfjsbdfs jdfshdbfj s h bfjbdfhsbjh bfd sjfb jsbdjfbsjdb fjsdbfj bdsfbjsdbfds bjfbsdjbf jsdbfjsdh bfjhsbfsdbf sjdbf shd bfjhsbfj sbdfb sjgs dgg",
                                                      style: GoogleFonts.poppins(
                                                          fontSize:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.04,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Ingredients",
                                            style: GoogleFonts.tiltWarp(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.04),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.8,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                    fit: FlexFit.loose,
                                                    flex: 1,
                                                    child: Text(
                                                      "- descriptionhfdgggggg\n- gggggfgsfqgfdfsdhbfsdjfbsdfbjsdbfjsbdfhsdbfjsbdfsjdfshdbfjshbfjb\n- dfhsbjhbfdsjfbjsbdjfbsjdbfjsdbfjbdsfbjsdbfdsbjfbsdjbfjsdbfjsdhbfjhsbfsdbfsjdbfshdbfjhsbfjsbdfbsjgsdgg",
                                                      style: GoogleFonts.poppins(
                                                          fontSize:
                                                              MediaQuery.sizeOf(
                                                                          context)
                                                                      .width *
                                                                  0.04,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).height * 0.15,
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('./assets/plat2.png'),
                            fit: BoxFit.fitWidth)),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.06,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ChooseFood(),
                  ));
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  height: MediaQuery.sizeOf(context).height * 0.065,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 70, 32, 9),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text("Done",
                          style: GoogleFonts.tiltWarp(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.045))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
