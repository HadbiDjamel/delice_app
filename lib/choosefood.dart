import 'package:delices_app/addfood.dart';
import 'package:delices_app/food.dart';
import 'package:delices_app/foodinfo.dart';
import 'package:delices_app/pagedirection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ChooseFood extends StatefulWidget {
  const ChooseFood({super.key});

  @override
  State<ChooseFood> createState() => _ChooseFoodState();
}

class _ChooseFoodState extends State<ChooseFood> {
  Food f1 =
      Food(image: const AssetImage("./assets/dessert1.png"), name: "Bourak");
  Food f2 = Food(
      image: const AssetImage("./assets/dessert2.png"), name: "Poisson blanc");
  Food f3 = Food(
      image: const AssetImage("./assets/dessert3.png"), name: "Tika massala");
  Food f4 =
      Food(image: const AssetImage("./assets/dessert1.png"), name: "Bourak");
  Food f5 = Food(
      image: const AssetImage("./assets/dessert2.png"), name: "Poisson blanc");
  Food f6 = Food(
      image: const AssetImage("./assets/dessert3.png"), name: "Tika massala");

  List<Food> foodList = [];
  bool isSettingsMenuOpen = false;
  bool remove = false;

  @override
  void initState() {
    super.initState();
    foodList = [f1, f2, f3, f4, f5, f6];
  }

  void toggleSettingsMenu() {
    setState(() {
      isSettingsMenuOpen = !isSettingsMenuOpen;
    });
  }

  void addFood() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const AddFood(),
    ));
    toggleSettingsMenu();
  }

  void removeFood() {
    remove = !remove;
    toggleSettingsMenu();
  }

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
                        child: TextField(
                          cursorColor: Colors.black,
                          cursorWidth: 1.5,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              suffixIcon: Icon(MdiIcons.magnify,
                                  size:
                                      MediaQuery.sizeOf(context).width * 0.1)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: toggleSettingsMenu,
                      child: Stack(alignment: Alignment.center, children: [
                        Image.asset("./assets/browncircle.png"),
                        Image.asset('./assets/settings.png')
                      ]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.78,
                width: MediaQuery.sizeOf(context).width * 0.92,
                child: ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    final image = foodList[index].image;
                    final name = foodList[index].name;
                    return Padding(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        child: remove
                                            ? Image.asset('./assets/remove.png')
                                            : Image.asset(
                                                './assets/downarrow.png'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      name,
                                      style: GoogleFonts.tiltWarp(
                                        fontSize:
                                            MediaQuery.sizeOf(context).width *
                                                0.05,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.05,
                                  ),
                                ],
                              ),
                              Container(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.15,
                                width: MediaQuery.sizeOf(context).width * 0.35,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: image, fit: BoxFit.fitWidth)),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (isSettingsMenuOpen)
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.02,
              right: MediaQuery.sizeOf(context).width * 0.01,
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.6,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 209, 188, 176),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: addFood,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.sizeOf(context).width * 0.04),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              "Add",
                              style: GoogleFonts.tiltWarp(
                                fontSize:
                                    MediaQuery.sizeOf(context).width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: removeFood,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.sizeOf(context).width * 0.04),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              "Remove",
                              style: GoogleFonts.tiltWarp(
                                fontSize:
                                    MediaQuery.sizeOf(context).width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
