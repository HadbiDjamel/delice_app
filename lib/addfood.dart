import 'package:delices_app/choosefood.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  late TextEditingController nom = TextEditingController();
  late TextEditingController description = TextEditingController();
  late TextEditingController ingredients = TextEditingController();

  @override
  void initState() {
    nom = TextEditingController();
    description = TextEditingController();
    ingredients = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Column(
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
                        Navigator.of(context).pop();
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
                      onTap: () {},
                      child: Stack(alignment: Alignment.center, children: [
                        Image.asset("./assets/browncircle.png"),
                        Image.asset('./assets/settings.png')
                      ]),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.07,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.916,
                height: MediaQuery.sizeOf(context).height * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: const Color.fromARGB(255, 241, 215, 199)),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.03,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.21,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Plat nom',
                                style: GoogleFonts.tiltWarp(
                                    fontSize: MediaQuery.sizeOf(context).width *
                                        0.05),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.42,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: TextField(
                                        controller: nom,
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.black,
                                        cursorWidth: 1.5,
                                        decoration: const InputDecoration(
                                          border: InputBorder
                                              .none, // Removes the default underline
                                          enabledBorder: InputBorder
                                              .none, // Ensures it's removed when enabled
                                          focusedBorder: InputBorder.none,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.2,
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22)),
                            child: Image.asset('./assets/photos.png'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Description",
                                    style: GoogleFonts.tiltWarp(
                                        fontSize:
                                            MediaQuery.sizeOf(context).width *
                                                0.05),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.85,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.13,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: TextField(
                                      controller: description,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      cursorColor: Colors.black,
                                      cursorWidth: 1.5,
                                      decoration: const InputDecoration(
                                        border: InputBorder
                                            .none, // Removes the default underline
                                        enabledBorder: InputBorder
                                            .none, // Ensures it's removed when enabled
                                        focusedBorder: InputBorder.none,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.22,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Ingredients",
                                    style: GoogleFonts.tiltWarp(
                                        fontSize:
                                            MediaQuery.sizeOf(context).width *
                                                0.05),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.85,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.159,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: TextField(
                                      controller: ingredients,
                                      keyboardType: TextInputType.multiline,
                                      cursorColor: Colors.black,
                                      cursorWidth: 1.5,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        border: InputBorder
                                            .none, // Removes the default underline
                                        enabledBorder: InputBorder
                                            .none, // Ensures it's removed when enabled
                                        focusedBorder: InputBorder.none,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
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
                      child: Text("Continue",
                          style: GoogleFonts.tiltWarp(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.045))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
