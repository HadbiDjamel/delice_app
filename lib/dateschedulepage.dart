// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delices_app/choosefood.dart';
import 'package:delices_app/pagedirection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateSchedulePage extends StatefulWidget {
  final Map<String, String> selectedMeals;
  final Map<String, String> selectedMealIds;

  const DateSchedulePage(
      {super.key, required this.selectedMeals, required this.selectedMealIds});

  @override
  State<DateSchedulePage> createState() => _DateSchedulePageState();
}

class _DateSchedulePageState extends State<DateSchedulePage> {
  List<Map<String, dynamic>> scheduledDates = [];
  bool showDatePicker = false;
  bool _isLunchSelected = true;

  // Date picker controllers
  late ScrollController _dayController;
  late ScrollController _monthController;
  late ScrollController _yearController;

  int selectedDay = DateTime.now().day;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final double itemHeight = 50.0;
  bool _isDayScrolling = false;
  bool _isMonthScrolling = false;
  bool _isYearScrolling = false;

  @override
  void initState() {
    super.initState();
    // Add today's date by default
    scheduledDates.add({
      'date': DateTime.now(),
      'isLunch': true,
    });

    _initializeControllers();
  }

  void _initializeControllers() {
    _dayController = ScrollController(
      initialScrollOffset: (selectedDay - 1) * itemHeight,
    );
    _monthController = ScrollController(
      initialScrollOffset: (selectedMonth - 1) * itemHeight,
    );
    _yearController = ScrollController(
      initialScrollOffset: (selectedYear - DateTime.now().year) * itemHeight,
    );

    _dayController.addListener(_onDayScroll);
    _monthController.addListener(_onMonthScroll);
    _yearController.addListener(_onYearScroll);
  }

  // Reset date picker to today's date
  void _resetToToday() {
    DateTime today = DateTime.now();
    setState(() {
      selectedDay = today.day;
      selectedMonth = today.month;
      selectedYear = today.year;
    });

    // Dispose old controllers
    _dayController.removeListener(_onDayScroll);
    _monthController.removeListener(_onMonthScroll);
    _yearController.removeListener(_onYearScroll);
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();

    // Reinitialize controllers with today's date
    _initializeControllers();
  }

