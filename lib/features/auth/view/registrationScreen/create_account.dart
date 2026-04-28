import 'package:adcc/core/theme/app_colors.dart';
import 'package:adcc/features/auth/view/otpScreen/otp.dart';
import 'package:adcc/l10n/app_localizations.dart';
import 'package:adcc/shared/widgets/app_button.dart';
import 'package:adcc/shared/widgets/app_header_login.dart';
import 'package:adcc/shared/widgets/app_phone_number_field.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool _isSendingOtp = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String countryCode = "+971";

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // void _submitForm() {
  //   setState(() {
  //     _autoValidateMode = AutovalidateMode.onUserInteraction;
  //   });

  //   if (_formKey.currentState!.validate()) {
  //     debugPrint('Phone: ${_phoneController.text}');
  //     debugPrint('Email: ${_emailController.text}');
  //      Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (_) => const OtpScreen()),
  //     );
  //   }
  // }

  void _submitForm() async {
    if (_isSendingOtp) return;

    setState(() {
      _autoValidateMode = AutovalidateMode.onUserInteraction;
    });

    if (_formKey.currentState!.validate()) {
      final phone = "$countryCode${_phoneController.text}";

      debugPrint("📱 Sending OTP to: $phone");
      setState(() {
        _isSendingOtp = true;
      });

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          debugPrint("✅ Auto verification completed");
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint("❌ OTP Failed (${e.code}): ${e.message}");

          final message = e.code == 'too-many-requests'
              ? 'Too many OTP attempts from this device. Please wait and try again later.'
              : (e.message ?? "OTP Failed");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );

          if (mounted) {
            setState(() {
              _isSendingOtp = false;
            });
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint("📨 OTP Sent");
          debugPrint("🆔 verificationId: $verificationId");

          if (mounted) {
            setState(() {
              _isSendingOtp = false;
            });
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                verificationId: verificationId,
                phone: phone,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint("⏱️ Timeout");
          if (mounted) {
            setState(() {
              _isSendingOtp = false;
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF6EC), Color(0xFFEAF4FF)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppHeaderLogin(
                  onBack: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autoValidateMode,
                      child: Column(
                        children: [
                          /// Logo
                          Image.asset('assets/icons/adcc_logo.png', height: 80),
                          const SizedBox(height: 60),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 150,
                                  height: 25,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 250, 243),
                                        Color.fromARGB(255, 246, 226, 192),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    height: 1.4,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: l10n.create_account_heading
                                            .toUpperCase()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          Text(l10n.create_account_title,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textLightGrey,
                                height: 1.4,
                              )),

                          const SizedBox(height: 40),

                          /// Phone Field
                          AppPhoneNumberField(
                            controller: _phoneController,
                            hintText: l10n.phone_number_placeholder,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              if (value.length < 8) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                            onCountryChanged: (country) {
                              setState(() {
                                countryCode = "+${country.phoneCode}";
                              });
                              debugPrint(
                                'Selected country: ${country.name} (+${country.phoneCode})',
                              );
                            },
                          ),

                          // InputField(
                          //   controller: _phoneController,
                          //   hint: 'Continue with phone',
                          //   image: Image.asset(
                          //     'assets/icons/email_Icon.png',
                          //     width: 22,
                          //     height: 22,
                          //   ),
                          //   keyboardType: TextInputType.phone,
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Phone number is required';
                          //     }
                          //     if (value.length < 8) {
                          //       return 'Enter a valid phone number';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const SizedBox(height: 24),

                          /// Create Account Button
                          AppButton(
                            label: l10n.continue_button.toUpperCase(),
                            backgroundColor: AppColors.orange,
                            borderRadius: 16,
                            isLoading: _isSendingOtp,
                            onPressed: _isSendingOtp ? null : _submitForm,
                          ),

                          const SizedBox(height: 24),

                          /// Or sign in with
                          Text(
                            l10n.login_link,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// FIXED BOTTOM TEXT
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Text(
                    l10n.policy,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
