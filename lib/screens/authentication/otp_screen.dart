import 'package:flutter/material.dart';
import 'package:utube/components/utils/utils.dart';
import 'package:utube/controllers/otpscreencontroller.dart';
import 'package:utube/screens/app_screen/viewscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pinput/pinput.dart';
import 'package:utube/components/global.dart';

class OtpPage extends StatefulWidget {
  static String id = 'GetOtpScreen';
  final String verificationid;
  const OtpPage(this.verificationid, {super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool _showSpinner = false;
  String userOtp = '';
  final UploadUser uploadUser = UploadUser();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  final TextEditingController _thirdController = TextEditingController();
  final TextEditingController _fourthController = TextEditingController();
  final TextEditingController _fifthController = TextEditingController();
  final TextEditingController _sixthController = TextEditingController();

  void verifyOtp(String verificationid) async {
    try {
      final creds = PhoneAuthProvider.credential(
        verificationId: widget.verificationid,
        smsCode: userOtp,
      );
      User? user = (await firebaseAuth.signInWithCredential(creds)).user;
      if (user != null) {
        setState(() {
          _showSpinner = true;
        });
        late String phoneNumber;
        if (user.phoneNumber == null) {
          phoneNumber = "error";
        } else {
          phoneNumber = user.phoneNumber!;
        }
        await uploadUser.uploadUser(
            phoneNumber, 'assets/images/profile_avatar.jpg');
        await Navigator.pushNamed(context, HomeScreen.id);
        setState(() {
          _showSpinner = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showSpinner = false;
      });
      Utils().toastMessage(e.toString());
    }
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
    minimumSize: const Size(188, 48),
    backgroundColor: const Color(0xFFFD7877),
    elevation: 6,
    textStyle: const TextStyle(fontSize: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(50),
      ),
    ),
  );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Scaffold(
          body: SafeArea(
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
                    height: 10.0,
                  ),
                  buildText('Enter 6 digit OTP'),
                  buildText('sent to your number'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const SizedBox(height: 50),
                  SingleChildScrollView(
                    child: Pinput(
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white70,
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      onCompleted: (value) {
                        setState(() {
                          userOtp = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      style: style,
                      onPressed: () {
                        setState(() {
                          _showSpinner = true;
                        });
                        if (userOtp != null) {
                          verifyOtp(widget.verificationid);
                        } else {
                          setState(() {
                            _showSpinner = false;
                          });
                          Utils().toastMessage("Please enter the otp");
                        }
                      },
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      )),
                  const SizedBox(height: 80),
                  const Text(
                    "Didn't receive any code?",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showSpinner = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Resend new code",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    _fifthController.dispose();
    _sixthController.dispose();
  }
}
