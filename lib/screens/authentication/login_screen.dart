import 'dart:io';
import 'otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:utube/components/widgets/rounded_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  static const id = "Loginpage";
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  bool _showSpinner = false;
  String phone = '';
  static String id = 'LoginPage';
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  Future<void> signInWithPhoneNumber(String phonenumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phonenumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (_) {},
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _showSpinner = false;
        });
        String errorMessage = "Verification failed. Please try again.";
        if (e.code == 'invalid-phone-number') {
          errorMessage = "Invalid phone number. Please enter a valid number.";
        } else if (e.code == 'too-many-requests') {
          errorMessage = "Too many requests. Please try again later.";
        }
        Utils().toastMessage(errorMessage);
      },
      codeSent: (String verificationId, int? token) async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OtpPage(verificationId)),
        );
        setState(() {
          _showSpinner = false;
        }); // authentication successful, do something
      },
      codeAutoRetrievalTimeout: (verificationId) {
        setState(() {
          _showSpinner = false;
        });
        Utils().toastMessage("Time Out");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log In',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 50.0,
                  child: ClipOval(
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Text(
                    'Log In To Getiing Started',
                    style: GoogleFonts.acme(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white70,
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {
                        phone = value;
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade700,
                      filled: true,
                      labelText: "Mobile number",
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: const BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          borderSide: const BorderSide(color: Colors.black38)),
                      prefixIcon: Container(
                        margin: Platform.isIOS
                            ? const EdgeInsets.fromLTRB(10, 9, 10, 12)
                            : const EdgeInsets.fromLTRB(10, 14, 10, 12),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 550,
                                ),
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                });
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35.0,
                ),
                RoundedButton(
                  text: "GET OTP",
                  ontap: () async {
                    try {
                      setState(() {
                        _showSpinner = true;
                      });
                      String mobile = "+${selectedCountry.phoneCode}$phone";
                      await signInWithPhoneNumber(mobile);
                    } catch (e) {
                      setState(() {
                        _showSpinner = false;
                      });
                      Utils()
                          .toastMessage("Please enter the mobile number again");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
