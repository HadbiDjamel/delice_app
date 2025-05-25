import 'package:delices_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> mealHistory = [];
  bool isLoading = true;
  String usernom = "nom";
  String userAge = "Age";
  bool isLoadingUserData = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadMealHistory();
  }

  Future<void> _loadUserData() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          usernom = userData['usernom'] ?? "nom";
          userAge = userData['age']?.toString() ?? "Age";
          isLoadingUserData = false;
        });
      } else {
        setState(() {
          isLoadingUserData = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingUserData = false;
      });
    }
  }

  Future<void> _loadMealHistory() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('meal_selections')
          .orderBy(FieldPath.documentId, descending: true)
          .limit(10) // Limit to last 10 days
          .get();

      List<Map<String, dynamic>> history = [];

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final date = doc.id;

        // Extract lunch and dinner data
        final lunch = data['lunch'] as Map<String, dynamic>?;
        final dinner = data['dinner'] as Map<String, dynamic>?;

        if (lunch != null) {
          history.add({
            'date': date,
            'mealType': 'Lunch',
            'Entree': lunch['Entree'] ?? '',
            'plat': lunch['plat'] ?? '',
            'dessert': lunch['dessert'] ?? '',
          });
        }

        if (dinner != null) {
          history.add({
            'date': date,
            'mealType': 'Dinner',
            'Entree': dinner['Entree'] ?? '',
            'plat': dinner['plat'] ?? '',
            'dessert': dinner['dessert'] ?? '',
          });
        }
      }

      setState(() {
        mealHistory = history;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Widget> _getMealItemsWidgets(Map<String, dynamic> meal) {
    List<Widget> items = [];

    if (meal['Entree'] != null && meal['Entree'].toString().isNotEmpty) {
      String entreenom = meal['Entree'] is Map
          ? (meal['Entree']['nom'] ?? meal['Entree'].toString())
          : meal['Entree'].toString();
      items.add(
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 1.0),
          child: Text(
            '• Entree: $entreenom',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.sizeOf(context).width * 0.03,
              color: Colors.grey[700],
            ),
          ),
        ),
      );
    }

    if (meal['plat'] != null && meal['plat'].toString().isNotEmpty) {
      String platnom = meal['plat'] is Map
          ? (meal['plat']['nom'] ?? meal['plat'].toString())
          : meal['plat'].toString();
      items.add(
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 1.0),
          child: Text(
            '• Plat: $platnom',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.sizeOf(context).width * 0.03,
              color: Colors.grey[700],
            ),
          ),
        ),
      );
    }

    if (meal['dessert'] != null && meal['dessert'].toString().isNotEmpty) {
      String dessertnom = meal['dessert'] is Map
          ? (meal['dessert']['nom'] ?? meal['dessert'].toString())
          : meal['dessert'].toString();
      items.add(
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 1.0),
          child: Text(
            '• Dessert: $dessertnom',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.sizeOf(context).width * 0.03,
              color: Colors.grey[700],
            ),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      items.add(
        Padding(
          padding: const EdgeInsets.only(left: 25.0, bottom: 1.0),
          child: Text(
            '• No items selected',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.sizeOf(context).width * 0.03,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return items;
  }

  List<Map<String, dynamic>> _getGroupedMealsByDate() {
    Map<String, List<Map<String, dynamic>>> groupedMeals = {};

    for (var meal in mealHistory) {
      String date = meal['date'];
      if (!groupedMeals.containsKey(date)) {
        groupedMeals[date] = [];
      }
      groupedMeals[date]!.add(meal);
    }

    // Convert to list and sort by date (most recent first)
    List<Map<String, dynamic>> result = [];
    groupedMeals.forEach((date, meals) {
      result.add({
        'date': date,
        'meals': meals,
      });
    });

    result.sort((a, b) => b['date'].compareTo(a['date']));

    return result;
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final targetDate = DateTime(date.year, date.month, date.day);

      if (targetDate == today) {
        return 'Today';
      } else if (targetDate == yesterday) {
        return 'Yesterday';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
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
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.663,
                  height: MediaQuery.sizeOf(context).height * 0.07,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 167, 135, 115),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Center(
                    child: Text(
                      'Profile',
                      style: GoogleFonts.tiltWarp(
                        fontSize: MediaQuery.sizeOf(context).width * 0.05,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AuthWrapper(),
                    ));
                  },
                  child: Icon(MdiIcons.logout)
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.8,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width * 0.08),
                    Text(
                      'Informations :',
                      style: GoogleFonts.tiltWarp(
                        fontSize: MediaQuery.sizeOf(context).width * 0.05,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.2,
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 215, 200),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.3,
                          height: MediaQuery.sizeOf(context).height * 0.15,
                          child: Image.asset(
                            './assets/profilephoto.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.sizeOf(context).width * 0.07,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: isLoadingUserData
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          usernom,
                                          style: GoogleFonts.tiltWarp(),
                                        ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.02,
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.4,
                                height:
                                    MediaQuery.sizeOf(context).height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: isLoadingUserData
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          userAge,
                                          style: GoogleFonts.tiltWarp(),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.sizeOf(context).width * 0.08),
                    Text(
                      'History :',
                      style: GoogleFonts.tiltWarp(
                        fontSize: MediaQuery.sizeOf(context).width * 0.05,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 241, 215, 200),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.02),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.36,
                        width: MediaQuery.sizeOf(context).width * 0.85,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : mealHistory.isEmpty
                                ? Center(
                                    child: Text(
                                      'No meal history found',
                                      style: GoogleFonts.poppins(),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: ListView.builder(
                                      itemCount:
                                          _getGroupedMealsByDate().length,
                                      itemBuilder: (context, index) {
                                        final dateEntry =
                                            _getGroupedMealsByDate()[index];
                                        final date = dateEntry['date'];
                                        final meals = dateEntry['meals']
                                            as List<Map<String, dynamic>>;

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _formatDate(date),
                                                style: GoogleFonts.tiltWarp(
                                                  fontSize:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              ...meals
                                                  .map((meal) => Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 15.0,
                                                                    bottom:
                                                                        3.0),
                                                            child: Text(
                                                              '${meal['mealType']}:',
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                fontSize: MediaQuery.sizeOf(
                                                                            context)
                                                                        .width *
                                                                    0.032,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                          ..._getMealItemsWidgets(
                                                              meal),
                                                          const SizedBox(
                                                              height: 5),
                                                        ],
                                                      ))
                                                  ,
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
