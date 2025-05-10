import 'package:delices_app/choosefood.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    for (int i = 0; i < 5; i++) {
      _dates.add(startDate.add(Duration(days: i)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Padding(
          padding:  EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).height * 0.02,),
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
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
          ],
        ),
      ),
      SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
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
            final dayName = DateFormat('E').format(date).substring(0, 3);
            final dayNumber = date.day.toString();

            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isSelected
                      ? MediaQuery.sizeOf(context).width * 0.035
                      : MediaQuery.sizeOf(context).width * 0.015),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                    _dates = [];
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
                          dayName,
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
                            height: MediaQuery.sizeOf(context).height * 0.01),
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
      SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.05,
      ),
      Container(
  height: MediaQuery.sizeOf(context).height * 0.22,
  width: MediaQuery.sizeOf(context).width * 0.9,
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 227, 174, 144),
    borderRadius: BorderRadius.circular(29),
  ),
  child: Stack(
    children: [
      SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.9,
        height: MediaQuery.sizeOf(context).height * 0.22,
        child: Image.asset('./assets/lunchdinner.png', fit: BoxFit.fill),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                          border: Border.all(color: Colors.brown, width: 2),
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
                          fontSize: MediaQuery.sizeOf(context).width*0.06,
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
                          fontSize: MediaQuery.sizeOf(context).width*0.06,
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
                          border: Border.all(color: Colors.white, width: 2),
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
                        'Entrée',
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
      )
    ]));
  }
}
