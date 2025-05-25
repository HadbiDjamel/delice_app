// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delices_app/pagedirection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  late ScrollController _scrollController;
  int selectedAge = 22;
  final double itemHeight = 60.0;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(
      initialScrollOffset: selectedAge * itemHeight,
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_isScrolling) {
      double offset = _scrollController.offset;
      int newAge = (offset / itemHeight).round().clamp(0, 100);
      if (newAge != selectedAge) {
        setState(() {
          selectedAge = newAge;
        });
      }
    }
  }

  void _snapToNearestAge() {
    if (!_scrollController.hasClients) return;

    double offset = _scrollController.offset;
    int nearestAge = (offset / itemHeight).round().clamp(0, 100);
    double targetOffset = nearestAge * itemHeight;

    _isScrolling = true;
    _scrollController
        .animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    )
        .then((_) {
      _isScrolling = false;
      setState(() {
        selectedAge = nearestAge;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('./assets/logo.png'),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.05,
                ),
                Text(
                  'How Old Are You?',
                  style: GoogleFonts.lexendDeca(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                // Age Roller
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.37,
                  child: Stack(
                    children: [
                      // Center line indicator
                      Positioned(
                        left: 0,
                        right: 0,
                        top: MediaQuery.sizeOf(context).height * 0.15,
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.07,
                          width: MediaQuery.sizeOf(context).width * 0.2,
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: Colors.white.withValues(alpha: 0.3),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Scrollable age list
                      NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification) {
                          if (notification is ScrollEndNotification) {
                            _snapToNearestAge();
                          }
                          return true;
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: 101, // 0 to 100
                          itemExtent: itemHeight,
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.sizeOf(context).height * 0.15),
                          itemBuilder: (context, index) {
                            return _buildAgeItem(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.062,
                  child: ElevatedButton(
                    onPressed: () async {
                      String currentid = FirebaseAuth.instance.currentUser!.uid;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentid)
                          .update({'age': selectedAge});

                      Navigator.of(context).push(DialogRoute(
                        context: context,
                        builder: (context) => const PageDirection(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgeItem(int age) {
    double distance = (age - selectedAge).abs().toDouble();

    double opacity = (1.0 - (distance * 0.15)).clamp(0.2, 1.0);

    double scale = (1.0 - (distance * 0.1)).clamp(0.6, 1.0);

    double fontSize = (28.0 - (distance * 2.0)).clamp(16.0, 32.0);

    bool isSelected = age == selectedAge;

    return Transform.scale(
      scale: scale,
      child: Container(
        height: itemHeight,
        alignment: Alignment.center,
        child: Text(
          age.toString(),
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white.withValues(alpha: opacity),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
