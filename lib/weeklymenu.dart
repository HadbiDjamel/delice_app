// ignore_for_file: empty_catches, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class WeeklyMenuPage extends StatefulWidget {
  const WeeklyMenuPage({super.key});

  @override
  State<WeeklyMenuPage> createState() => _WeeklyMenuPageState();
}

class _WeeklyMenuPageState extends State<WeeklyMenuPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey _menuKey = GlobalKey();

  Map<String, Map<String, dynamic>> weeklyMeals = {};
  bool isLoading = true;
  String usernom = "User";

  @override
  void initState() {
    super.initState();
    _loadUsernom();
    _loadWeeklyMenu();
  }

  Future<void> _loadUsernom() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          usernom = userData['usernom'] ?? "User";
        });
      }
    } catch (e) {
      
    }
  }

  Future<void> _loadWeeklyMenu() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Get current week dates
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

      Map<String, Map<String, dynamic>> meals = {};

      // Load meals for each day of the week
      for (int i = 0; i < 7; i++) {
        DateTime date = startOfWeek.add(Duration(days: i));
        String dateString =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

        try {
          final DocumentSnapshot doc = await _firestore
              .collection('users')
              .doc(currentUser.uid)
              .collection('meal_selections')
              .doc(dateString)
              .get();

          if (doc.exists) {
            meals[dateString] = doc.data() as Map<String, dynamic>;
          } else {
            meals[dateString] = {};
          }
        } catch (e) {
          meals[dateString] = {};
        }
      }

      setState(() {
        weeklyMeals = meals;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDateForDisplay(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      return '${weekdays[date.weekday - 1]} ${date.day}/${date.month}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMealItemnom(dynamic mealItem) {
    if (mealItem == null) return '';
    if (mealItem is Map && mealItem['nom'] != null) {
      return mealItem['nom'].toString();
    }
    return mealItem.toString();
  }

  Future<void> _exportToPDF() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Generating PDF..."),
              ],
            ),
          );
        },
      );

      final pdf = pw.Document();

      // Get the current week date range
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            List<pw.Widget> content = [
              pw.Center(
                child: pw.Text(
                  '$usernom\'s Weekly Menu',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  '${startOfWeek.day}/${startOfWeek.month}/${startOfWeek.year} - ${endOfWeek.day}/${endOfWeek.month}/${endOfWeek.year}',
                  style: const pw.TextStyle(
                      fontSize: 14, color: PdfColors.grey700),
                ),
              ),
              pw.SizedBox(height: 30),
            ];

            // Sort the meals by date
            var sortedEntries = weeklyMeals.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key));

            for (var entry in sortedEntries) {
              final date = entry.key;
              final meals = entry.value;

              content.add(
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 25),
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(8)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        _formatDateForDisplay(date),
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue800,
                        ),
                      ),
                      pw.SizedBox(height: 12),

                      // Lunch section
                      if (meals.containsKey('lunch') &&
                          meals['lunch'] != null) ...[
                        pw.Text(
                          'Lunch:',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green700,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        if (_getMealItemnom(meals['lunch']['Entree'])
                            .isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 15, bottom: 3),
                            child: pw.Text(
                                '• Entree: ${_getMealItemnom(meals['lunch']['Entree'])}'),
                          ),
                        if (_getMealItemnom(meals['lunch']['plat']).isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 15, bottom: 3),
                            child: pw.Text(
                                '• Plat: ${_getMealItemnom(meals['lunch']['plat'])}'),
                          ),
                        if (_getMealItemnom(meals['lunch']['dessert'])
                            .isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 15, bottom: 3),
                            child: pw.Text(
                                '• Dessert: ${_getMealItemnom(meals['lunch']['dessert'])}'),
                          ),
                        pw.SizedBox(height: 10),
                      ],

                      // Dinner section
                      if (meals.containsKey('dinner') &&
                          meals['dinner'] != null) ...[
                        pw.Text(
                          'Dinner:',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.orange700,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        if (_getMealItemnom(meals['dinner']['Entree'])
                            .isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 15, bottom: 3),
                            child: pw.Text(
                                '• Entree: ${_getMealItemnom(meals['dinner']['Entree'])}'),
                          ),
                        if (_getMealItemnom(meals['dinner']['plat']).isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 15, bottom: 3),
                            child: pw.Text(
                                '• Plat: ${_getMealItemnom(meals['dinner']['plat'])}'),
                          ),
                        if (_getMealItemnom(meals['dinner']['dessert'])
                            .isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(left: 15, bottom: 3),
                            child: pw.Text(
                                '• Dessert: ${_getMealItemnom(meals['dinner']['dessert'])}'),
                          ),
                      ],

                      // No meals planned
                      if ((!meals.containsKey('lunch') ||
                              meals['lunch'] == null) &&
                          (!meals.containsKey('dinner') ||
                              meals['dinner'] == null))
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(left: 15),
                          child: pw.Text(
                            'No meals planned',
                            style: pw.TextStyle(
                              fontStyle: pw.FontStyle.italic,
                              color: PdfColors.grey600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }

            return content;
          },
        ),
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Show PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'weekly_menu_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      // Close loading dialog if it's still open
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportAsImage() async {
    try {
      RenderRepaintBoundary boundary =
          _menuKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/weekly_menu.png');
      await file.writeAsBytes(pngBytes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error exporting image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weekly Menu',
          style: GoogleFonts.tiltWarp(
            fontSize: MediaQuery.sizeOf(context).width * 0.05,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 167, 135, 115),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'pdf') {
                _exportToPDF();
              } else if (value == 'image') {
                _exportAsImage();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf),
                    SizedBox(width: 8),
                    Text('Export as PDF'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'image',
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(width: 8),
                    Text('Export as Image'),
                  ],
                ),
              ),
            ],
            child: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          Expanded(
            child: RepaintBoundary(
              key: _menuKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : weeklyMeals.isEmpty
                        ? Center(
                            child: Text(
                              'No meals planned for this week',
                              style: GoogleFonts.poppins(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: weeklyMeals.length,
                            itemBuilder: (context, index) {
                              final entry =
                                  weeklyMeals.entries.elementAt(index);
                              final date = entry.key;
                              final meals = entry.value;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 241, 215, 200),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDateForDisplay(date),
                                        style: GoogleFonts.tiltWarp(
                                          fontSize:
                                              MediaQuery.sizeOf(context).width *
                                                  0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      if (meals['lunch'] != null) ...[
                                        Text(
                                          'Lunch:',
                                          style: GoogleFonts.poppins(
                                            fontSize: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (_getMealItemnom(
                                                meals['lunch']['Entree'])
                                            .isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, bottom: 2.0),
                                            child: Text(
                                              '• Entree: ${_getMealItemnom(meals['lunch']['Entree'])}',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.035,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        if (_getMealItemnom(
                                                meals['lunch']['plat'])
                                            .isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, bottom: 2.0),
                                            child: Text(
                                              '• Plat: ${_getMealItemnom(meals['lunch']['plat'])}',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.035,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        if (_getMealItemnom(
                                                meals['lunch']['dessert'])
                                            .isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, bottom: 2.0),
                                            child: Text(
                                              '• Dessert: ${_getMealItemnom(meals['lunch']['dessert'])}',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.035,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                      ],
                                      if (meals['dinner'] != null) ...[
                                        Text(
                                          'Dinner:',
                                          style: GoogleFonts.poppins(
                                            fontSize: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.04,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        if (_getMealItemnom(
                                                meals['dinner']['Entree'])
                                            .isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, bottom: 2.0),
                                            child: Text(
                                              '• Entree: ${_getMealItemnom(meals['dinner']['Entree'])}',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.035,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        if (_getMealItemnom(
                                                meals['dinner']['plat'])
                                            .isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, bottom: 2.0),
                                            child: Text(
                                              '• Plat: ${_getMealItemnom(meals['dinner']['plat'])}',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.035,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        if (_getMealItemnom(
                                                meals['dinner']['dessert'])
                                            .isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, bottom: 2.0),
                                            child: Text(
                                              '• Dessert: ${_getMealItemnom(meals['dinner']['dessert'])}',
                                              style: GoogleFonts.poppins(
                                                fontSize:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.035,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                      ],
                                      if (meals['lunch'] == null &&
                                          meals['dinner'] == null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            'No meals planned',
                                            style: GoogleFonts.poppins(
                                              fontSize:
                                                  MediaQuery.sizeOf(context)
                                                          .width *
                                                      0.035,
                                              color: Colors.grey[500],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
