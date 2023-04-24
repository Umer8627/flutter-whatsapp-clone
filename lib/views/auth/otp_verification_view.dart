

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/repo/auth_repo.dart';
import 'package:whatsapp_clone/state/timer_state.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import 'package:whatsapp_clone/views/auth/profile_view.dart';
import 'package:whatsapp_clone/views/widgets/loader_button.dart';
import '../../constants/color_constant.dart';
import '../../constants/theme_constant.dart';
import 'component/otp_field.dart';

class OTPVerificationView extends StatefulWidget {
  final String verificationId;
  final String phoneNo;
  const OTPVerificationView(
      {super.key, required this.verificationId, required this.phoneNo});

  @override
  State<OTPVerificationView> createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends State<OTPVerificationView> {
  final otpController1 = TextEditingController();
  final otpController2 = TextEditingController();
  final otpController3 = TextEditingController();
  final otpController4 = TextEditingController();
  final otpController5 = TextEditingController();
  final otpController6 = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Provider.of<TimerState>(context, listen: false).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Code'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Consumer<TimerState>(builder: (context, timeState, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('We have sent the code verification to',
                  style: CustomFont.regularText.copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(formatPhoneNumber(widget.phoneNo),
                      style:
                          CustomFont.regularText.copyWith(color: Colors.white)),
                  const SizedBox(width: 5),
                  TextButton(
                      onPressed: () {
                        pop(context);
                      },
                      child: Text(
                        'Change No?',
                        style: CustomFont.regularText.copyWith(color: tabColor),
                      ))
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OTPField(
                    controller: otpController1,
                  ),
                  OTPField(
                    controller: otpController2,
                  ),
                  OTPField(
                    controller: otpController3,
                  ),
                  OTPField(
                    controller: otpController4,
                  ),
                  OTPField(
                    controller: otpController5,
                  ),
                  OTPField(
                    controller: otpController6,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Center(
                child: timeState.secondsLeft == 0
                    ? Text('Code has expired.',
                        style: CustomFont.regularText.copyWith(color: tabColor))
                    : Text(
                        'Code will expire in ${timeState.secondsLeft} seconds.',
                        style:
                            CustomFont.regularText.copyWith(color: tabColor)),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  timeState.secondsLeft == 0
                      ? SizedBox(
                          width: 160,
                          child: LoaderButton(
                              borderSide: tabColor,
                              color: tabColor,
                              fontWeight: FontWeight.w500,
                              textSize: 20,
                              textColor: Colors.white,
                              btnText: 'Resend',
                              onTap: () async {
                                try {
                                  AuthRepo.instance.sendVerificationCode(
                                      phoneNo: widget.phoneNo,
                                      onVerificationFailed: (e) {
                                        snack(context, e.toString());
                                        return;
                                      },
                                      onTimeOut: (error) {
                                        snack(context, error.toString());
                                        return;
                                      },
                                      onCodeSent: (verificationId) {
                                        Provider.of<TimerState>(context,
                                                listen: false)
                                            .startTimer();
                                        debugPrint('Code sent $verificationId');
                                      });
                                } catch (e) {
                                  snack(context, e.toString());
                                }
                              }))
                      : Container(),
                  const SizedBox(width: 10),
                  timeState.secondsLeft != 0
                      ? SizedBox(
                          width: 160,
                          child: LoaderButton(
                              borderSide: tabColor,
                              color: backgroundColor,
                              fontWeight: FontWeight.w500,
                              textSize: 20,
                              textColor: tabColor,
                              btnText: 'Verify',
                              onTap: () async {
                                final otpCode = otpController1.text +
                                    otpController2.text +
                                    otpController3.text +
                                    otpController4.text +
                                    otpController5.text +
                                    otpController6.text;
                                try {
                                  await AuthRepo.instance.verifyOTP(
                                      verificationId: widget.verificationId,
                                      userOTP: otpCode,
                                      navigate: () {
                                        replace(context, const ProfileView());
                                      });
                                } catch (e) {
                                  String err = e.toString();
                                  String msg =
                                      err.substring(err.indexOf("] ") + 2);
                                  snack(context, msg);
                                }
                              }))
                      : Container(),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }
}

String formatPhoneNumber(String phoneNumber) {
  String countryCode = phoneNumber.substring(0, 3);
  String middleDigits = phoneNumber.substring(3, phoneNumber.length - 4);
  String lastDigits = phoneNumber.substring(phoneNumber.length - 2);
  String formattedNumber = '$countryCode$middleDigits******$lastDigits';
  return formattedNumber;
}
