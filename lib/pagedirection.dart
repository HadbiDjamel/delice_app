import 'package:delices_app/calanderpage.dart';
import 'package:delices_app/homepage.dart';
import 'package:delices_app/profilepage.dart';
import 'package:flutter/material.dart';

class PageDirection extends StatefulWidget {
  const PageDirection({super.key});

  @override
  State<PageDirection> createState() => _PageDirectionState();
}

class _PageDirectionState extends State<PageDirection> {
  int index = 0;
  List<Widget> pages = [
    const HomePage(),
    const CalanderPage(),
    const ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          pages[index],
          Container(
        height: MediaQuery.sizeOf(context).height * 0.1,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(38),
              child: Container(
                height: 63,
                width: 369,
                color: const Color(0xFF46210A),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.09,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.sizeOf(context).height * 0.5),
                                color: index == 0 ? Colors.white : Colors.transparent),
                            child: Image.asset(index == 0 ? "./assets/homechoosen.png" :"./assets/home.png")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                         onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.09,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.sizeOf(context).height * 0.5),
                                color: index == 1 ? Colors.white : Colors.transparent),
                            child: Image.asset(index == 1 ? "./assets/calanderchoosen.png" :"./assets/calander.png")),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                         onTap: () {
                          setState(() {
                            index = 2;
                          });
                        },
                        child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.09,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.sizeOf(context).height * 0.5),
                                color: index == 2 ? Colors.white : Colors.transparent),
                            child: Image.asset(index == 2 ? "./assets/profilechoosen.png" :"./assets/profile.png")),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
        ],
      )
    );
  }
}