  void _onDayScroll() {
    if (!_isDayScrolling) {
      double offset = _dayController.offset;
      int maxDays = _getDaysInMonth(selectedMonth, selectedYear);
      int newDay = ((offset / itemHeight).round() + 1).clamp(1, maxDays);

      // Check if the selected date would be before today
      DateTime selectedDate = DateTime(selectedYear, selectedMonth, newDay);
      DateTime today = DateTime.now();
      DateTime todayDate = DateTime(today.year, today.month, today.day);

      if (selectedDate.isBefore(todayDate)) {
        // Snap back to today if trying to select a past date
        _snapToValidDay();
        return;
      }

      if (newDay != selectedDay) {
        setState(() {
          selectedDay = newDay;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _fetchDishData(String dishId) async {
    try {
      final useruid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(useruid)
          .collection('dishes')
          .doc(dishId)
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _onMonthScroll() {
    if (!_isMonthScrolling) {
      double offset = _monthController.offset;
      int newMonth = ((offset / itemHeight).round() + 1).clamp(1, 12);
      if (newMonth != selectedMonth) {
        setState(() {
          selectedMonth = newMonth;
          // Adjust day if it's invalid for the new month
          int maxDays = _getDaysInMonth(selectedMonth, selectedYear);
          if (selectedDay > maxDays) {
            selectedDay = maxDays;
          }
          // Check if the new date would be before today
          _validateSelectedDate();
          _snapDayController();
        });
      }
    }
  }

  void _onYearScroll() {
    if (!_isYearScrolling) {
      double offset = _yearController.offset;
      int newYear = ((offset / itemHeight).round() + DateTime.now().year)
          .clamp(DateTime.now().year, DateTime.now().year + 50);
      if (newYear != selectedYear) {
        setState(() {
          selectedYear = newYear;
          // Adjust day if it's invalid for the new year (leap year case)
          int maxDays = _getDaysInMonth(selectedMonth, selectedYear);
          if (selectedDay > maxDays) {
            selectedDay = maxDays;
          }
          // Check if the new date would be before today
          _validateSelectedDate();
          _snapDayController();
        });
      }
    }
  }

  void _validateSelectedDate() {
    DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);

    if (selectedDate.isBefore(todayDate)) {
      // Reset to today if the selected date is in the past
      selectedDay = today.day;
      selectedMonth = today.month;
      selectedYear = today.year;
    }
  }

  int _getDaysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  void _snapDayController() {
    if (_dayController.hasClients) {
      double targetOffset = (selectedDay - 1) * itemHeight;
      _isDayScrolling = true;
      _dayController
          .animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      )
          .then((_) {
        _isDayScrolling = false;
      });
    }
  }

  void _snapToValidDay() {
    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);
    DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);

    if (selectedDate.isBefore(todayDate)) {
      setState(() {
        selectedDay = today.day;
        selectedMonth = today.month;
        selectedYear = today.year;
      });
    }

    if (_dayController.hasClients) {
      double targetOffset = (selectedDay - 1) * itemHeight;
      _isDayScrolling = true;
      _dayController
          .animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      )
          .then((_) {
        _isDayScrolling = false;
      });
    }
  }

  void _snapToNearestDay() {
    if (!_dayController.hasClients) return;
    double offset = _dayController.offset;
    int maxDays = _getDaysInMonth(selectedMonth, selectedYear);
    int nearestDay = ((offset / itemHeight).round() + 1).clamp(1, maxDays);

    // Check if the selected date would be before today
    DateTime selectedDate = DateTime(selectedYear, selectedMonth, nearestDay);
    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);

    if (selectedDate.isBefore(todayDate)) {
      nearestDay = today.day;
      setState(() {
        selectedMonth = today.month;
        selectedYear = today.year;
      });
    }

    double targetOffset = (nearestDay - 1) * itemHeight;

    _isDayScrolling = true;
    _dayController
        .animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    )
        .then((_) {
      _isDayScrolling = false;
      setState(() {
        selectedDay = nearestDay;
      });
    });
  }

