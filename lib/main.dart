import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_clone/constants/theme_constant.dart';
import 'package:whatsapp_clone/firebase_options.dart';
import 'package:whatsapp_clone/state/timer_state.dart';
import 'package:whatsapp_clone/state/user_state.dart';
import 'package:whatsapp_clone/views/splash_view.dart';
import 'state/loading_state.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoadingState()),
      ChangeNotifierProvider(create: (_)=>TimerState()),
      ChangeNotifierProvider( create: (_) => UserState()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: getTheme(),
      home: const SplashView(),
    );
  }
}
