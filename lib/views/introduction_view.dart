import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/images_path.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/views/auth/login_view.dart';
import 'package:whatsapp_clone/views/widgets/loader_button.dart';

import '../constants/color_constant.dart';
import '../utills/snippets.dart';

class IntroductionView extends StatefulWidget {
  const IntroductionView({super.key});

  @override
  State<IntroductionView> createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 50),
              Text('Welcome to WhatsApp',
                  style: CustomFont.mediumText.copyWith(color: Colors.white)),
              Image.asset(ImagesPath.bg,
                  height: 250, width: 340, color: tabColor),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                    'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                    style: CustomFont.regularText.copyWith(color: greyColor),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: LoaderButton(
                  borderSide: tabColor,
                  color: backgroundColor,
                  fontWeight: FontWeight.w500,
                  btnText: 'Agree & Continue',
                  textColor: tabColor,
                  onTap: () async {
                    push(context, const LoginView());
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