  void _snapToNearestMonth() {
    if (!_monthController.hasClients) return;
    double offset = _monthController.offset;
    int nearestMonth = ((offset / itemHeight).round() + 1).clamp(1, 12);
    double targetOffset = (nearestMonth - 1) * itemHeight;

    _isMonthScrolling = true;
    _monthController
        .animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    )
        .then((_) {
      _isMonthScrolling = false;
      setState(() {
        selectedMonth = nearestMonth;
      });
    });
  }

  void _snapToNearestYear() {
    if (!_yearController.hasClients) return;
    double offset = _yearController.offset;
    int nearestYear = ((offset / itemHeight).round() + DateTime.now().year)
        .clamp(DateTime.now().year, DateTime.now().year + 50);
    double targetOffset = (nearestYear - DateTime.now().year) * itemHeight;

    _isYearScrolling = true;
    _yearController
        .animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    )
        .then((_) {
      _isYearScrolling = false;
      setState(() {
        selectedYear = nearestYear;
      });
    });
  }

  void _addSelectedDate() {
    DateTime selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    DateTime today = DateTime.now();
    DateTime todayDate = DateTime(today.year, today.month, today.day);

    // Check if the date is before today
    if (selectedDate.isBefore(todayDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot schedule meals for past dates',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Check if the date already exists
    bool dateExists = scheduledDates.any((dateEntry) {
      DateTime date = dateEntry['date'] as DateTime;
      return date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
    });

    if (dateExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'This date is already scheduled',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      scheduledDates.add({
        'date': selectedDate,
        'isLunch': _isLunchSelected,
      });
      scheduledDates.sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
      showDatePicker = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Date added successfully!',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeDate(Map<String, dynamic> dateToRemove) {
    setState(() {
      scheduledDates.remove(dateToRemove);
    });
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today : ${date.day} ${months[date.month - 1]} ${date.year}';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow : ${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildDateItem(int value, int selectedValue, bool isDay) {
    double distance = (value - selectedValue).abs().toDouble();
    double opacity = (1.0 - (distance * 0.2)).clamp(0.3, 1.0);
    double scale = (1.0 - (distance * 0.15)).clamp(0.7, 1.0);
    double fontSize = (18.0 - (distance * 1.5)).clamp(14.0, 20.0);

    bool isSelected = value == selectedValue;

    String displayText;
    if (isDay) {
      displayText = value.toString().padLeft(2, '0');
    } else {
      List<String> monthnoms = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      displayText = monthnoms[value - 1];
    }

    return Transform.scale(
      scale: scale,
      child: Container(
        height: itemHeight,
        alignment: Alignment.center,
        child: Text(
          displayText,
          style: GoogleFonts.inter(
            fontSize: fontSize,
            color: const Color(0xFF8B4513).withValues(alpha: opacity),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildYearItem(int year, int selectedYear) {
    double distance = (year - selectedYear).abs().toDouble();
    double opacity = (1.0 - (distance * 0.2)).clamp(0.3, 1.0);
    double scale = (1.0 - (distance * 0.15)).clamp(0.7, 1.0);
    double fontSize = (18.0 - (distance * 1.5)).clamp(14.0, 20.0);

    bool isSelected = year == selectedYear;

    return Transform.scale(
      scale: scale,
      child: Container(
        height: itemHeight,
        alignment: Alignment.center,
        child: Text(
          year.toString(),
          style: GoogleFonts.inter(
            fontSize: fontSize,
            color: const Color(0xFF8B4513).withValues(alpha: opacity),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                      'Schedule',
                      style: GoogleFonts.tiltWarp(
                          fontSize: MediaQuery.sizeOf(context).width * 0.05),
                    )),
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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Menu:',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                ...widget.selectedMeals.entries
                    .where((entry) => entry.value.isNotEmpty)
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Scheduled Dates and Custom Date Picker
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showDatePicker) ...[
                    // Scheduled dates list
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Scheduled Dates:',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _resetToToday(); // Reset to today's date
                            setState(() => showDatePicker = true);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B4513),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'ADD',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: scheduledDates.length,
                          itemBuilder: (context, index) {
                            final dateEntry = scheduledDates[index];
                            final date = dateEntry['date'] as DateTime;
                            final isLunch = dateEntry['isLunch'] as bool;
                            final isToday = DateTime.now().year == date.year &&
                                DateTime.now().month == date.month &&
                                DateTime.now().day == date.day;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF8B4513),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatDate(date),
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: isToday
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          isLunch ? 'Lunch' : 'Dinner',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: const Color(0xFF8B4513),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _removeDate(dateEntry),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Date:',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => showDatePicker = false),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Lunch/Dinner selection for this specific date
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.08,
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 227, 174, 144),
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        child: Row(
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
                                    width: 20,
                                    height: 20,
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
                                  const SizedBox(width: 8),
                                  Text(
                                    'Lunch',
                                    style: GoogleFonts.tiltWarp(
                                      fontSize:
                                          MediaQuery.sizeOf(context).width *
                                              0.045,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.brown[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                          MediaQuery.sizeOf(context).width *
                                              0.045,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 20,
                                    height: 20,
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
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Date Picker Headers
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'D',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8B4513),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'M',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8B4513),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Y',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8B4513),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Date Picker Rollers
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Center line indicator
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 75,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: const Color(0xFF8B4513)
                                        .withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // Day Picker
                              Expanded(
                                child: NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification notification) {
                                    if (notification is ScrollEndNotification) {
                                      _snapToNearestDay();
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                    controller: _dayController,
                                    itemCount: _getDaysInMonth(
                                        selectedMonth, selectedYear),
                                    itemExtent: itemHeight,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 75),
                                    itemBuilder: (context, index) {
                                      return _buildDateItem(
                                          index + 1, selectedDay, true);
                                    },
                                  ),
                                ),
                              ),
                              // Month Picker
                              Expanded(
                                child: NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification notification) {
                                    if (notification is ScrollEndNotification) {
                                      _snapToNearestMonth();
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                    controller: _monthController,
                                    itemCount: 12,
                                    itemExtent: itemHeight,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 75),
                                    itemBuilder: (context, index) {
                                      return _buildDateItem(
                                          index + 1, selectedMonth, false);
                                    },
                                  ),
                                ),
                              ),
                              // Year Picker
                              Expanded(
                                child: NotificationListener<ScrollNotification>(
                                  onNotification:
                                      (ScrollNotification notification) {
                                    if (notification is ScrollEndNotification) {
                                      _snapToNearestYear();
                                    }
                                    return true;
                                  },
                                  child: ListView.builder(
                                    controller: _yearController,
                                    itemCount: 51, // Current year + 50 years
                                    itemExtent: itemHeight,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 75),
                                    itemBuilder: (context, index) {
                                      int year = DateTime.now().year + index;
                                      return _buildYearItem(year, selectedYear);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Add Date Button
                    Center(
                      child: GestureDetector(
                        onTap: _addSelectedDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B4513),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            'ADD',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Save Button
          Padding(
            padding: EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.03),
            child: GestureDetector(
              onTap: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    final batch = FirebaseFirestore.instance.batch();

                    // Fetch dish data for each selected meal
                    Map<String, Map<String, dynamic>> dishesData = {};

                    for (String mealType in ['Entree', 'Plat', 'Dessert']) {
                      String? dishId = widget.selectedMealIds[mealType];
                      if (dishId != null && dishId.isNotEmpty) {
                        Map<String, dynamic>? dishData =
                            await _fetchDishData(dishId);
                        if (dishData != null) {
                          dishesData[mealType] = dishData;
                        }
                      }
                    }

                    for (Map<String, dynamic> dateEntry in scheduledDates) {
                      final date = dateEntry['date'] as DateTime;
                      final isLunch = dateEntry['isLunch'] as bool;
                      final dateString = DateFormat('yyyy-MM-dd').format(date);
                      final mealTime = isLunch ? 'lunch' : 'dinner';
                      final docRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('meal_selections')
                          .doc(dateString);

                      // Prepare meal data with fetched information
                      Map<String, dynamic> mealData = {};

                      for (String mealType in ['Entree', 'Plat', 'Dessert']) {
                        String key = mealType.toLowerCase();
                        if (mealType == 'Entree') key = 'Entree';

                        if (dishesData.containsKey(mealType)) {
                          Map<String, dynamic> dishData = dishesData[mealType]!;
                          mealData[key] = {
                            'nom': dishData['nom'] ?? '',
                            'id': widget.selectedMealIds[mealType] ?? '',
                            'imageUrl': dishData['imageUrl'] ?? '',
                            'rating': dishData['rating'] ?? 0,
                          };
                        }
                      }

                      batch.set(docRef, {mealTime: mealData},
                          SetOptions(merge: true));
                    }

                    await batch.commit();

                    // Hide loading indicator
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Menu scheduled successfully for ${_isLunchSelected ? 'Lunch' : 'Dinner'}!',
                          style: GoogleFonts.inter(),
                        ),
                        backgroundColor: const Color(0xFF8B4513),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  // Hide loading indicator if it's showing
                  if (Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error saving menu: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.6,
                height: MediaQuery.sizeOf(context).height * 0.065,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 70, 32, 9),
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: Text("Save",
                        style: GoogleFonts.tiltWarp(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.sizeOf(context).width * 0.045))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
