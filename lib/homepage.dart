import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delices_app/foodinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> dishes = [];
  List<Map<String, dynamic>> filteredDishes = [];
  String selectedtype = 'all';
  bool isLoading = true;
  bool showRandomDishes = false;
  List<Map<String, dynamic>> randomDishes = [];

  @override
  void initState() {
    super.initState();
    _loadDishes();
  }

  Future<void> _loadDishes() async {
    try {
      setState(() {
        isLoading = true;
      });
      final useruid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(useruid)
          .collection('dishes')
          .orderBy('rating', descending: true)
          .get();

      List<Map<String, dynamic>> loadedDishes = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        loadedDishes.add(data);
      }

      setState(() {
        dishes = loadedDishes;
        filteredDishes = loadedDishes;
        isLoading = false;
        showRandomDishes = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterBytype(String type) {
    setState(() {
      selectedtype = type;
      showRandomDishes = false;
      if (type == 'all') {
        filteredDishes = List.from(dishes);
      } else {
        filteredDishes = dishes
            .where((dish) => dish['type']?.toLowerCase() == type.toLowerCase())
            .toList();
      }
    });
  }

  void _showRandomDishes() {
    List<Map<String, dynamic>> entrees = dishes
        .where((dish) => dish['type']?.toLowerCase() == 'entree')
        .toList();
    List<Map<String, dynamic>> plats =
        dishes.where((dish) => dish['type']?.toLowerCase() == 'plat').toList();
    List<Map<String, dynamic>> desserts = dishes
        .where((dish) => dish['type']?.toLowerCase() == 'dessert')
        .toList();

    List<Map<String, dynamic>> selectedRandom = [];
    Random random = Random();

    // Add random Entree
    if (entrees.isNotEmpty) {
      selectedRandom.add(entrees[random.nextInt(entrees.length)]);
    }

    // Add random plat
    if (plats.isNotEmpty) {
      selectedRandom.add(plats[random.nextInt(plats.length)]);
    }

    // Add random dessert
    if (desserts.isNotEmpty) {
      selectedRandom.add(desserts[random.nextInt(desserts.length)]);
    }

    setState(() {
      randomDishes = selectedRandom;
      showRandomDishes = true;
    });
  }

  Widget _buildtypeButton(String type, String displaynom) {
    bool isSelected = selectedtype == type;
    return GestureDetector(
      onTap: () => _filterBytype(type),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: MediaQuery.sizeOf(context).width * 0.275,
          height: MediaQuery.sizeOf(context).height * 0.098,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(255, 167, 135, 115)
                : const Color.fromARGB(255, 240, 222, 212),
            borderRadius: const BorderRadius.all(Radius.circular(29)),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.08,
              child: Image.asset(
                type == 'Entree'
                    ? './assets/entree.png'
                    : type == 'plat'
                        ? './assets/plat.png'
                        : './assets/dessert.png',
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                displaynom,
                style: GoogleFonts.tiltWarp(
                  fontSize: MediaQuery.sizeOf(context).width * 0.03,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            )
          ],
        )
      ]),
    );
  }

  Widget _buildDishCard(Map<String, dynamic> dish) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.36,
      height: MediaQuery.sizeOf(context).height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.4),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => FoodInfo(fooduid: dish['']),)),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.15,
              width: MediaQuery.sizeOf(context).width * 0.4,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: dish['imageUrl'] != null
                      ? NetworkImage(dish['imageUrl'])
                      : const AssetImage("./assets/img.png") as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.09,
            width: MediaQuery.sizeOf(context).width * 0.4,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish['nom'] ?? 'Unknown',
                    style: GoogleFonts.tiltWarp(
                      fontSize: MediaQuery.sizeOf(context).width * 0.032,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dish['type'],
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown[600],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset('./assets/star.png'),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.02,
                      ),
                      Text(
                        dish['rating'] == 6 ? 'Not Rated':'${dish['rating']?.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: MediaQuery.sizeOf(context).width * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
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
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.9,
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
                      'Home',
                      style: GoogleFonts.tiltWarp(
                          fontSize: MediaQuery.sizeOf(context).width * 0.05),
                    )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildtypeButton('Entree', 'Entree'),
                _buildtypeButton('plat', 'Plat'),
                _buildtypeButton('dessert', 'Dessert'),
              ],
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.27,
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(29)),
            child: Stack(
              children: [
                Image.asset(
                  './assets/random_circle.png',
                  fit: BoxFit.cover,
                ),
                if (showRandomDishes && randomDishes.isNotEmpty)
                  Positioned(
                    top: MediaQuery.sizeOf(context).height * 0.03,
                    right: MediaQuery.sizeOf(context).width * 0.07,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: randomDishes.map((dish) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  FoodInfo(fooduid: dish['id']),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: MediaQuery.sizeOf(context).height * 0.15,
                              width: MediaQuery.sizeOf(context).width * 0.24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(13),
                                image: DecorationImage(
                                  image: dish['imageUrl'] != null
                                      ? NetworkImage(dish['imageUrl'])
                                      : const AssetImage("./assets/img.png")
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        dish['nom'] ?? '',
                                        style: GoogleFonts.tiltWarp(
                                          color: Colors.white,
                                          fontSize:
                                              MediaQuery.sizeOf(context).width *
                                                  0.025,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                else
                  Positioned(
                    top: MediaQuery.sizeOf(context).height * 0.03,
                    right: MediaQuery.sizeOf(context).width * 0.035,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.15,
                            width: MediaQuery.sizeOf(context).width * 0.24,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(13)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.15,
                            width: MediaQuery.sizeOf(context).width * 0.24,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(13)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.15,
                            width: MediaQuery.sizeOf(context).width * 0.24,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(217, 217, 217, 1),
                                borderRadius: BorderRadius.circular(13)),
                          ),
                        )
                      ],
                    ),
                  ),
                Positioned(
                  bottom: MediaQuery.sizeOf(context).height * 0.006,
                  left: MediaQuery.sizeOf(context).width * 0.377,
                  child: GestureDetector(
                    onTap: _showRandomDishes,
                    child: Image.asset('./assets/random.png'),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.014,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.85,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing:
                            MediaQuery.sizeOf(context).height * 0.03,
                        crossAxisSpacing:
                            MediaQuery.sizeOf(context).width * 0.05,
                        childAspectRatio: 1.3,
                        mainAxisExtent:
                            MediaQuery.sizeOf(context).height * 0.25,
                      ),
                      shrinkWrap: true,
                      itemCount: filteredDishes.length,
                      itemBuilder: (context, index) {
                        return _buildDishCard(filteredDishes[index]);
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
