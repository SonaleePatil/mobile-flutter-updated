import 'package:adcc/core/services/token_storage_service.dart';
import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/Services/auth_services.dart';
import 'package:adcc/features/auth/view/setupProfile/setup_profile_screen.dart';
import 'package:adcc/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phone;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phone,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int seconds = 30;
  Timer? timer;
  bool canResend = false;
  bool _isLoading = false;
  String currentVerificationId = "";

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    currentVerificationId = widget.verificationId;
    startTimer();
    debugPrint("🚨 OTP SCREEN OPENED");
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  // ⏱ TIMER
  void startTimer() {
    seconds = 30;
    canResend = false;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
        setState(() {
          canResend = true;
        });
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  // 🔁 RESEND OTP
  Future<void> resendOtp() async {
    debugPrint("🔁 Resending OTP...");
    debugPrint("📞 Phone: ${widget.phone}");

    startTimer();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint("✅ Auto verification success");
        },
        verificationFailed: (FirebaseAuthException e) {
          final message = e.code == 'too-many-requests'
              ? 'Too many OTP attempts from this device. Please wait and try again later.'
              : (e.message ?? 'OTP resend failed');
          debugPrint("❌ Resend FAILED (${e.code}): $message");
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint("📨 OTP RESENT");

          setState(() {
            currentVerificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      debugPrint("🔥 RESEND ERROR: $e");
    }
  }

  // 🔐 VERIFY OTP
  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();

    debugPrint("🔐 VERIFY START");
    debugPrint("OTP: $otp");

    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: currentVerificationId,
        smsCode: otp,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final idToken = await userCredential.user!.getIdToken();

      if (idToken == null) throw Exception("No Firebase token");

      await TokenStorageService.saveFirebaseToken(idToken);

      debugPrint("📡 Calling backend...");

      final response = await AuthService.verifyOtp(idToken);

      debugPrint("📦 RESPONSE: ${response.data}");

      if (!mounted) return;

      if (response.success) {
        final isNewUser = response.data?['isNewUser'] == true;

        if (isNewUser) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SetupProfileScreen()),
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Failed")),
        );
      }
    } catch (e) {
      debugPrint("🔥 VERIFY ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double contentMaxWidth = 358;
    const double topGapAfterBack = 40;
    const double logoToTitleGap = 86;
    const double titleToSubtitleGap = 16;
    const double subtitleToOtpGap = 27;
    const double otpToResendGap = 26;
    const double resendToBottomGap = 244;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.softCream,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: contentMaxWidth),
                      child: Column(
                        children: [
                          const SizedBox(height: topGapAfterBack),
                          Image.asset(
                            'assets/icons/adcc_logo.png',
                            width: 85,
                            height: 69,
                          ),
                          const SizedBox(height: logoToTitleGap),
                          const Text(
                            'Verify Your Number',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              height: 1.25,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: titleToSubtitleGap),
                          const Text(
                            'Enter the 6-digit code sent to your phone',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 16,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: subtitleToOtpGap),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(right: index == 5 ? 0 : 8),
                                child: SizedBox(
                                  width: 44,
                                  height: 52,
                                  child: TextField(
                                    controller: _otpControllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(1),
                                    ],
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                        borderSide: const BorderSide(
                                          color: AppColors.deepRed,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) =>
                                        _onOtpChanged(index, value),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: otpToResendGap),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 14,
                                color: Color(0x99333333),
                              ),
                              children: [
                                const TextSpan(text: "Didn't receive it? "),
                                TextSpan(
                                  text: canResend
                                      ? "Resend OTP"
                                      : "Resend in $seconds s",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: canResend
                                        ? Colors.red
                                        : const Color(0xFF333333),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        canResend ? () => resendOtp() : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: resendToBottomGap),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 51,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deepRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Verify'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
