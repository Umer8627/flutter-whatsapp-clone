import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/images_path.dart';
import 'package:whatsapp_clone/utills/snippets.dart';
import '../handle_login.dart';
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      replace(context, const HandleLogin());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImagesPath.logo, width: 70, height: 80),
      ),
    );
  }
}
