// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delices_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode usernomFocusNode;
  late TextEditingController email;
  late TextEditingController usernom;
  late TextEditingController password;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    usernomFocusNode = FocusNode();
    usernom = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    usernomFocusNode.dispose();
    usernom.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void emailRequestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(emailFocusNode);
    });
  }

  void usernomRequestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(usernomFocusNode);
    });
  }

  void passwordRequestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(passwordFocusNode);
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> copyCollectionWithRating({
    required String sourceCollectionPath,
    required String targetCollectionPath,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final useruid = FirebaseAuth.instance.currentUser!.uid;

      // Get reference to source collection
      final CollectionReference sourceCollection =
          firestore.collection(sourceCollectionPath);

      // Get reference to target collection
      final CollectionReference targetCollection = firestore
          .collection('users')
          .doc(useruid)
          .collection(targetCollectionPath);

      // Get all documents from source collection
      final QuerySnapshot sourceSnapshot = await sourceCollection.get();

      // Create a batch for efficient writes
      final WriteBatch batch = firestore.batch();

      // Process each document
      for (QueryDocumentSnapshot doc in sourceSnapshot.docs) {
        // Get the original data
        Map<String, dynamic> originalData = doc.data() as Map<String, dynamic>;

        // Add the rating field
        Map<String, dynamic> newData = {
          ...originalData,
          'rating': 6,
        };

        // Create reference for new document with same ID
        final DocumentReference newDocRef = targetCollection.doc(doc.id);

        // Add to batch
        batch.set(newDocRef, newData);
      }

      // Execute all writes in batch
      await batch.commit();

      
    } catch (e) {
      rethrow;
    }
  }

  /// Alternative version that copies to a subcollection within a specific document
  Future<void> copyCollectionToSubcollection({
    required String sourceCollectionPath,
    required String targetDocumentPath,
    required String targetSubcollectionnom,
  }) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get reference to source collection
      final CollectionReference sourceCollection =
          firestore.collection(sourceCollectionPath);

      // Get reference to target subcollection
      final CollectionReference targetSubcollection =
          firestore.doc(targetDocumentPath).collection(targetSubcollectionnom);

      // Get all documents from source collection
      final QuerySnapshot sourceSnapshot = await sourceCollection.get();

      // Create a batch for efficient writes
      final WriteBatch batch = firestore.batch();

      // Process each document
      for (QueryDocumentSnapshot doc in sourceSnapshot.docs) {
        // Get the original data
        Map<String, dynamic> originalData = doc.data() as Map<String, dynamic>;

        // Add the rating field
        Map<String, dynamic> newData = {
          ...originalData,
          'rating': 6,
        };

        // Create reference for new document with same ID
        final DocumentReference newDocRef = targetSubcollection.doc(doc.id);

        // Add to batch
        batch.set(newDocRef, newData);
      }

      // Execute all writes in batch
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  // Validation methods
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  String? _validateInputs() {
    if (usernom.text.trim().isEmpty) {
      return 'Please enter a usernom';
    }
    if (email.text.trim().isEmpty) {
      return 'Please enter an email address';
    }
    if (!_isValidEmail(email.text.trim())) {
      return 'Please enter a valid email address';
    }
    if (password.text.isEmpty) {
      return 'Please enter a password';
    }
    if (!_isValidPassword(password.text)) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _createAccount() async {
    // Validate inputs
    String? validationError = _validateInputs();
    if (validationError != null) {
      _showErrorDialog(validationError);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Check if usernom is already taken
      QuerySnapshot usernomQuery = await _firestore
          .collection('users')
          .where('usernom', isEqualTo: usernom.text.trim())
          .get();

      if (usernomQuery.docs.isNotEmpty) {
        _showErrorDialog(
            'Usernom is already taken. Please choose another one.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text,
      );

      // Get the created user
      User? user = userCredential.user;

      if (user != null) {
        // Create user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'usernom': usernom.text.trim(),
          'email': email.text.trim(),
          'age': 22,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        copyCollectionWithRating(
            sourceCollectionPath: 'dishes', targetCollectionPath: 'dishes');
        // Update the user's display nom
        await user.updateDisplayName(usernom.text.trim());

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).push(DialogRoute(
          context: context,
          builder: (context) => const AuthWrapper(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for this email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('An unexpected error occurred. Please try again.');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required VoidCallback onTap,
    required String hintText,
    required String labelText,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.073,
        width: MediaQuery.sizeOf(context).width * 0.84,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          obscureText: obscureText,
          keyboardType: keyboardType,
          cursorColor: const Color.fromRGBO(70, 32, 9, 1),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: Color.fromRGBO(70, 32, 9, 1))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                    const BorderSide(color: Color.fromRGBO(70, 32, 9, 1))),
            hintText: hintText,
            hintStyle: GoogleFonts.poppins(color: Colors.grey.shade300),
            labelText: labelText,
            labelStyle:
                WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
              final Color color = states.contains(WidgetState.focused)
                  ? const Color.fromRGBO(70, 32, 9, 1)
                  : Colors.grey.shade300;
              return GoogleFonts.poppins(color: color);
            }),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child:  Scaffold(
          body: SingleChildScrollView(
            child:Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
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
                      height: MediaQuery.sizeOf(context).height * 0.07,
                    ),
                    Text(
                      'Sign Up',
                      style: GoogleFonts.lexendDeca(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Usernom Field
                    _buildTextField(
                      controller: usernom,
                      focusNode: usernomFocusNode,
                      onTap: usernomRequestFocus,
                      hintText: 'Usernom',
                      labelText: 'Usernom',
                    ),

                    const SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      controller: email,
                      focusNode: emailFocusNode,
                      onTap: emailRequestFocus,
                      hintText: 'example@gmail.com',
                      labelText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    // Password Field
                    _buildTextField(
                      controller: password,
                      focusNode: passwordFocusNode,
                      onTap: passwordRequestFocus,
                      hintText: 'Password',
                      labelText: 'Password',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromRGBO(70, 32, 9, 1),
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.05,
                    ),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(70, 32, 9, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Create Account',
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
        ),
      ),
    );
  }
}
