import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delices_app/choosefood.dart';
import 'package:delices_app/foodinfo.dart';
import 'package:delices_app/weeklymenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalanderPage extends StatefulWidget {
  const CalanderPage({super.key});

  @override
  State<CalanderPage> createState() => _CalanderPageState();
}

class _CalanderPageState extends State<CalanderPage> {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _dates = [];
  bool _isLunchSelected = true;

  @override
  void initState() {
    super.initState();
    _generateDates();
  }

  void _generateDates() {
    final DateTime startDate = _selectedDate.subtract(const Duration(days: 2));
    _dates = [];
    for (int i = 0; i < 5; i++) {
      _dates.add(startDate.add(Duration(days: i)));
    }
  }

  Future<Map<String, dynamic>?> _getUserMealSelection() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
      final mealTime = _isLunchSelected ? 'lunch' : 'dinner';

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('meal_selections')
          .doc(dateString)
          .get();

      if (doc.exists) {
        return doc.data()?[mealTime] as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Widget _buildMealItemCard(
      BuildContext context, Map<String, dynamic> itemData, String type) {
    final bool isEmpty = itemData.isEmpty;
    final nom = isEmpty ? 'Not set yet' : (itemData['nom'] ?? 'Not set yet');
    final imageUrl = isEmpty ? '' : (itemData['imageUrl'] ?? '');
    final rating = isEmpty ? 6 : (itemData['rating'] ?? 6);
    final id = isEmpty ? '' : (itemData['id'] ?? 6);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => FoodInfo(
            fooduid: id,
          ),
        ));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        height: MediaQuery.of(context).size.height * 0.19,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color:
                      (isEmpty || imageUrl.isEmpty) ? Colors.grey[200] : null,
                  image: (!isEmpty && imageUrl.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (isEmpty || imageUrl.isEmpty)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              color: Colors.grey[400],
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Not set yet',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
            // Content container
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Food nom
                    Text(
                      nom,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isEmpty ? Colors.grey[600] : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Type and rating row

                    Text(
                      type,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.brown[600],
                      ),
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('./assets/star.png'),
                        const SizedBox(width: 2),
                        Text(
                          rating == 6 ? 'Not rated' : rating.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                      'Calander',
                      style: GoogleFonts.tiltWarp(
                          fontSize: MediaQuery.sizeOf(context).width * 0.05),
                    )),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(_selectedDate),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WeeklyMenuPage(),
                    ));
                  },
                  child: const Text('view weekly menu'),
                )
              ],
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.0),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.1,
            width: MediaQuery.sizeOf(context).width * 0.85,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final date = _dates[index];
                final isSelected = DateUtils.isSameDay(date, _selectedDate);
                final daynom = DateFormat('E').format(date).substring(0, 3);
                final dayNumber = date.day.toString();

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected
                        ? MediaQuery.sizeOf(context).width * 0.035
                        : MediaQuery.sizeOf(context).width * 0.015,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        _generateDates();
                      });
                    },
                    child: Transform.scale(
                      scale: isSelected ? 1.1 : 1.0,
                      child: Container(
                        height: isSelected
                            ? MediaQuery.sizeOf(context).height * 0.1
                            : MediaQuery.sizeOf(context).height * 0.1,
                        width: isSelected
                            ? MediaQuery.sizeOf(context).width * 0.16
                            : MediaQuery.sizeOf(context).width * 0.13,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFB39581)
                              : const Color(0xFFF5EFE7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              daynom,
                              style: TextStyle(
                                fontSize: isSelected
                                    ? MediaQuery.sizeOf(context).width * 0.05
                                    : MediaQuery.sizeOf(context).width * 0.03,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected ? Colors.white : Colors.brown,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.01,
                            ),
                            Text(
                              dayNumber,
                              style: TextStyle(
                                fontSize: isSelected
                                    ? MediaQuery.sizeOf(context).width * 0.05
                                    : MediaQuery.sizeOf(context).width * 0.04,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.brown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
          Container(
            height: MediaQuery.sizeOf(context).height * 0.144,
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 227, 174, 144),
              borderRadius: BorderRadius.circular(29),
            ),
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  height: MediaQuery.sizeOf(context).height * 0.144,
                  child:
                      Image.asset('./assets/lunchdinner.png', fit: BoxFit.fill),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLunchSelected = true;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.brown, width: 2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: _isLunchSelected
                                        ? Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.brown,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Lunch',
                                  style: GoogleFonts.tiltWarp(
                                    fontSize:
                                        MediaQuery.sizeOf(context).width * 0.06,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.brown[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLunchSelected = false;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Dinner',
                                  style: GoogleFonts.tiltWarp(
                                    fontSize:
                                        MediaQuery.sizeOf(context).width * 0.06,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: !_isLunchSelected
                                        ? Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
          FutureBuilder<Map<String, dynamic>?>(
            future: _getUserMealSelection(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              final mealData = snapshot.data;
              if (mealData == null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No meal selected for ${_isLunchSelected ? 'Lunch' : 'Dinner'}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.brown,
                    ),
                  ),
                );
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your ${_isLunchSelected ? 'Lunch' : 'Dinner'} Selection',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMealItemCard(
                            context, mealData['Entree'] ?? {}, 'Entree'),
                        _buildMealItemCard(
                            context, mealData['plat'] ?? {}, 'Plat'),
                        _buildMealItemCard(
                            context, mealData['dessert'] ?? {}, 'Dessert'),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const Spacer(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.26,
            width: MediaQuery.sizeOf(context).width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.3,
                  width: MediaQuery.sizeOf(context).width,
                  child: Image.asset(
                    './assets/table.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ChooseFood(),
                        ));
                      },
                      child: Column(
                        children: [
                          Text(
                            'Entree',
                            style: GoogleFonts.tiltWarp(),
                          ),
                          Image.asset('./assets/entree.png'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ChooseFood(),
                        ));
                      },
                      child: Column(
                        children: [
                          Text(
                            'Plat',
                            style: GoogleFonts.tiltWarp(),
                          ),
                          Image.asset(
                            './assets/plat.png',
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ChooseFood(),
                        ));
                      },
                      child: Column(
                        children: [
                          Text(
                            'Dessert',
                            style: GoogleFonts.tiltWarp(),
                          ),
                          Image.asset('./assets/dessert.png'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
