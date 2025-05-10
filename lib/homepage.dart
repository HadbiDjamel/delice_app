import 'package:delices_app/choosefood.dart';
import 'package:delices_app/food.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Food f1 = Food(image: const AssetImage("./assets/img.png"), name: "Bourak");
  Food f2 = Food(
      image: const AssetImage("./assets/img-1.png"), name: "Poisson blanc");
  Food f3 =
      Food(image: const AssetImage("./assets/img-2.png"), name: "Tika massala");
  Food f4 = Food(image: const AssetImage("./assets/img.png"), name: "Bourak");
  Food f5 = Food(
      image: const AssetImage("./assets/img-1.png"), name: "Poisson blanc");
  Food f6 =
      Food(image: const AssetImage("./assets/img-2.png"), name: "Tika massala");

  List<Food> foodList = [];

  @override
  void initState() {
    super.initState();
    foodList = [f1, f2, f3, f4, f5, f6];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                Stack(alignment: Alignment.center, children: [
                  Image.asset("./assets/browncircle.png"),
                  Image.asset('./assets/menu.png')
                ]),
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
                    child: TextField(
                      cursorColor: Colors.black,
                      cursorWidth: 1.5,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          suffixIcon: Icon(MdiIcons.magnify,
                              size: MediaQuery.sizeOf(context).width * 0.1)),
                    ),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const ChooseFood(),
                      ));
                    },
                    child: Image.asset("./assets/dishes.png")),
              ],
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.2,
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 227, 174, 144),
                borderRadius: BorderRadius.circular(29)),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.014,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(alignment: Alignment.center, children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.275,
                    height: MediaQuery.sizeOf(context).height * 0.098,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 240, 222, 212),
                        borderRadius: BorderRadius.all(Radius.circular(29))),
                  ),
                  Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          child: Image.asset(
                            './assets/entree.png',
                            fit: BoxFit.fill,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "Entrée",
                          style: GoogleFonts.tiltWarp(
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.03),
                        ),
                      )
                    ],
                  )
                ]),
                Stack(alignment: Alignment.center, children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.275,
                    height: MediaQuery.sizeOf(context).height * 0.098,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 240, 222, 212),
                        borderRadius: BorderRadius.all(Radius.circular(29))),
                  ),
                  Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          child: Image.asset(
                            './assets/plat.png',
                            fit: BoxFit.fill,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "Plat",
                          style: GoogleFonts.tiltWarp(
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.03),
                        ),
                      )
                    ],
                  )
                ]),
                Stack(alignment: Alignment.center, children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.275,
                    height: MediaQuery.sizeOf(context).height * 0.098,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 240, 222, 212),
                        borderRadius: BorderRadius.all(Radius.circular(29))),
                  ),
                  Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          child: Image.asset(
                            './assets/dessert.png',
                            fit: BoxFit.fill,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          "Dessert",
                          style: GoogleFonts.tiltWarp(
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.03),
                        ),
                      )
                    ],
                  )
                ])
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
            width: MediaQuery.sizeOf(context).width * 0.85,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: MediaQuery.sizeOf(context).height * 0.02,
                crossAxisSpacing: MediaQuery.sizeOf(context).width * 0.08,
                childAspectRatio: 1.3,
                mainAxisExtent: MediaQuery.sizeOf(context).height * 0.185,
              ),
              shrinkWrap: true,
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                final name = foodList[index].name;
                final image = foodList[index].image;
                return Container(
                  width: MediaQuery.sizeOf(context).width * 0.36,
                  height: MediaQuery.sizeOf(context).height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.14,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: image, fit: BoxFit.fill)),
                      ),
                      Container(
                          height: MediaQuery.sizeOf(context).height * 0.04,
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16))),
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Text(
                              name,
                              style: GoogleFonts.tiltWarp(
                                  fontSize:
                                      MediaQuery.sizeOf(context).width * 0.032),
                            ),
                          ))
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
