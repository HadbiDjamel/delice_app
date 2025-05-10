import 'package:delices_app/choosefood.dart';
import 'package:delices_app/pagedirection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                       
                      },
                      child: Stack(alignment: Alignment.center, children: [
                        Image.asset("./assets/browncircle.png"),
                        Image.asset('./assets/menu.png')
                      ]),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.663,
                      height: MediaQuery.sizeOf(context).height * 0.07,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 167, 135, 115),
                          borderRadius: BorderRadius.circular(35)),
                      child:Center(
                            child: Text(
                          'Profile',
                          style: GoogleFonts.tiltWarp(
                              fontSize:
                                  MediaQuery.sizeOf(context).width * 0.05),
                        )),
                      
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const ChooseFood(),
                          ));
                        },
                        child: Image.asset("./assets/dishes.png")),
                  ],
                ),
              ),
        SizedBox(height: MediaQuery.sizeOf(context).height*0.04,),
        SizedBox(
          height: MediaQuery.sizeOf(context).height*0.8,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: MediaQuery.sizeOf(context).width*0.08,),
                  Text('Informations :',style: GoogleFonts.tiltWarp(fontSize: MediaQuery.sizeOf(context).width*0.05),),
                ],
              ),
              Container(
            height: MediaQuery.sizeOf(context).height * 0.2,
            width: MediaQuery.sizeOf(context).width * 0.85,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241,215,200),
                borderRadius: BorderRadius.circular(29)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  
                  SizedBox(
                    width:  MediaQuery.sizeOf(context).width*0.3,
                    height:  MediaQuery.sizeOf(context).height*0.15,
                    child: Image.asset('./assets/profilephoto.png',fit: BoxFit.fill,)),
                  // CircleAvatar(backgroundImage: AssetImage('./assets/plat1.png'),radius: MediaQuery.sizeOf(context).width*0.15,)
                  Padding(
                    padding: EdgeInsets.only(left:MediaQuery.sizeOf(context).width*0.07),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                                    width: MediaQuery.sizeOf(context).width * 0.4,
                                    height: MediaQuery.sizeOf(context).height*0.05,
                                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white),
                    child: Center(child: Text("Name",style: GoogleFonts.tiltWarp(
                      
                    ),)),
                                  ),
                        SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
                        Container(
                                    width: MediaQuery.sizeOf(context).width * 0.4,
                                    height: MediaQuery.sizeOf(context).height*0.05,
                                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: Colors.white),
                    child: Center(child: Text("Age",style: GoogleFonts.tiltWarp(
                      
                    ),)),
                                  ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height*0.05,),
          Row(
                children: [
                  SizedBox(width: MediaQuery.sizeOf(context).width*0.08,),
                  Text('History :',style: GoogleFonts.tiltWarp(fontSize: MediaQuery.sizeOf(context).width*0.05),),
                ],
              ),
              
          Container(
            height: MediaQuery.sizeOf(context).height * 0.4,
            width: MediaQuery.sizeOf(context).width * 0.85,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241,215,200),
                borderRadius: BorderRadius.circular(29)),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
                SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.38,
                width: MediaQuery.sizeOf(context).width * 0.85,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:15.0),
                        child: Row(
                          children: [
                            Text('Today',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height*0.17,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                child: Image.asset('./assets/div-1.png',fit: BoxFit.fill,),
                                
                              ),
                              Container(
                                height: MediaQuery.sizeOf(context).height*0.025,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(29),bottomRight: Radius.circular(29)),
                                  color: Colors.white
                                ),
                                child: Center(child: Text("something",style: GoogleFonts.tiltWarp(fontSize: MediaQuery.sizeOf(context).width*0.02),)),
                              )
                            ],
                          ),
                          Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height*0.17,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                child: Image.asset('./assets/div-2.png',fit: BoxFit.fill,),
                                
                              ),
                              Container(
                                height: MediaQuery.sizeOf(context).height*0.025,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(29),bottomRight: Radius.circular(29)),
                                  color: Colors.white
                                ),
                                child: Center(child: Text("something",style: GoogleFonts.tiltWarp(fontSize: MediaQuery.sizeOf(context).width*0.02),)),
                              )
                            ],
                          ),
                          Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height*0.17,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                child: Image.asset('./assets/div-5.png',fit: BoxFit.fill,),
                                
                              ),
                              Container(
                                height: MediaQuery.sizeOf(context).height*0.025,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(29),bottomRight: Radius.circular(29)),
                                  color: Colors.white
                                ),
                                child: Center(child: Text("something",style: GoogleFonts.tiltWarp(fontSize: MediaQuery.sizeOf(context).width*0.02),)),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:15.0,left:15.0),
                        child: Row(
                          children: [
                            Text('Last Day',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height*0.17,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                child: Image.asset('./assets/img-1.png',fit: BoxFit.fill,),
                                
                              ),
                              Container(
                                height: MediaQuery.sizeOf(context).height*0.025,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(29),bottomRight: Radius.circular(29)),
                                  color: Colors.white
                                ),
                                child: Center(child: Text("something",style: GoogleFonts.tiltWarp(fontSize: MediaQuery.sizeOf(context).width*0.02),)),
                              )
                            ],
                          ),
                          Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height*0.17,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                child: Image.asset('./assets/img-2.png',fit: BoxFit.fill,),
                                
                              ),
                              Container(
                                height: MediaQuery.sizeOf(context).height*0.025,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(29),bottomRight: Radius.circular(29)),
                                  color: Colors.white
                                ),
                                child: Center(child: Text("something",style: GoogleFonts.tiltWarp(fontSize: MediaQuery.sizeOf(context).width*0.02),)),
                              )
                            ],
                          ),
                          Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height*0.17,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                child: Image.asset('./assets/img-3.png',fit: BoxFit.fill,),
                                
                              ),
                              Container(
                                height: MediaQuery.sizeOf(context).height*0.025,
                                width: MediaQuery.sizeOf(context).width*0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(29),bottomRight: Radius.circular(29)),
                                  color: Colors.white
                                ),
                                child: Center(child: Text("something",style: GoogleFonts.tiltWarp(fontSize: MediaQuery.sizeOf(context).width*0.02),)),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
          
            ],
            
          ))
    ]));
  }
}