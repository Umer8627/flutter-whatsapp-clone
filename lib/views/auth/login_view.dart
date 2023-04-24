import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/repo/auth_repo.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/auth/otp_verification_view.dart';
import 'package:whatsapp_clone/views/widgets/loader_button.dart';
import '../../constants/color_constant.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final phoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    phoneController.text = '3216445675';
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        showPhoneCode: true,
        useSafeArea: true,
        onSelect: (Country country) {
          setState(() {
            selectedCountry = country;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'WhatsApp will need to verify your phone number.',
                style: CustomFont.lightText
                    .copyWith(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: tabColor))),
                    child: SizedBox(
                      width: 50,
                      height: 49,
                      child: selectedCountry == null
                          ? InkWell(
                              onTap: pickCountry,
                              child: Center(
                                child: Text('+**',
                                    style: CustomFont.mediumText.copyWith(
                                        color: tabColor, fontSize: 20)),
                              ),
                            )
                          : InkWell(
                              onTap: pickCountry,
                              child: Center(
                                child: Text('+${selectedCountry!.phoneCode}',
                                    style: CustomFont.lightText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 15)),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.justify,
                      style: CustomFont.regularText.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 15),
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: tabColor),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: tabColor),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: tabColor),
                        ),
                        hintStyle: CustomFont.regularText.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        hintText: 'Enter phone number',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.6),
              SizedBox(
                width: 200,
                child: LoaderButton(
                  borderSide: tabColor,
                  color: backgroundColor,
                  fontWeight: FontWeight.w500,
                  btnText: 'Next',
                  textSize: 20,
                  textColor: tabColor,
                  onTap: () async {
                    if (selectedCountry == null) {
                      snack(context, 'Please select country code');
                      return;
                    }
                    if (phoneController.text.isEmpty) {
                      snack(context, 'Please enter phone number');
                      return;
                    }
                    final phone =
                        '+${selectedCountry!.phoneCode}${phoneController.text}';
                    debugPrint('Phone: $phone');
                    try {
                      await AuthRepo.instance.sendVerificationCode(
                          phoneNo: phone,
                          onVerificationFailed: (e) {
                            snack(context, e.toString());
                            return;
                          },
                          onTimeOut: (error) {
                            if (auth.currentUser?.uid == null) {
                              snack(context, error.toString());
                              return;
                            }
                          },
                          onCodeSent: (verificationId) {
                            push(
                                context,
                                OTPVerificationView(
                                    verificationId: verificationId,
                                    phoneNo: phone));
                          });
                    } catch (e) {
                      snack(context, e.toString());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }
}
