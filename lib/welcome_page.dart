import 'package:delices_app/loginpage.dart';
import 'package:delices_app/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height*0.1),
                
                 Image.asset('./assets/logo.png'),
                
                 SizedBox(height: MediaQuery.sizeOf(context).height*0.1),
                
                
                
                 Text(
                  'Hi !\nWelcome To Delices',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
                
                SizedBox(height: MediaQuery.sizeOf(context).height*0.34,),
                
                // Next Button
                SizedBox(
                  width: double.infinity,
                  height: 56, 
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to login page
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage(),));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(70, 32, 9, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Already have account
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                  },
                  child: const Text(
                    'Already have an account ? Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}