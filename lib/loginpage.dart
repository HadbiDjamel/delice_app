// ignore_for_file: use_build_context_synchronously

import 'package:delices_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late TextEditingController email;
  late TextEditingController password;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Error messages
  String emailError = '';
  String passwordError = '';
  String generalError = '';

  // Loading state
  bool isLoading = false;
  bool isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    email = TextEditingController();
    password = TextEditingController();

    // Add listeners to clear errors when user starts typing
    email.addListener(_clearEmailError);
    password.addListener(_clearPasswordError);
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _clearEmailError() {
    if (emailError.isNotEmpty) {
      setState(() {
        emailError = '';
        generalError = '';
      });
    }
  }

  void _clearPasswordError() {
    if (passwordError.isNotEmpty) {
      setState(() {
        passwordError = '';
        generalError = '';
      });
    }
  }

  void emailrequestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(emailFocusNode);
    });
  }

  void passwordrequestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(passwordFocusNode);
    });
  }

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate form inputs
  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      emailError = '';
      passwordError = '';
      generalError = '';
    });

    if (email.text.trim().isEmpty) {
      setState(() {
        emailError = 'Email is required';
      });
      isValid = false;
    } else if (!_isValidEmail(email.text.trim())) {
      setState(() {
        emailError = 'Please enter a valid email address';
      });
      isValid = false;
    }

    if (password.text.isEmpty) {
      setState(() {
        passwordError = 'Password is required';
      });
      isValid = false;
    } else if (password.text.length < 6) {
      setState(() {
        passwordError = 'Password must be at least 6 characters';
      });
      isValid = false;
    }

    return isValid;
  }

  // Handle Firebase Auth errors
  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address format';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled';
      case 'weak-password':
        return 'Password is too weak';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'internal-error':
        return 'An internal error occurred. Please try again';
      default:
        return 'An error occurred. Please try again';
    }
  }

  // Email/Password Login
  Future<void> _loginWithEmailPassword() async {
    if (!_validateInputs()) return;

    setState(() {
      isLoading = true;
      generalError = '';
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );

      if (userCredential.user != null) {
        // Login successful - navigate to home page or handle success
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
       Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AuthWrapper(),
    ));
    } on FirebaseAuthException catch (e) {
      setState(() {
        String errorMessage = _getFirebaseErrorMessage(e.code);

        // Show specific field errors for certain cases
        if (e.code == 'user-not-found' || e.code == 'invalid-email') {
          emailError = errorMessage;
        } else if (e.code == 'wrong-password' || e.code == 'weak-password') {
          passwordError = errorMessage;
        } else {
          generalError = errorMessage;
        }
      });
    } catch (e) {
      setState(() {
        generalError = 'An unexpected error occurred. Please try again';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
   
  }

  // Google Sign In
  Future<void> _loginWithGoogle() async {
    setState(() {
      isGoogleLoading = true;
      generalError = '';
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        setState(() {
          isGoogleLoading = false;
        });
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Login successful
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google login successful!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        generalError = _getFirebaseErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        generalError = 'Google sign-in failed. Please try again';
      });
    } finally {
      if (mounted) {
        setState(() {
          isGoogleLoading = false;
        });
      }
    }
  }

  // Reset Password
  Future<void> _resetPassword() async {
    if (email.text.trim().isEmpty) {
      setState(() {
        emailError = 'Please enter your email address first';
      });
      return;
    }

    if (!_isValidEmail(email.text.trim())) {
      setState(() {
        emailError = 'Please enter a valid email address';
      });
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        emailError = _getFirebaseErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        generalError = 'Failed to send reset email. Please try again';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('./assets/logo.png'),
          
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.07,
                  ),
                  Text(
                    'Login',
                    style: GoogleFonts.lexendDeca(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          
                  // General Error Message
                  if (generalError.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        border:
                            Border.all(color: Colors.red.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        generalError,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
          
                  // Email Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.073,
                          width: MediaQuery.sizeOf(context).width * 0.84,
                          child: TextField(
                              controller: email,
                              focusNode: emailFocusNode,
                              onTap: emailrequestFocus,
                              cursorColor: const Color.fromRGBO(70, 32, 9, 1),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: emailError.isNotEmpty
                                            ? Colors.red
                                            : const Color.fromRGBO(
                                                70, 32, 9, 1))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: emailError.isNotEmpty
                                            ? Colors.red
                                            : const Color.fromRGBO(
                                                70, 32, 9, 1))),
                                hintText: 'example@gmail.com',
                                hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade300),
                                labelText: 'Email Address',
                                labelStyle: WidgetStateTextStyle.resolveWith(
                                    (Set<WidgetState> states) {
                                  final Color color = states
                                          .contains(WidgetState.focused)
                                      ? (emailError.isNotEmpty
                                          ? Colors.red
                                          : const Color.fromRGBO(70, 32, 9, 1))
                                      : Colors.grey.shade300;
                                  return GoogleFonts.poppins(color: color);
                                }),
                              )),
                        ),
                        if (emailError.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            emailError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          
                  const SizedBox(height: 20),
          
                  // Password Field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.073,
                          width: MediaQuery.sizeOf(context).width * 0.84,
                          child: TextField(
                              controller: password,
                              focusNode: passwordFocusNode,
                              onTap: passwordrequestFocus,
                              obscureText: _obscurePassword,
                              cursorColor: const Color.fromRGBO(70, 32, 9, 1),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: passwordError.isNotEmpty
                                            ? Colors.red
                                            : const Color.fromRGBO(
                                                70, 32, 9, 1))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: passwordError.isNotEmpty
                                            ? Colors.red
                                            : const Color.fromRGBO(
                                                70, 32, 9, 1))),
                                hintText: 'Password ',
                                hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey.shade300),
                                labelText: 'Password ',
                                labelStyle: WidgetStateTextStyle.resolveWith(
                                    (Set<WidgetState> states) {
                                  final Color color = states
                                          .contains(WidgetState.focused)
                                      ? (passwordError.isNotEmpty
                                          ? Colors.red
                                          : const Color.fromRGBO(70, 32, 9, 1))
                                      : Colors.grey.shade300;
                                  return GoogleFonts.poppins(color: color);
                                }),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color.fromRGBO(70, 32, 9, 1),
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                              )),
                        ),
                        if (passwordError.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            passwordError,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
          
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _resetPassword,
                      child: const Text(
                        'Forgot Password ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
          
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _loginWithEmailPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(70, 32, 9, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Login my account',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
          
                  // Or Login with
                  const Text(
                    'Or Login with',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
          
                  // Google Login Button
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.06,
                    child: ElevatedButton.icon(
                      onPressed: isGoogleLoading ? null : _loginWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: isGoogleLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Image.asset('./assets/Google.png'),
                      label: Text(
                        isGoogleLoading
                            ? 'Signing in...'
                            : 'Continue with Google',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
