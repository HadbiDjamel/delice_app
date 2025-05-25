import 'package:delices_app/dateschedulepage.dart';
import 'package:delices_app/foodinfo.dart';
import 'package:delices_app/pagedirection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseFood extends StatefulWidget {
  const ChooseFood({super.key});

  @override
  State<ChooseFood> createState() => _ChooseFoodState();
}

class _ChooseFoodState extends State<ChooseFood> {
  int selectedIndex = 0;
  final List<String> tabs = ['Entree', 'Plat', 'Dessert'];

  // Selection storage
  Map<String, String> selectedMeals = {'Entree': '', 'Plat': '', 'Dessert': ''};
  Map<String, String> selectedMealIds = {
    'Entree': '',
    'Plat': '',
    'Dessert': ''
  };

  // Create a Stream that filters meals by category
  Stream<List<Map<String, dynamic>>> getMealsStream() {
    String currentCategory = tabs[selectedIndex].toLowerCase();
    if (currentCategory == 'Entree') currentCategory = 'Entree';

    final useruid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .collection('dishes')
        .where('type', isEqualTo: currentCategory)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Alternative: Get all meals and filter in the stream
  Stream<List<Map<String, dynamic>>> getAllMealsStream() {
    final useruid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .collection('dishes')
        .snapshots()
        .map((snapshot) {
      String currentCategory = tabs[selectedIndex].toLowerCase();
      if (currentCategory == 'Entree') currentCategory = 'Entree';

      return snapshot.docs.where((doc) {
        String category = doc.data()['type']?.toString().toLowerCase() ?? '';
        return category == currentCategory ||
            (currentCategory == 'Entree' && category == 'Entree');
      }).map((doc) {
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  void selectFood(String foodnom, String foodId) {
    setState(() {
      selectedMeals[tabs[selectedIndex]] = foodnom;
      selectedMealIds[tabs[selectedIndex]] = foodId;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${tabs[selectedIndex]}: $foodnom selected',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: const Color(0xFF8B4513),
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void unselectFood(String foodnom) {
    setState(() {
      selectedMeals[tabs[selectedIndex]] = '';
      selectedMealIds[tabs[selectedIndex]] = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${tabs[selectedIndex]}: $foodnom unselected',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: Colors.grey[600],
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void toggleFoodSelection(String foodnom, String foodId) {
    if (isFoodSelected(foodnom)) {
      unselectFood(foodnom);
    } else {
      selectFood(foodnom, foodId);
    }
  }

  bool isFoodSelected(String foodnom) {
    return selectedMeals[tabs[selectedIndex]] == foodnom;
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PageDirection(),
                    ));
                  },
                  child: Stack(alignment: Alignment.center, children: [
                    Image.asset("./assets/browncircle.png"),
                    Image.asset('./assets/backarrow.png')
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).height * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.7,
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
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Selection Summary
          if (selectedMeals.values.any((meal) => meal.isNotEmpty))
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFF8B4513).withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Menu:',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: const Color(0xFF8B4513),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...selectedMeals.entries
                      .where((entry) => entry.value.isNotEmpty)
                      .map(
                        (entry) => Text(
                          '${entry.key}: ${entry.value}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                ],
              ),
            ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(tabs.length, (index) {
                bool isSelected = selectedIndex == index;
                bool hasSelection = selectedMeals[tabs[index]]!.isNotEmpty;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tabs[index],
                              style: GoogleFonts.tiltWarp(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey[500],
                                fontSize:
                                    MediaQuery.sizeOf(context).width * 0.05,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                            if (hasSelection) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8B4513),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // StreamBuilder with GridView
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getMealsStream(), // Use the stream method
              builder: (context, snapshot) {
                // Handle different states
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading meals',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.red[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8B4513),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No ${tabs[selectedIndex].toLowerCase()} available',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Build GridView with data
                final meals = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.04,
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:
                          MediaQuery.sizeOf(context).height * 0.00111,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final mealData = meals[index];
                      final nom = mealData['nom'] ?? 'Unknown';
                      final imageUrl = mealData['imageUrl'] ?? '';
                      final rating =
                          mealData['rating']?.toDouble() ?? 'Not Rated';
                      final mealId = mealData['id'] ?? '';
                      final isSelected = isFoodSelected(nom);

                      return GestureDetector(
                        onTap: () {
                          
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FoodInfo(
                              fooduid: mealId,
                            ),
                          ));
                        },
                        onLongPress: () {
                          toggleFoodSelection(nom, mealId);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFF8B4513), width: 3)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? const Color(0xFF8B4513)
                                        .withValues(alpha: 0.3)
                                    : const Color.fromRGBO(0, 0, 0, 0.25),
                                offset: const Offset(4, 4),
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: imageUrl.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(imageUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : const DecorationImage(
                                                image: AssetImage(
                                                    "./assets/food.png"),
                                                fit: BoxFit.cover,
                                              ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(22),
                                          topRight: Radius.circular(22),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF8B4513)
                                                .withValues(alpha: 0.1)
                                            : Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(22),
                                          bottomRight: Radius.circular(22),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              nom,
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? const Color(0xFF8B4513)
                                                    : Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 2),
                                                Text(
                                                  rating == 6
                                                      ? 'Not Rated'
                                                      : rating.toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.03,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected
                                                        ? const Color(
                                                            0xFF8B4513)
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF8B4513),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Continue Button
          Padding(
            padding: EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.03),
            child: GestureDetector(
              onTap: () {
                if (selectedMeals.values.any((meal) => meal.isNotEmpty)) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DateSchedulePage(
                      selectedMeals: selectedMeals,
                      selectedMealIds: selectedMealIds,
                    ),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select at least one meal',
                        style: GoogleFonts.inter(),
                      ),
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.6,
                height: MediaQuery.sizeOf(context).height * 0.065,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 70, 32, 9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Continue",
                    style: GoogleFonts.tiltWarp(
                      color: Colors.white,
                      fontSize: MediaQuery.sizeOf(context).width * 0.045,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
